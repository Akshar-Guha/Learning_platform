package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/middleware"
)

// SquadHandler handles HTTP requests for squads
type SquadHandler struct {
	service domain.SquadService
}

// NewSquadHandler creates a new squad handler
func NewSquadHandler(service domain.SquadService) *SquadHandler {
	return &SquadHandler{service: service}
}

// CreateSquad handles POST /api/v1/squads
func (h *SquadHandler) CreateSquad(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	var req domain.CreateSquadRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	squad, err := h.service.CreateSquad(r.Context(), userID, &req)
	if err != nil {
		handleSquadError(w, err)
		return
	}

	respondJSON(w, http.StatusCreated, squad)
}

// ListMySquads handles GET /api/v1/squads
func (h *SquadHandler) ListMySquads(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	squads, err := h.service.GetMySquads(r.Context(), userID)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch squads")
		return
	}

	respondJSON(w, http.StatusOK, map[string]interface{}{
		"data": squads,
	})
}

// GetSquadDetail handles GET /api/v1/squads/{squadID}
func (h *SquadHandler) GetSquadDetail(w http.ResponseWriter, r *http.Request) {
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

	detail, err := h.service.GetSquadDetail(r.Context(), squadID, userID)
	if err != nil {
		handleSquadError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, detail)
}

// UpdateSquad handles PATCH /api/v1/squads/{squadID}
func (h *SquadHandler) UpdateSquad(w http.ResponseWriter, r *http.Request) {
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

	var req domain.UpdateSquadRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	squad, err := h.service.UpdateSquad(r.Context(), squadID, userID, &req)
	if err != nil {
		handleSquadError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, squad)
}

// DeleteSquad handles DELETE /api/v1/squads/{squadID}
func (h *SquadHandler) DeleteSquad(w http.ResponseWriter, r *http.Request) {
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

	if err := h.service.DeleteSquad(r.Context(), squadID, userID); err != nil {
		handleSquadError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, map[string]string{"message": "Squad deleted successfully"})
}

// JoinSquad handles POST /api/v1/squads/join
func (h *SquadHandler) JoinSquad(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	var req domain.JoinSquadRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	if req.InviteCode == "" {
		respondError(w, http.StatusBadRequest, "INVITE_CODE_REQUIRED", "Invite code is required")
		return
	}

	squad, err := h.service.JoinSquad(r.Context(), userID, req.InviteCode)
	if err != nil {
		handleSquadError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, squad)
}

// RemoveMember handles DELETE /api/v1/squads/{squadID}/members/{userID}
func (h *SquadHandler) RemoveMember(w http.ResponseWriter, r *http.Request) {
	callerID := middleware.GetUserID(r.Context())
	if callerID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	squadID, err := uuid.Parse(chi.URLParam(r, "squadID"))
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_SQUAD_ID", "Invalid squad ID format")
		return
	}

	targetUserID, err := uuid.Parse(chi.URLParam(r, "userID"))
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_USER_ID", "Invalid user ID format")
		return
	}

	if err := h.service.RemoveMember(r.Context(), squadID, targetUserID, callerID); err != nil {
		handleSquadError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, map[string]string{"message": "Member removed successfully"})
}

// RegenerateCode handles POST /api/v1/squads/{squadID}/regenerate-code
func (h *SquadHandler) RegenerateCode(w http.ResponseWriter, r *http.Request) {
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

	newCode, err := h.service.RegenerateInviteCode(r.Context(), squadID, userID)
	if err != nil {
		handleSquadError(w, err)
		return
	}

	respondJSON(w, http.StatusOK, map[string]string{"invite_code": newCode})
}

// handleSquadError maps domain errors to HTTP responses
func handleSquadError(w http.ResponseWriter, err error) {
	switch {
	case errors.Is(err, domain.ErrSquadNotFound):
		respondError(w, http.StatusNotFound, "SQUAD_NOT_FOUND", "Squad not found")
	case errors.Is(err, domain.ErrNotSquadOwner):
		respondError(w, http.StatusForbidden, "NOT_OWNER", "Only squad owner can perform this action")
	case errors.Is(err, domain.ErrNotSquadMember):
		respondError(w, http.StatusForbidden, "NOT_MEMBER", "You are not a member of this squad")
	case errors.Is(err, domain.ErrSquadFull):
		respondError(w, http.StatusConflict, "SQUAD_FULL", "Squad is full")
	case errors.Is(err, domain.ErrAlreadyMember):
		respondError(w, http.StatusConflict, "ALREADY_MEMBER", "You are already a member of this squad")
	case errors.Is(err, domain.ErrInvalidInviteCode):
		respondError(w, http.StatusBadRequest, "INVALID_INVITE_CODE", "Invalid invite code")
	case errors.Is(err, domain.ErrCannotKickOwner):
		respondError(w, http.StatusForbidden, "CANNOT_KICK_OWNER", "Cannot kick squad owner")
	case errors.Is(err, domain.ErrSquadNameRequired):
		respondError(w, http.StatusBadRequest, "NAME_REQUIRED", "Squad name is required")
	case errors.Is(err, domain.ErrSquadNameTooLong):
		respondError(w, http.StatusBadRequest, "NAME_TOO_LONG", "Squad name must be 50 characters or less")
	default:
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "An unexpected error occurred")
	}
}
