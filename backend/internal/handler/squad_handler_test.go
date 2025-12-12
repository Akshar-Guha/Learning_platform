package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/antigravity/backend/internal/domain"
	"github.com/antigravity/backend/internal/handler"
	"github.com/antigravity/backend/internal/middleware"
	"github.com/antigravity/backend/internal/mocks"
	"github.com/google/uuid"
)

func TestSquadHandler_CreateSquad(t *testing.T) {
	mockService := &mocks.MockSquadService{}
	h := handler.NewSquadHandler(mockService)

	t.Run("Success", func(t *testing.T) {
		userID := uuid.New()
		squadID := uuid.New()
		reqBody := domain.CreateSquadRequest{
			Name: "Test Squad",
		}
		expectedSquad := &domain.Squad{
			ID:      squadID,
			Name:    "Test Squad",
			OwnerID: userID,
		}

		mockService.CreateSquadFunc = func(ctx context.Context, uid uuid.UUID, req *domain.CreateSquadRequest) (*domain.Squad, error) {
			if uid != userID {
				t.Errorf("expected userID %v, got %v", userID, uid)
			}
			if req.Name != "Test Squad" {
				t.Errorf("expected squad name %s, got %s", "Test Squad", req.Name)
			}
			return expectedSquad, nil
		}

		body, _ := json.Marshal(reqBody)
		req := httptest.NewRequest("POST", "/api/v1/squads", bytes.NewBuffer(body))
		ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
		req = req.WithContext(ctx)

		w := httptest.NewRecorder()
		h.CreateSquad(w, req)

		if w.Code != http.StatusCreated {
			t.Errorf("expected status 201, got %d", w.Code)
		}

		var resp domain.Squad
		if err := json.NewDecoder(w.Body).Decode(&resp); err != nil {
			t.Fatal(err)
		}
		if resp.ID != squadID {
			t.Errorf("expected squad ID %v, got %v", squadID, resp.ID)
		}
	})

	t.Run("InvalidName", func(t *testing.T) {
		userID := uuid.New()
		reqBody := domain.CreateSquadRequest{Name: ""} // Invalid

		mockService.CreateSquadFunc = func(ctx context.Context, uid uuid.UUID, req *domain.CreateSquadRequest) (*domain.Squad, error) {
			return nil, domain.ErrSquadNameRequired
		}

		body, _ := json.Marshal(reqBody)
		req := httptest.NewRequest("POST", "/api/v1/squads", bytes.NewBuffer(body))
		ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
		req = req.WithContext(ctx)

		w := httptest.NewRecorder()
		h.CreateSquad(w, req)

		if w.Code != http.StatusBadRequest {
			t.Errorf("expected status 400, got %d", w.Code)
		}
	})
}
