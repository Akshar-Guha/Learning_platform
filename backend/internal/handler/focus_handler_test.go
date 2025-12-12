package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/antigravity/backend/internal/domain"
	"github.com/antigravity/backend/internal/handler"
	"github.com/antigravity/backend/internal/middleware"
	"github.com/antigravity/backend/internal/mocks"
    "github.com/antigravity/backend/internal/service"
	"github.com/google/uuid"
)

func TestFocusHandler_StartFocus(t *testing.T) {
	mockService := &mocks.MockFocusService{}
	h := handler.NewFocusHandler(mockService)

	t.Run("Success", func(t *testing.T) {
		userID := uuid.New()
		squadID := uuid.New()
		sessionID := uuid.New()
		startedAt := time.Now()

		reqBody := domain.StartFocusRequest{
			SquadID: squadID,
		}
		expectedResp := &domain.StartFocusResponse{
			SessionID: sessionID,
			StartedAt: startedAt,
		}

		mockService.StartFocusFunc = func(ctx context.Context, uid, sid uuid.UUID) (*domain.StartFocusResponse, error) {
			if uid != userID {
				t.Errorf("expected userID %v, got %v", userID, uid)
			}
			if sid != squadID {
				t.Errorf("expected squadID %v, got %v", squadID, sid)
			}
			return expectedResp, nil
		}

		body, _ := json.Marshal(reqBody)
		req := httptest.NewRequest("POST", "/api/v1/focus/start", bytes.NewBuffer(body))
		ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
		req = req.WithContext(ctx)

		w := httptest.NewRecorder()
		h.StartFocus(w, req)

		if w.Code != http.StatusCreated {
			t.Errorf("expected status 201, got %d", w.Code)
		}
	})

    t.Run("AlreadyFocusing", func(t *testing.T) {
        userID := uuid.New()
		squadID := uuid.New()
		reqBody := domain.StartFocusRequest{
			SquadID: squadID,
		}

        mockService.StartFocusFunc = func(ctx context.Context, uid, sid uuid.UUID) (*domain.StartFocusResponse, error) {
			return nil, service.ErrAlreadyFocusing
		}

        body, _ := json.Marshal(reqBody)
		req := httptest.NewRequest("POST", "/api/v1/focus/start", bytes.NewBuffer(body))
		ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
		req = req.WithContext(ctx)

		w := httptest.NewRecorder()
		h.StartFocus(w, req)

        if w.Code != http.StatusConflict {
			t.Errorf("expected status 409, got %d", w.Code)
		}
    })
}
