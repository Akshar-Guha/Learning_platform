package handler

import (
	"net/http"
	"strconv"

	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/service"
	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

type NotificationHandler struct {
	service *service.NudgeService
}

func NewNotificationHandler(service *service.NudgeService) *NotificationHandler {
	return &NotificationHandler{service: service}
}

// ListNotifications handles GET /api/v1/notifications
func (h *NotificationHandler) ListNotifications(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	if userID == uuid.Nil {
		respondError(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing token")
		return
	}

	page, _ := strconv.Atoi(r.URL.Query().Get("page"))
	limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))

	resp, err := h.service.ListNotifications(r.Context(), userID, page, limit)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to fetch notifications")
		return
	}

	respondJSON(w, http.StatusOK, resp)
}

// MarkAsRead handles PATCH /api/v1/notifications/{id}/read
func (h *NotificationHandler) MarkAsRead(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	idStr := chi.URLParam(r, "id")
	id, err := uuid.Parse(idStr)

	if err != nil || userID == uuid.Nil {
		respondError(w, http.StatusBadRequest, "INVALID_REQUEST", "Invalid ID or Token")
		return
	}

	if err := h.service.MarkAsRead(r.Context(), id, userID); err != nil {
		respondError(w, http.StatusInternalServerError, "INTERNAL_ERROR", "Failed to update")
		return
	}

	respondJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}
