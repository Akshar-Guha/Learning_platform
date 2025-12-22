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
	"github.com/ulp/backend/internal/handler"
	"github.com/ulp/backend/internal/middleware"
	"github.com/ulp/backend/internal/service"
)

// =============================================================================
// TestCreateGoal_MissingTitle
// Scenario: User tries to create a goal without title
// Expected: 400 Bad Request (validation fails before service call)
// =============================================================================
func TestCreateGoal_MissingTitle(t *testing.T) {
	userID := uuid.New()

	// nil service is okay - validation should fail before reaching service
	h := handler.NewGoalsHandler(nil)

	body := map[string]interface{}{
		"target_hours": 20,
		"deadline":     "2025-12-30",
		"priority":     1,
	}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/goals", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.CreateGoal(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestCreateGoal_MissingDeadline
// Scenario: User tries to create a goal without deadline
// Expected: 400 Bad Request
// =============================================================================
func TestCreateGoal_MissingDeadline(t *testing.T) {
	userID := uuid.New()

	h := handler.NewGoalsHandler(nil)

	body := map[string]interface{}{
		"title":        "Finals Preparation",
		"target_hours": 20,
		"priority":     1,
	}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/goals", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.CreateGoal(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestCreateGoal_InvalidTargetHours
// Scenario: User tries to create a goal with zero target hours
// Expected: 400 Bad Request
// =============================================================================
func TestCreateGoal_InvalidTargetHours(t *testing.T) {
	userID := uuid.New()

	h := handler.NewGoalsHandler(nil)

	body := map[string]interface{}{
		"title":        "Finals Preparation",
		"target_hours": 0, // Invalid
		"deadline":     "2025-12-30",
		"priority":     1,
	}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/goals", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.CreateGoal(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestCreateGoal_Unauthorized
// Scenario: Request without valid user ID
// Expected: 401 Unauthorized
// =============================================================================
func TestCreateGoal_Unauthorized(t *testing.T) {
	h := handler.NewGoalsHandler(nil)

	body := map[string]interface{}{
		"title":        "Finals Preparation",
		"target_hours": 20,
		"deadline":     "2025-12-30",
		"priority":     1,
	}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/goals", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	// No user ID in context
	rec := httptest.NewRecorder()

	h.CreateGoal(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestGetGoal_InvalidGoalID
// Scenario: Request with invalid UUID format
// Expected: 400 Bad Request
// =============================================================================
func TestGetGoal_InvalidGoalID(t *testing.T) {
	userID := uuid.New()

	h := handler.NewGoalsHandler(nil)

	router := chi.NewRouter()
	router.Get("/api/v1/goals/{goalID}", func(w http.ResponseWriter, r *http.Request) {
		ctx := context.WithValue(r.Context(), middleware.UserIDKey, userID)
		h.GetGoal(w, r.WithContext(ctx))
	})

	req := httptest.NewRequest(http.MethodGet, "/api/v1/goals/invalid-uuid", nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestGetGoal_Unauthorized
// Scenario: Request without valid user ID
// Expected: 401 Unauthorized
// =============================================================================
func TestGetGoal_Unauthorized(t *testing.T) {
	goalID := uuid.New()

	h := handler.NewGoalsHandler(nil)

	router := chi.NewRouter()
	router.Get("/api/v1/goals/{goalID}", h.GetGoal)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/goals/"+goalID.String(), nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestListGoals_Unauthorized
// Scenario: Request without valid user ID
// Expected: 401 Unauthorized
// =============================================================================
func TestListGoals_Unauthorized(t *testing.T) {
	h := handler.NewGoalsHandler(nil)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/goals", nil)
	// No user ID in context
	rec := httptest.NewRecorder()

	h.ListGoals(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestGenerateSchedule_InvalidGoalID
// Scenario: Generate schedule with invalid goal ID
// Expected: 400 Bad Request
// =============================================================================
func TestGenerateSchedule_InvalidGoalID(t *testing.T) {
	userID := uuid.New()

	h := handler.NewGoalsHandler(nil)

	router := chi.NewRouter()
	router.Post("/api/v1/goals/{goalID}/generate-schedule", func(w http.ResponseWriter, r *http.Request) {
		ctx := context.WithValue(r.Context(), middleware.UserIDKey, userID)
		h.GenerateSchedule(w, r.WithContext(ctx))
	})

	req := httptest.NewRequest(http.MethodPost, "/api/v1/goals/not-a-uuid/generate-schedule", nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestGenerateSchedule_Unauthorized
// Scenario: Request without valid user ID
// Expected: 401 Unauthorized
// =============================================================================
func TestGenerateSchedule_Unauthorized(t *testing.T) {
	goalID := uuid.New()

	h := handler.NewGoalsHandler(nil)

	router := chi.NewRouter()
	router.Post("/api/v1/goals/{goalID}/generate-schedule", h.GenerateSchedule)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/goals/"+goalID.String()+"/generate-schedule", nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// Note: Tests that require actual service (CreateGoal success, GetGoal success, etc.)
// are skipped here since they need database mocking. These are validated via
// the existing mock pattern used in focus_handler_test.go.
var _ = service.GoalsService{} // Ensure import isn't removed
