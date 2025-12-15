package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/handler"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/mocks"
	"github.com/ulp/backend/internal/service"
)

// =============================================================================
// TestStartFocus_Success
// Scenario: User starts a focus session in their squad
// Expected: 201 Created with session data
// =============================================================================
func TestStartFocus_Success(t *testing.T) {
	userID := uuid.New()
	squadID := uuid.New()

	mockService := &mocks.MockFocusService{
		StartFocusFunc: func(ctx context.Context, uID, sID uuid.UUID) (*domain.StartFocusResponse, error) {
			return &domain.StartFocusResponse{
				SessionID: uuid.New(),
				StartedAt: time.Now(),
			}, nil
		},
	}

	h := handler.NewFocusHandler(mockService)

	body := map[string]string{"squad_id": squadID.String()}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/focus/start", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.StartFocus(rec, req)

	if rec.Code != http.StatusCreated {
		t.Errorf("Expected status 201, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestStartFocus_NotMember
// Scenario: User tries to focus in a squad they're not a member of
// Expected: 403 Forbidden
// =============================================================================
func TestStartFocus_NotMember(t *testing.T) {
	userID := uuid.New()
	squadID := uuid.New()

	mockService := &mocks.MockFocusService{
		StartFocusFunc: func(ctx context.Context, uID, sID uuid.UUID) (*domain.StartFocusResponse, error) {
			return nil, service.ErrNotSquadMember
		},
	}

	h := handler.NewFocusHandler(mockService)

	body := map[string]string{"squad_id": squadID.String()}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/focus/start", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.StartFocus(rec, req)

	if rec.Code != http.StatusForbidden {
		t.Errorf("Expected status 403, got %d", rec.Code)
	}
}

// =============================================================================
// TestStopFocus_NoActiveSession
// Scenario: User tries to stop focus but has no active session
// Expected: 404 Not Found
// =============================================================================
func TestStopFocus_NoActiveSession(t *testing.T) {
	userID := uuid.New()

	mockService := &mocks.MockFocusService{
		StopFocusFunc: func(ctx context.Context, uID uuid.UUID) (*domain.StopFocusResponse, error) {
			return nil, service.ErrNoActiveSession
		},
	}

	h := handler.NewFocusHandler(mockService)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/focus/stop", nil)
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.StopFocus(rec, req)

	if rec.Code != http.StatusNotFound {
		t.Errorf("Expected status 404, got %d", rec.Code)
	}
}

// =============================================================================
// TestGetActiveInSquad_Success
// Scenario: User views active members in their squad
// Expected: 200 OK with active sessions
// =============================================================================
func TestGetActiveInSquad_Success(t *testing.T) {
	userID := uuid.New()
	squadID := uuid.New()

	mockService := &mocks.MockFocusService{
		GetActiveInSquadFunc: func(ctx context.Context, uID, sID uuid.UUID) (*domain.ActiveSessionsResponse, error) {
			return &domain.ActiveSessionsResponse{
				ActiveSessions: []domain.ActiveSession{
					{UserID: uuid.New(), DisplayName: "User 1", StartedAt: time.Now()},
				},
			}, nil
		},
	}

	h := handler.NewFocusHandler(mockService)

	router := chi.NewRouter()
	router.Get("/api/v1/focus/active/{squadID}", func(w http.ResponseWriter, r *http.Request) {
		ctx := context.WithValue(r.Context(), middleware.UserIDKey, userID)
		h.GetActiveInSquad(w, r.WithContext(ctx))
	})

	req := httptest.NewRequest(http.MethodGet, "/api/v1/focus/active/"+squadID.String(), nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}
}
