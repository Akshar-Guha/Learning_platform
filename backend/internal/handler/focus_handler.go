package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/service"
	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

// FocusHandler handles HTTP requests for focus sessions
type FocusHandler struct {
	service domain.FocusService
}

// NewFocusHandler creates a new focus handler
func NewFocusHandler(service domain.FocusService) *FocusHandler {
	return &FocusHandler{service: service}
}

// StartFocus handles POST /api/v1/focus/start
func (h *FocusHandler) StartFocus(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	var req domain.StartFocusRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	if req.SquadID == uuid.Nil {
		respondError(w, http.StatusBadRequest, "SQUAD_ID_REQUIRED", "squad_id is required")
		return
	}

	result, err := h.service.StartFocus(r.Context(), userID, req.SquadID)
	if err != nil {
		handleFocusError(w, err)
		return
	}

	respondJSON(w, http.StatusCreated, result)
}

// StopFocus handles POST /api/v1/focus/stop
func (h *FocusHandler) StopFocus(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	result, err := h.service.StopFocus(r.Context(), userID)
	if err != nil {
		handleFocusError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, result)
}

// GetActiveInSquad handles GET /api/v1/focus/active/{squad_id}
func (h *FocusHandler) GetActiveInSquad(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	squadID, err := uuid.Parse(chi.URLParam(r, "squadID"))
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_SQUAD_ID", "Invalid squad ID format")
		return
	}

	result, err := h.service.GetActiveInSquad(r.Context(), userID, squadID)
	if err != nil {
		handleFocusError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, result)
}

// GetFocusHistory handles GET /api/v1/focus/history/{squad_id}
func (h *FocusHandler) GetFocusHistory(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	squadID, err := uuid.Parse(chi.URLParam(r, "squadID"))
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_SQUAD_ID", "Invalid squad ID format")
		return
	}

	result, err := h.service.GetFocusHistory(r.Context(), userID, squadID)
	if err != nil {
		handleFocusError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, result)
}

// handleFocusError maps focus-specific errors to HTTP responses
func handleFocusError(w http.ResponseWriter, err error) {
	switch {
	case errors.Is(err, service.ErrNotSquadMember):
		respondError(w, http.StatusForbidden, "NOT_MEMBER", "You are not a member of this squad")
	case errors.Is(err, service.ErrNoActiveSession):
		respondError(w, http.StatusNotFound, "NO_ACTIVE_SESSION", "No active focus session to stop")
	case errors.Is(err, service.ErrAlreadyFocusing):
		respondError(w, http.StatusConflict, "ALREADY_FOCUSING", "You already have an active focus session")
	default:
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "An unexpected error occurred")
	}
}
