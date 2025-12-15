package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/handler"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/mocks"
	"github.com/ulp/backend/internal/service"
)

// =============================================================================
// TEST HELPER: Creates a request with userID in context (simulates auth)
// =============================================================================
func withUserContext(r *http.Request, userID uuid.UUID) *http.Request {
	ctx := context.WithValue(r.Context(), middleware.UserIDKey, userID)
	return r.WithContext(ctx)
}

// =============================================================================
// TestGetMyProfile_Success
// Scenario: Authenticated user fetches their own profile
// Expected: 200 OK with profile data
// =============================================================================
func TestGetMyProfile_Success(t *testing.T) {
	// Arrange: Create mock service
	userID := uuid.New()
	expectedProfile := &domain.Profile{
		ID:          userID,
		Email:       "test@example.com",
		DisplayName: "Test User",
	}

	mockService := &mocks.MockProfileService{
		GetMyProfileFunc: func(ctx context.Context, id uuid.UUID) (*domain.Profile, error) {
			if id != userID {
				t.Errorf("Expected userID %v, got %v", userID, id)
			}
			return expectedProfile, nil
		},
	}

	h := handler.NewProfileHandler(mockService)

	// Act: Create request with auth context
	req := httptest.NewRequest(http.MethodGet, "/api/v1/profile/me", nil)
	req = withUserContext(req, userID)
	rec := httptest.NewRecorder()

	h.GetMyProfile(rec, req)

	// Assert
	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}

	var response domain.Profile
	if err := json.NewDecoder(rec.Body).Decode(&response); err != nil {
		t.Fatalf("Failed to decode response: %v", err)
	}

	if response.Email != expectedProfile.Email {
		t.Errorf("Expected email %s, got %s", expectedProfile.Email, response.Email)
	}
}

// =============================================================================
// TestGetMyProfile_Unauthorized
// Scenario: Request without auth token (no userID in context)
// Expected: 401 Unauthorized
// =============================================================================
func TestGetMyProfile_Unauthorized(t *testing.T) {
	mockService := &mocks.MockProfileService{}
	h := handler.NewProfileHandler(mockService)

	// Act: Request WITHOUT auth context
	req := httptest.NewRequest(http.MethodGet, "/api/v1/profile/me", nil)
	rec := httptest.NewRecorder()

	h.GetMyProfile(rec, req)

	// Assert
	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d", rec.Code)
	}
}

// =============================================================================
// TestGetMyProfile_NotFound
// Scenario: User has no profile (new user before profile creation)
// Expected: 404 Not Found
// =============================================================================
func TestGetMyProfile_NotFound(t *testing.T) {
	userID := uuid.New()

	mockService := &mocks.MockProfileService{
		GetMyProfileFunc: func(ctx context.Context, id uuid.UUID) (*domain.Profile, error) {
			return nil, service.ErrProfileNotFound
		},
	}

	h := handler.NewProfileHandler(mockService)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/profile/me", nil)
	req = withUserContext(req, userID)
	rec := httptest.NewRecorder()

	h.GetMyProfile(rec, req)

	if rec.Code != http.StatusNotFound {
		t.Errorf("Expected status 404, got %d", rec.Code)
	}
}

// =============================================================================
// TestUpdateMyProfile_Success
// Scenario: User updates their display name
// Expected: 200 OK with updated profile
// =============================================================================
func TestUpdateMyProfile_Success(t *testing.T) {
	userID := uuid.New()
	newName := "Updated Name"

	mockService := &mocks.MockProfileService{
		UpdateMyProfileFunc: func(ctx context.Context, id uuid.UUID, req *domain.UpdateProfileRequest) (*domain.Profile, error) {
			return &domain.Profile{
				ID:          id,
				DisplayName: *req.DisplayName,
			}, nil
		},
	}

	h := handler.NewProfileHandler(mockService)

	body := map[string]string{"display_name": newName}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPatch, "/api/v1/profile/me", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	req = withUserContext(req, userID)
	rec := httptest.NewRecorder()

	h.UpdateMyProfile(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}

	var response domain.Profile
	json.NewDecoder(rec.Body).Decode(&response)
	if response.DisplayName != newName {
		t.Errorf("Expected display_name %s, got %s", newName, response.DisplayName)
	}
}

// =============================================================================
// TestUpdateMyProfile_InvalidBody
// Scenario: Request with malformed JSON
// Expected: 400 Bad Request
// =============================================================================
func TestUpdateMyProfile_InvalidBody(t *testing.T) {
	userID := uuid.New()
	mockService := &mocks.MockProfileService{}
	h := handler.NewProfileHandler(mockService)

	req := httptest.NewRequest(http.MethodPatch, "/api/v1/profile/me", bytes.NewReader([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	req = withUserContext(req, userID)
	rec := httptest.NewRecorder()

	h.UpdateMyProfile(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d", rec.Code)
	}
}

// =============================================================================
// TestGetPublicProfile_Success
// Scenario: Fetch another user's public profile
// Expected: 200 OK with limited profile data
// =============================================================================
func TestGetPublicProfile_Success(t *testing.T) {
	targetUserID := uuid.New()

	mockService := &mocks.MockProfileService{
		GetPublicProfileFunc: func(ctx context.Context, id uuid.UUID) (*domain.PublicProfile, error) {
			return &domain.PublicProfile{
				ID:          id,
				DisplayName: "Public User",
			}, nil
		},
	}

	h := handler.NewProfileHandler(mockService)

	// Setup chi router for URL params
	router := chi.NewRouter()
	router.Get("/api/v1/profile/{userID}", h.GetPublicProfile)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/profile/"+targetUserID.String(), nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}
}

// =============================================================================
// TestGetPublicProfile_InvalidUUID
// Scenario: Invalid UUID in URL parameter
// Expected: 400 Bad Request
// =============================================================================
func TestGetPublicProfile_InvalidUUID(t *testing.T) {
	mockService := &mocks.MockProfileService{}
	h := handler.NewProfileHandler(mockService)

	router := chi.NewRouter()
	router.Get("/api/v1/profile/{userID}", h.GetPublicProfile)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/profile/not-a-valid-uuid", nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d", rec.Code)
	}
}
