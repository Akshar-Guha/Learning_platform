package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/handler"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/mocks"
	"github.com/ulp/backend/internal/service"
	"github.com/google/uuid"
)

func TestProfileHandler_GetMyProfile(t *testing.T) {
	mockService := &mocks.MockProfileService{}
	h := handler.NewProfileHandler(mockService)

	t.Run("Success", func(t *testing.T) {
		userID := uuid.New()
		expectedProfile := &domain.Profile{
			ID:          userID,
			Email:       "test@example.com",
			DisplayName: "Test User",
		}

		mockService.GetMyProfileFunc = func(ctx context.Context, uid uuid.UUID) (*domain.Profile, error) {
			if uid != userID {
				t.Errorf("expected userID %v, got %v", userID, uid)
			}
			return expectedProfile, nil
		}

		req := httptest.NewRequest("GET", "/api/v1/profile/me", nil)
		ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
		req = req.WithContext(ctx)

		w := httptest.NewRecorder()
		h.GetMyProfile(w, req)

		if w.Code != http.StatusOK {
			t.Errorf("expected status 200, got %d", w.Code)
		}

		var resp domain.Profile
		if err := json.NewDecoder(w.Body).Decode(&resp); err != nil {
			t.Fatal(err)
		}
		if resp.ID != expectedProfile.ID {
			t.Errorf("expected profile ID %v, got %v", expectedProfile.ID, resp.ID)
		}
	})

	t.Run("Unauthorized_NoUserID", func(t *testing.T) {
		req := httptest.NewRequest("GET", "/api/v1/profile/me", nil)
		// No UserID in context

		w := httptest.NewRecorder()
		h.GetMyProfile(w, req)

		if w.Code != http.StatusUnauthorized {
			t.Errorf("expected status 401, got %d", w.Code)
		}
	})

	t.Run("NotFound", func(t *testing.T) {
		userID := uuid.New()
		mockService.GetMyProfileFunc = func(ctx context.Context, uid uuid.UUID) (*domain.Profile, error) {
			return nil, service.ErrProfileNotFound
		}

		req := httptest.NewRequest("GET", "/api/v1/profile/me", nil)
		ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
		req = req.WithContext(ctx)

		w := httptest.NewRecorder()
		h.GetMyProfile(w, req)

		if w.Code != http.StatusNotFound {
			t.Errorf("expected status 404, got %d", w.Code)
		}
	})
}

func TestProfileHandler_UpdateMyProfile(t *testing.T) {
	mockService := &mocks.MockProfileService{}
	h := handler.NewProfileHandler(mockService)

	t.Run("Success", func(t *testing.T) {
		userID := uuid.New()
		newName := "Updated Name"
		reqBody := domain.UpdateProfileRequest{
			DisplayName: &newName,
		}
		expectedProfile := &domain.Profile{
			ID:          userID,
			DisplayName: newName,
		}

		mockService.UpdateMyProfileFunc = func(ctx context.Context, uid uuid.UUID, req *domain.UpdateProfileRequest) (*domain.Profile, error) {
			if uid != userID {
				t.Errorf("expected userID %v, got %v", userID, uid)
			}
			if req.DisplayName == nil || *req.DisplayName != newName {
				t.Error("expected display name to be updated")
			}
			return expectedProfile, nil
		}

		body, _ := json.Marshal(reqBody)
		req := httptest.NewRequest("PATCH", "/api/v1/profile/me", bytes.NewBuffer(body))
		ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
		req = req.WithContext(ctx)

		w := httptest.NewRecorder()
		h.UpdateMyProfile(w, req)

		if w.Code != http.StatusOK {
			t.Errorf("expected status 200, got %d", w.Code)
		}
	})
    
    t.Run("InternalError", func(t *testing.T) {
		userID := uuid.New()
		mockService.UpdateMyProfileFunc = func(ctx context.Context, uid uuid.UUID, req *domain.UpdateProfileRequest) (*domain.Profile, error) {
			return nil, errors.New("db error")
		}

		reqBody := domain.UpdateProfileRequest{}
        body, _ := json.Marshal(reqBody)
		req := httptest.NewRequest("PATCH", "/api/v1/profile/me", bytes.NewBuffer(body))
		ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
		req = req.WithContext(ctx)

		w := httptest.NewRecorder()
		h.UpdateMyProfile(w, req)

		if w.Code != http.StatusInternalServerError {
			t.Errorf("expected status 500, got %d", w.Code)
		}
	})
}
