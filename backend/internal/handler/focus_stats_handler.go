package handler

import (
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/repository"
)

// FocusStatsHandler handles HTTP requests for focus statistics
type FocusStatsHandler struct {
	repo *repository.FocusStatsRepository
}

// NewFocusStatsHandler creates a new focus stats handler
func NewFocusStatsHandler(repo *repository.FocusStatsRepository) *FocusStatsHandler {
	return &FocusStatsHandler{repo: repo}
}

// GetMyStats handles GET /api/v1/focus/stats/me
// Returns aggregated focus statistics for the current user
func (h *FocusStatsHandler) GetMyStats(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		log.Printf("[FocusStatsHandler.GetMyStats] Unauthorized request")
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	stats, err := h.repo.GetUserStats(r.Context(), userID)
	if err != nil {
		log.Printf("[FocusStatsHandler.GetMyStats] Error fetching stats: %v", err)
		respondError(w, http.StatusInternalServerError, "STATS_ERROR", "Failed to retrieve statistics")
		return
	}

	log.Printf("[FocusStatsHandler.GetMyStats] Returning stats for user %s", userID)
	respondJSON(w, http.StatusOK, domain.FocusStatsResponse{Stats: *stats})
}

// GetSquadStats handles GET /api/v1/focus/stats/squad/{squadID}
// Returns aggregated focus statistics for a squad
func (h *FocusStatsHandler) GetSquadStats(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		log.Printf("[FocusStatsHandler.GetSquadStats] Unauthorized request")
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	squadID, err := uuid.Parse(chi.URLParam(r, "squadID"))
	if err != nil {
		log.Printf("[FocusStatsHandler.GetSquadStats] Invalid squad ID: %v", err)
		respondError(w, http.StatusBadRequest, "INVALID_SQUAD_ID", "Invalid squad ID format")
		return
	}

	// Note: Squad membership validation should be done in service layer
	// For now, we trust the user can access if they know the ID

	stats, err := h.repo.GetSquadStats(r.Context(), squadID)
	if err != nil {
		log.Printf("[FocusStatsHandler.GetSquadStats] Error fetching stats: %v", err)
		respondError(w, http.StatusInternalServerError, "STATS_ERROR", "Failed to retrieve squad statistics")
		return
	}

	log.Printf("[FocusStatsHandler.GetSquadStats] Returning stats for squad %s", squadID)
	respondJSON(w, http.StatusOK, domain.SquadStatsResponse{Stats: *stats})
}

// GetRecentInsights handles GET /api/v1/insights/recent
// Returns the last 10 AI-generated insights for the user
func (h *FocusStatsHandler) GetRecentInsights(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		log.Printf("[FocusStatsHandler.GetRecentInsights] Unauthorized request")
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	// Default limit of 10 insights
	limit := 10

	insights, err := h.repo.GetRecentInsights(r.Context(), userID, limit)
	if err != nil {
		log.Printf("[FocusStatsHandler.GetRecentInsights] Error fetching insights: %v", err)
		respondError(w, http.StatusInternalServerError, "INSIGHTS_ERROR", "Failed to retrieve insights")
		return
	}

	log.Printf("[FocusStatsHandler.GetRecentInsights] Returning %d insights for user %s", len(insights), userID)
	respondJSON(w, http.StatusOK, domain.InsightsListResponse{
		Insights:   insights,
		TotalCount: len(insights),
	})
}
