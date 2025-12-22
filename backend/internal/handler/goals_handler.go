package handler

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/service"
)

// GoalsHandler handles HTTP requests for study goals
type GoalsHandler struct {
	service *service.GoalsService
}

// NewGoalsHandler creates a new goals handler
func NewGoalsHandler(service *service.GoalsService) *GoalsHandler {
	return &GoalsHandler{service: service}
}

// CreateGoal handles POST /api/v1/goals
func (h *GoalsHandler) CreateGoal(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		log.Printf("[GoalsHandler.CreateGoal] Unauthorized request")
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	var req domain.CreateGoalRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		log.Printf("[GoalsHandler.CreateGoal] Invalid request body: %v", err)
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	// Validate required fields
	if req.Title == "" {
		respondError(w, http.StatusBadRequest, "TITLE_REQUIRED", "Title is required")
		return
	}
	if req.TargetHours <= 0 {
		respondError(w, http.StatusBadRequest, "INVALID_TARGET_HOURS", "Target hours must be positive")
		return
	}
	if req.Deadline == "" {
		respondError(w, http.StatusBadRequest, "DEADLINE_REQUIRED", "Deadline is required")
		return
	}
	if req.Priority < 1 || req.Priority > 3 {
		req.Priority = 2 // Default to medium
	}

	goal, err := h.service.CreateGoal(r.Context(), userID, req)
	if err != nil {
		handleGoalError(w, err)
		return
	}

	log.Printf("[GoalsHandler.CreateGoal] Goal created: %s for user %s", goal.ID, userID)
	respondJSON(w, http.StatusCreated, domain.GoalResponse{Goal: *goal})
}

// GetGoal handles GET /api/v1/goals/{goalID}
func (h *GoalsHandler) GetGoal(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	goalID, err := uuid.Parse(chi.URLParam(r, "goalID"))
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_GOAL_ID", "Invalid goal ID format")
		return
	}

	goal, err := h.service.GetGoal(r.Context(), userID, goalID)
	if err != nil {
		handleGoalError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, domain.GoalResponse{Goal: *goal})
}

// ListGoals handles GET /api/v1/goals
func (h *GoalsHandler) ListGoals(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	// Check for active_only query param
	activeOnly := r.URL.Query().Get("active") == "true"

	goals, err := h.service.ListGoals(r.Context(), userID, activeOnly)
	if err != nil {
		handleGoalError(w, err)
		return
	}

	log.Printf("[GoalsHandler.ListGoals] Returning %d goals for user %s", len(goals), userID)
	respondJSON(w, http.StatusOK, domain.GoalsListResponse{
		Goals:      goals,
		TotalCount: len(goals),
	})
}

// UpdateGoal handles PATCH /api/v1/goals/{goalID}
func (h *GoalsHandler) UpdateGoal(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	goalID, err := uuid.Parse(chi.URLParam(r, "goalID"))
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_GOAL_ID", "Invalid goal ID format")
		return
	}

	var req domain.UpdateGoalRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	goal, err := h.service.UpdateGoal(r.Context(), userID, goalID, req)
	if err != nil {
		handleGoalError(w, err)
		return
	}

	log.Printf("[GoalsHandler.UpdateGoal] Goal updated: %s", goalID)
	respondJSON(w, http.StatusOK, domain.GoalResponse{Goal: *goal})
}

// DeleteGoal handles DELETE /api/v1/goals/{goalID}
func (h *GoalsHandler) DeleteGoal(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	goalID, err := uuid.Parse(chi.URLParam(r, "goalID"))
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_GOAL_ID", "Invalid goal ID format")
		return
	}

	err = h.service.DeleteGoal(r.Context(), userID, goalID)
	if err != nil {
		handleGoalError(w, err)
		return
	}

	log.Printf("[GoalsHandler.DeleteGoal] Goal archived: %s", goalID)
	respondJSON(w, http.StatusOK, map[string]string{
		"message": "Goal archived successfully",
	})
}

// GenerateSchedule handles POST /api/v1/goals/{goalID}/generate-schedule
func (h *GoalsHandler) GenerateSchedule(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	goalID, err := uuid.Parse(chi.URLParam(r, "goalID"))
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_GOAL_ID", "Invalid goal ID format")
		return
	}

	schedule, err := h.service.GenerateSchedule(r.Context(), userID, goalID)
	if err != nil {
		handleGoalError(w, err)
		return
	}

	log.Printf("[GoalsHandler.GenerateSchedule] Schedule generated for goal: %s", goalID)
	respondJSON(w, http.StatusOK, domain.GenerateScheduleResponse{
		Schedule:  *schedule,
		Generated: true,
		Message:   "AI schedule generated successfully",
	})
}

// handleGoalError maps goal-specific errors to HTTP responses
func handleGoalError(w http.ResponseWriter, err error) {
	log.Printf("[GoalsHandler] Error: %v", err)

	switch {
	case errors.Is(err, domain.ErrGoalNotFound):
		respondError(w, http.StatusNotFound, "GOAL_NOT_FOUND", "Goal not found")
	case errors.Is(err, domain.ErrGoalLimitReached):
		respondError(w, http.StatusConflict, "GOAL_LIMIT_REACHED", "Maximum 5 active goals allowed. Archive or complete existing goals first.")
	case errors.Is(err, domain.ErrScheduleAlreadyGenerated):
		respondError(w, http.StatusConflict, "SCHEDULE_EXISTS", "AI schedule already generated for this goal")
	case errors.Is(err, domain.ErrInvalidDeadline):
		respondError(w, http.StatusBadRequest, "INVALID_DEADLINE", "Deadline must be in the future (format: YYYY-MM-DD)")
	default:
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "An unexpected error occurred")
	}
}
