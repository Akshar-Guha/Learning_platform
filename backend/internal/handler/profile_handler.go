package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/service"
)

// ProfileHandler handles HTTP requests for profiles
type ProfileHandler struct {
	service domain.ProfileService
}

// NewProfileHandler creates a new profile handler
func NewProfileHandler(service domain.ProfileService) *ProfileHandler {
	return &ProfileHandler{service: service}
}

// GetMyProfile handles GET /api/v1/profile/me
func (h *ProfileHandler) GetMyProfile(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	profile, err := h.service.GetMyProfile(r.Context(), userID)
	if err != nil {
		if errors.Is(err, service.ErrProfileNotFound) {
			respondError(w, http.StatusNotFound, "PROFILE_NOT_FOUND", "Profile not found")
			return
		}
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch profile")
		return
	}

	respondJSON(w, http.StatusOK, profile)
}

// UpdateMyProfile handles PATCH /api/v1/profile/me
func (h *ProfileHandler) UpdateMyProfile(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid token")
		return
	}

	var req domain.UpdateProfileRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid request body")
		return
	}

	profile, err := h.service.UpdateMyProfile(r.Context(), userID, &req)
	if err != nil {
		if errors.Is(err, service.ErrProfileNotFound) {
			respondError(w, http.StatusNotFound, "PROFILE_NOT_FOUND", "Profile not found")
			return
		}
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to update profile")
		return
	}

	respondJSON(w, http.StatusOK, profile)
}

// GetPublicProfile handles GET /api/v1/profile/{userID}
func (h *ProfileHandler) GetPublicProfile(w http.ResponseWriter, r *http.Request) {
	userIDStr := chi.URLParam(r, "userID")
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		respondError(w, http.StatusBadRequest, "INVALID_USER_ID", "Invalid user ID format")
		return
	}

	profile, err := h.service.GetPublicProfile(r.Context(), userID)
	if err != nil {
		if errors.Is(err, service.ErrProfileNotFound) {
			respondError(w, http.StatusNotFound, "PROFILE_NOT_FOUND", "Profile not found")
			return
		}
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch profile")
		return
	}

	respondJSON(w, http.StatusOK, profile)
}

// HealthHandler handles health check endpoints
type HealthHandler struct{}

// NewHealthHandler creates a new health handler
func NewHealthHandler() *HealthHandler {
	return &HealthHandler{}
}

// Health handles GET /api/v1/health
func (h *HealthHandler) Health(w http.ResponseWriter, r *http.Request) {
	respondJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

// Helper functions - Removed (Moved to utils.go)
