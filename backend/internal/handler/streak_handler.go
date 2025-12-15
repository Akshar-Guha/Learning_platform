package handler

import (
	"encoding/json"
	"errors"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/service"
)

// StreakHandler handles HTTP requests for streak management
type StreakHandler struct {
	service domain.StreakService
}

// NewStreakHandler creates a new streak handler
func NewStreakHandler(service domain.StreakService) *StreakHandler {
	return &StreakHandler{service: service}
}

// LogActivity handles POST /api/v1/streaks/log
// Logs manual check-in activity for the day
func (h *StreakHandler) LogActivity(w http.ResponseWriter, r *http.Request) {
	userIDStr := middleware.GetUserIDString(r.Context())
	if userIDStr == "" {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	var req domain.LogActivityRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	// Validate activity type
	if err := h.service.ValidateActivityType(req.ActivityType); err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_ACTIVITY_TYPE", err.Error())
		return
	}

	// Only allow manual_checkin from this endpoint
	if req.ActivityType != domain.ActivityTypeManualCheckin {
		respondError(w, http.StatusBadRequest, "INVALID_ACTIVITY_TYPE", "Only manual_checkin is allowed from this endpoint")
		return
	}

	result, err := h.service.LogManualCheckin(r.Context(), userIDStr)
	if err != nil {
		handleStreakError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, result)
}

// GetMyStreak handles GET /api/v1/streaks/me
// Returns the authenticated user's full streak data with history
func (h *StreakHandler) GetMyStreak(w http.ResponseWriter, r *http.Request) {
	userIDStr := middleware.GetUserIDString(r.Context())
	if userIDStr == "" {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	streakData, err := h.service.GetMyStreak(r.Context(), userIDStr)
	if err != nil {
		handleStreakError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, streakData)
}

// GetUserStreak handles GET /api/v1/streaks/{user_id}
// Returns another user's public streak data (no history)
func (h *StreakHandler) GetUserStreak(w http.ResponseWriter, r *http.Request) {
	targetUserID := chi.URLParam(r, "userID")
	if targetUserID == "" {
		respondError(w, http.StatusBadRequest, "INVALID_USER_ID", "User ID is required")
		return
	}

	streakData, err := h.service.GetUserPublicStreak(r.Context(), targetUserID)
	if err != nil {
		handleStreakError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, streakData)
}

// GetLeaderboard handles GET /api/v1/streaks/leaderboard
// Returns top users by current streak
func (h *StreakHandler) GetLeaderboard(w http.ResponseWriter, r *http.Request) {
	// Parse optional limit query parameter
	limitStr := r.URL.Query().Get("limit")
	limit := 50 // Default
	if limitStr != "" {
		if parsedLimit, err := strconv.Atoi(limitStr); err == nil && parsedLimit > 0 {
			limit = parsedLimit
		}
	}

	leaderboard, err := h.service.GetLeaderboard(r.Context(), limit)
	if err != nil {
		handleStreakError(w, err)
		return
	}

	response := map[string]interface{}{
		"leaderboard": leaderboard,
	}

	respondJSON(w, http.StatusOK, response)
}

// TriggerRecalculation handles POST /api/v1/streaks/calculate
// Triggers streak recalculation for all users (admin/cron only)
func (h *StreakHandler) TriggerRecalculation(w http.ResponseWriter, r *http.Request) {
	// This endpoint should be protected by service role middleware
	// Only accessible via API key or cron job
	err := h.service.TriggerRecalculation(r.Context())
	if err != nil {
		handleStreakError(w, err)
		return
	}

	response := map[string]interface{}{
		"success": true,
		"message": "Streak recalculation triggered successfully",
	}

	respondJSON(w, http.StatusOK, response)
}

// handleStreakError maps streak-specific errors to HTTP responses
func handleStreakError(w http.ResponseWriter, err error) {
	switch {
	case errors.Is(err, service.ErrInvalidActivityType):
		respondError(w, http.StatusBadRequest, "INVALID_ACTIVITY_TYPE", err.Error())
	default:
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "An unexpected error occurred")
	}
}
