package service

import (
	"context"
	"encoding/json"
	"log"

	"github.com/antigravity/backend/internal/ai"
	"github.com/antigravity/backend/internal/domain"
	"github.com/antigravity/backend/internal/eventbus"
	"github.com/antigravity/backend/internal/repository"
	"github.com/google/uuid"
)

type NudgeService struct {
	repo *repository.NotificationRepository
	ai   *ai.GroqClient
	bus  *eventbus.EventBus
}

func NewNudgeService(repo *repository.NotificationRepository, ai *ai.GroqClient, bus *eventbus.EventBus) *NudgeService {
	return &NudgeService{
		repo: repo,
		ai:   ai,
		bus:  bus,
	}
}

// StartConsumer subscribes to risk events and processes them
func (s *NudgeService) StartConsumer(ctx context.Context) error {
	streamName := "ANTIGRAVITY"
	subject := "events.streak.risk"

	// Ensure stream exists
	if err := s.bus.InitStream(ctx, streamName, []string{"events.>"}); err != nil {
		log.Printf("Warning: Failed to init stream (might already exist): %v", err)
	}

	log.Printf("📡 Starting Nudge Consumer on %s...", subject)

	return s.bus.Subscribe(ctx, streamName, subject, "nudge_processor", func(msg []byte) error {
		var event domain.NudgeEvent
		if err := json.Unmarshal(msg, &event); err != nil {
			return err
		}
		return s.HandleRiskEvent(ctx, event)
	})
}

// HandleRiskEvent processes a single risk event
func (s *NudgeService) HandleRiskEvent(ctx context.Context, event domain.NudgeEvent) error {
	log.Printf("⚠️ Risk detected for user %s: %s", event.UserName, event.RiskFactor)

	// 1. Generate AI Nudge
	nudgeMsg, err := s.ai.GenerateNudge(ctx, event.UserName, event.StreakDays, event.RiskFactor)
	if err != nil {
		log.Printf("AI Error (falling back to default): %v", err)
		nudgeMsg = "Keep your streak alive! You got this!"
	}

	// 2. Create Notification
	notification := &domain.Notification{
		UserID:   event.UserID,
		Type:     "streak_alert", // or "nudge"
		Title:    "Streak at Risk! 🔥",
		Message:  nudgeMsg,
		Metadata: json.RawMessage(`{"risk_factor": "` + event.RiskFactor + `"}`),
	}

	// 3. Persist
	if err := s.repo.Create(ctx, notification); err != nil {
		log.Printf("DB Error: %v", err)
		return err
	}

	log.Printf("✅ Nudge sent to %s: %q", event.UserName, nudgeMsg)
	return nil
}

// ListNotifications for API
func (s *NudgeService) ListNotifications(ctx context.Context, userID uuid.UUID, page, limit int) (*domain.NotificationResponse, error) {
	if page < 1 {
		page = 1
	}
	if limit < 1 {
		limit = 20
	}
	offset := (page - 1) * limit

	data, total, err := s.repo.List(ctx, userID, limit, offset)
	if err != nil {
		return nil, err
	}

	return &domain.NotificationResponse{
		Data: data,
		Meta: domain.PaginationMeta{
			Total: total,
			Page:  page,
			Limit: limit,
		},
	}, nil
}

// MarkAsRead
func (s *NudgeService) MarkAsRead(ctx context.Context, id uuid.UUID, userID uuid.UUID) error {
	return s.repo.MarkAsRead(ctx, id, userID)
}
