package main

import (
	"context"
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi/v5"
	chimiddleware "github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/joho/godotenv"
	"github.com/ulp/backend/internal/ai"
	"github.com/ulp/backend/internal/config"
	"github.com/ulp/backend/internal/eventbus"
	"github.com/ulp/backend/internal/handler"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/repository"
	"github.com/ulp/backend/internal/service"
)

func main() {
	// Load .env file (optional in production)
	_ = godotenv.Load()

	// Initialize config
	cfg := config.Load()

	// Initialize database connection
	db, err := repository.NewPostgresDB(cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	// Initialize Infrastructure
	// Start embedded NATS server for development (only if no external NATS URL configured)
	var embeddedNats *eventbus.EmbeddedNATSServer
	if cfg.NatsCredsFile == "" {
		embeddedNats, err = eventbus.StartEmbeddedNATS()
		if err != nil {
			log.Printf("Warning: Failed to start embedded NATS: %v", err)
		} else {
			defer embeddedNats.Shutdown()
		}
	}

	// Connect to NATS (embedded or Synadia Cloud)
	natsBus, err := eventbus.NewEventBusWithCreds(cfg.NatsURL, cfg.NatsCredsFile)
	if err != nil {
		log.Printf("Warning: Failed to connect to NATS: %v", err)
		// Proceeding without NATS for dev (or fail if required).
	} else {
		defer natsBus.Close()
	}

	groqClient := ai.NewGroqClient(cfg.GroqAPIKey)

	// Create Event Publisher
	var publisher *eventbus.Publisher
	if natsBus != nil {
		publisher = eventbus.NewPublisher(natsBus)
	}

	// Initialize layers (Clean Architecture)
	// Repository Layer
	profileRepo := repository.NewProfileRepository(db)
	squadRepo := repository.NewSquadRepository(db)
	focusRepo := repository.NewFocusRepository(db)
	streakRepo := repository.NewStreakRepository(db)
	notificationRepo := repository.NewNotificationRepository(db)
	goalsRepo := repository.NewGoalsRepository(db)
	focusStatsRepo := repository.NewFocusStatsRepository(db)

	// Service Layer
	profileService := service.NewProfileService(profileRepo)
	squadService := service.NewSquadService(squadRepo)
	focusService := service.NewFocusService(focusRepo, publisher)
	streakService := service.NewStreakService(streakRepo, publisher)
	nudgeService := service.NewNudgeService(notificationRepo, groqClient, natsBus)
	goalsService := service.NewGoalsService(goalsRepo, groqClient)

	// Handler Layer
	profileHandler := handler.NewProfileHandler(profileService)
	squadHandler := handler.NewSquadHandler(squadService)
	focusHandler := handler.NewFocusHandler(focusService)
	streakHandler := handler.NewStreakHandler(streakService)
	notificationHandler := handler.NewNotificationHandler(nudgeService)
	healthHandler := handler.NewHealthHandler()
	goalsHandler := handler.NewGoalsHandler(goalsService)
	focusStatsHandler := handler.NewFocusStatsHandler(focusStatsRepo)

	// Start Background Consumers
	if natsBus != nil {
		go func() {
			if err := nudgeService.StartConsumer(context.Background()); err != nil {
				log.Printf("Failed to start Nudge Consumer: %v", err)
			}
		}()
	}

	// Setup router
	r := chi.NewRouter()

	// Middleware
	r.Use(chimiddleware.Logger)
	r.Use(chimiddleware.Recoverer)
	r.Use(chimiddleware.RequestID)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   cfg.AllowedOrigins,
		AllowedMethods:   []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-Request-ID"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Routes
	r.Get("/api/v1/health", healthHandler.Health)

	// Protected routes
	r.Group(func(r chi.Router) {
		r.Use(middleware.AuthMiddleware(cfg.SupabaseJWTSecret))

		// Profile routes
		r.Get("/api/v1/profile/me", profileHandler.GetMyProfile)
		r.Patch("/api/v1/profile/me", profileHandler.UpdateMyProfile)
		r.Get("/api/v1/profile/{userID}", profileHandler.GetPublicProfile)

		// Squad routes
		r.Post("/api/v1/squads", squadHandler.CreateSquad)
		r.Get("/api/v1/squads", squadHandler.ListMySquads)
		r.Post("/api/v1/squads/join", squadHandler.JoinSquad)
		r.Get("/api/v1/squads/{squadID}", squadHandler.GetSquadDetail)
		r.Patch("/api/v1/squads/{squadID}", squadHandler.UpdateSquad)
		r.Delete("/api/v1/squads/{squadID}", squadHandler.DeleteSquad)
		r.Delete("/api/v1/squads/{squadID}/members/{userID}", squadHandler.RemoveMember)
		r.Post("/api/v1/squads/{squadID}/regenerate-code", squadHandler.RegenerateCode)

		// Focus routes (Body Doubling / Real-time Presence)
		r.Post("/api/v1/focus/start", focusHandler.StartFocus)
		r.Post("/api/v1/focus/stop", focusHandler.StopFocus)
		r.Get("/api/v1/focus/active/{squadID}", focusHandler.GetActiveInSquad)
		r.Get("/api/v1/focus/history/{squadID}", focusHandler.GetFocusHistory)

		// Focus Stats routes (Dashboard Metrics)
		r.Get("/api/v1/focus/stats/me", focusStatsHandler.GetMyStats)
		r.Get("/api/v1/focus/stats/squad/{squadID}", focusStatsHandler.GetSquadStats)
		r.Get("/api/v1/insights/recent", focusStatsHandler.GetRecentInsights)

		// Streak routes (The Streak Engine)
		r.Post("/api/v1/streaks/log", streakHandler.LogActivity)
		r.Get("/api/v1/streaks/me", streakHandler.GetMyStreak)
		r.Get("/api/v1/streaks/{userID}", streakHandler.GetUserStreak)
		r.Get("/api/v1/streaks/leaderboard", streakHandler.GetLeaderboard)
		r.Post("/api/v1/streaks/calculate", streakHandler.TriggerRecalculation)

		// Notification routes (The Nudge System)
		r.Get("/api/v1/notifications", notificationHandler.ListNotifications)
		r.Patch("/api/v1/notifications/{id}/read", notificationHandler.MarkAsRead)

		// Goals routes (AI Study Planner)
		r.Post("/api/v1/goals", goalsHandler.CreateGoal)
		r.Get("/api/v1/goals", goalsHandler.ListGoals)
		r.Get("/api/v1/goals/{goalID}", goalsHandler.GetGoal)
		r.Patch("/api/v1/goals/{goalID}", goalsHandler.UpdateGoal)
		r.Delete("/api/v1/goals/{goalID}", goalsHandler.DeleteGoal)
		r.Post("/api/v1/goals/{goalID}/generate-schedule", goalsHandler.GenerateSchedule)
	})

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🚀 Server starting on :%s", port)
	log.Printf("📍 CORS enabled for: %v", cfg.AllowedOrigins)

	if err := http.ListenAndServe(":"+port, r); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
