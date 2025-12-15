package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/handler"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/mocks"
	"github.com/ulp/backend/internal/service"
)

// =============================================================================
// Helper: Creates request with user ID string in context
// =============================================================================
func withStringUserContext(r *http.Request, userID uuid.UUID) *http.Request {
	ctx := context.WithValue(r.Context(), middleware.UserIDKey, userID)
	return r.WithContext(ctx)
}

// =============================================================================
// TestLogActivity_Success
// Scenario: User logs a manual check-in activity
// Expected: 200 OK with activity response
// =============================================================================
func TestLogActivity_Success(t *testing.T) {
	userID := uuid.New()

	mockService := &mocks.MockStreakService{
		ValidateActivityTypeFunc: func(activityType domain.ActivityType) error {
			return nil
		},
		LogManualCheckinFunc: func(ctx context.Context, id string) (*domain.LogActivityResponse, error) {
			return &domain.LogActivityResponse{
				Success:       true,
				ActivityDate:  time.Now(),
				CurrentStreak: 5,
			}, nil
		},
	}

	h := handler.NewStreakHandler(mockService)

	body := map[string]string{"activity_type": "manual_checkin"}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/streaks/log", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	req = withStringUserContext(req, userID)
	rec := httptest.NewRecorder()

	h.LogActivity(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestLogActivity_InvalidType
// Scenario: User tries to log with invalid activity type
// Expected: 400 Bad Request
// =============================================================================
func TestLogActivity_InvalidType(t *testing.T) {
	userID := uuid.New()

	mockService := &mocks.MockStreakService{
		ValidateActivityTypeFunc: func(activityType domain.ActivityType) error {
			return service.ErrInvalidActivityType
		},
	}

	h := handler.NewStreakHandler(mockService)

	body := map[string]string{"activity_type": "invalid_type"}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/streaks/log", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	req = withStringUserContext(req, userID)
	rec := httptest.NewRecorder()

	h.LogActivity(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d", rec.Code)
	}
}

// =============================================================================
// TestGetMyStreak_Success
// Scenario: User views their streak data
// Expected: 200 OK with streak data
// =============================================================================
func TestGetMyStreak_Success(t *testing.T) {
	userID := uuid.New()

	mockService := &mocks.MockStreakService{
		GetMyStreakFunc: func(ctx context.Context, id string) (*domain.StreakData, error) {
			return &domain.StreakData{
				UserID:        id,
				CurrentStreak: 10,
				LongestStreak: 15,
			}, nil
		},
	}

	h := handler.NewStreakHandler(mockService)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/streaks/me", nil)
	req = withStringUserContext(req, userID)
	rec := httptest.NewRecorder()

	h.GetMyStreak(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}

	var response domain.StreakData
	json.NewDecoder(rec.Body).Decode(&response)
	if response.CurrentStreak != 10 {
		t.Errorf("Expected streak 10, got %d", response.CurrentStreak)
	}
}

// =============================================================================
// TestGetLeaderboard_Success
// Scenario: User views the streak leaderboard
// Expected: 200 OK with leaderboard entries
// =============================================================================
func TestGetLeaderboard_Success(t *testing.T) {
	mockService := &mocks.MockStreakService{
		GetLeaderboardFunc: func(ctx context.Context, limit int) ([]domain.LeaderboardEntry, error) {
			return []domain.LeaderboardEntry{
				{Rank: 1, UserID: uuid.New().String(), DisplayName: "Top User", CurrentStreak: 100},
				{Rank: 2, UserID: uuid.New().String(), DisplayName: "Second", CurrentStreak: 90},
			}, nil
		},
	}

	h := handler.NewStreakHandler(mockService)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/streaks/leaderboard", nil)
	rec := httptest.NewRecorder()

	h.GetLeaderboard(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}
}
