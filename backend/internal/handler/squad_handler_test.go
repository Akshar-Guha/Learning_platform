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
)

// =============================================================================
// TestCreateSquad_Success
// Scenario: User creates a new squad
// Expected: 201 Created with squad data
// =============================================================================
func TestCreateSquad_Success(t *testing.T) {
	userID := uuid.New()
	squadID := uuid.New()

	mockService := &mocks.MockSquadService{
		CreateSquadFunc: func(ctx context.Context, id uuid.UUID, req *domain.CreateSquadRequest) (*domain.Squad, error) {
			return &domain.Squad{
				ID:   squadID,
				Name: req.Name,
			}, nil
		},
	}

	h := handler.NewSquadHandler(mockService)

	body := map[string]string{"name": "Study Group", "description": "A test squad"}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/squads", bytes.NewReader(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.CreateSquad(rec, req)

	if rec.Code != http.StatusCreated {
		t.Errorf("Expected status 201, got %d. Body: %s", rec.Code, rec.Body.String())
	}
}

// =============================================================================
// TestCreateSquad_Unauthorized
// Scenario: No auth token provided
// Expected: 401 Unauthorized
// =============================================================================
func TestCreateSquad_Unauthorized(t *testing.T) {
	mockService := &mocks.MockSquadService{}
	h := handler.NewSquadHandler(mockService)

	body := map[string]string{"name": "Test Squad"}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/squads", bytes.NewReader(jsonBody))
	rec := httptest.NewRecorder()

	h.CreateSquad(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status 401, got %d", rec.Code)
	}
}

// =============================================================================
// TestListMySquads_Success
// Scenario: User lists their squads
// Expected: 200 OK with squad array
// =============================================================================
func TestListMySquads_Success(t *testing.T) {
	userID := uuid.New()

	mockService := &mocks.MockSquadService{
		GetMySquadsFunc: func(ctx context.Context, id uuid.UUID) ([]domain.Squad, error) {
			return []domain.Squad{
				{ID: uuid.New(), Name: "Squad 1"},
				{ID: uuid.New(), Name: "Squad 2"},
			}, nil
		},
	}

	h := handler.NewSquadHandler(mockService)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/squads", nil)
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.ListMySquads(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}
}

// =============================================================================
// TestGetSquadDetail_Success
// Scenario: Member views squad details
// Expected: 200 OK with detailed squad info
// =============================================================================
func TestGetSquadDetail_Success(t *testing.T) {
	userID := uuid.New()
	squadID := uuid.New()

	mockService := &mocks.MockSquadService{
		GetSquadDetailFunc: func(ctx context.Context, sID, uID uuid.UUID) (*domain.SquadDetail, error) {
			return &domain.SquadDetail{
				ID:   sID,
				Name: "Test Squad",
			}, nil
		},
	}

	h := handler.NewSquadHandler(mockService)

	router := chi.NewRouter()
	router.Get("/api/v1/squads/{squadID}", func(w http.ResponseWriter, r *http.Request) {
		ctx := context.WithValue(r.Context(), middleware.UserIDKey, userID)
		h.GetSquadDetail(w, r.WithContext(ctx))
	})

	req := httptest.NewRequest(http.MethodGet, "/api/v1/squads/"+squadID.String(), nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}
}

// =============================================================================
// TestGetSquadDetail_NotFound
// Scenario: Squad doesn't exist
// Expected: 404 Not Found
// =============================================================================
func TestGetSquadDetail_NotFound(t *testing.T) {
	userID := uuid.New()
	squadID := uuid.New()

	mockService := &mocks.MockSquadService{
		GetSquadDetailFunc: func(ctx context.Context, sID, uID uuid.UUID) (*domain.SquadDetail, error) {
			return nil, domain.ErrSquadNotFound
		},
	}

	h := handler.NewSquadHandler(mockService)

	router := chi.NewRouter()
	router.Get("/api/v1/squads/{squadID}", func(w http.ResponseWriter, r *http.Request) {
		ctx := context.WithValue(r.Context(), middleware.UserIDKey, userID)
		h.GetSquadDetail(w, r.WithContext(ctx))
	})

	req := httptest.NewRequest(http.MethodGet, "/api/v1/squads/"+squadID.String(), nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusNotFound {
		t.Errorf("Expected status 404, got %d", rec.Code)
	}
}

// =============================================================================
// TestJoinSquad_Success
// Scenario: User joins squad with valid invite code
// Expected: 200 OK with joined squad
// =============================================================================
func TestJoinSquad_Success(t *testing.T) {
	userID := uuid.New()

	mockService := &mocks.MockSquadService{
		JoinSquadFunc: func(ctx context.Context, uID uuid.UUID, code string) (*domain.Squad, error) {
			return &domain.Squad{
				ID:   uuid.New(),
				Name: "Joined Squad",
			}, nil
		},
	}

	h := handler.NewSquadHandler(mockService)

	body := map[string]string{"invite_code": "ABC12345"}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/squads/join", bytes.NewReader(jsonBody))
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.JoinSquad(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status 200, got %d", rec.Code)
	}
}

// =============================================================================
// TestJoinSquad_InvalidCode
// Scenario: Invalid invite code
// Expected: 400 Bad Request
// =============================================================================
func TestJoinSquad_InvalidCode(t *testing.T) {
	userID := uuid.New()

	mockService := &mocks.MockSquadService{
		JoinSquadFunc: func(ctx context.Context, uID uuid.UUID, code string) (*domain.Squad, error) {
			return nil, domain.ErrInvalidInviteCode
		},
	}

	h := handler.NewSquadHandler(mockService)

	body := map[string]string{"invite_code": "INVALID"}
	jsonBody, _ := json.Marshal(body)

	req := httptest.NewRequest(http.MethodPost, "/api/v1/squads/join", bytes.NewReader(jsonBody))
	ctx := context.WithValue(req.Context(), middleware.UserIDKey, userID)
	req = req.WithContext(ctx)
	rec := httptest.NewRecorder()

	h.JoinSquad(rec, req)

	if rec.Code != http.StatusBadRequest {
		t.Errorf("Expected status 400, got %d", rec.Code)
	}
}

// =============================================================================
// TestDeleteSquad_NotOwner
// Scenario: Non-owner tries to delete squad
// Expected: 403 Forbidden
// =============================================================================
func TestDeleteSquad_NotOwner(t *testing.T) {
	userID := uuid.New()
	squadID := uuid.New()

	mockService := &mocks.MockSquadService{
		DeleteSquadFunc: func(ctx context.Context, sID, uID uuid.UUID) error {
			return domain.ErrNotSquadOwner
		},
	}

	h := handler.NewSquadHandler(mockService)

	router := chi.NewRouter()
	router.Delete("/api/v1/squads/{squadID}", func(w http.ResponseWriter, r *http.Request) {
		ctx := context.WithValue(r.Context(), middleware.UserIDKey, userID)
		h.DeleteSquad(w, r.WithContext(ctx))
	})

	req := httptest.NewRequest(http.MethodDelete, "/api/v1/squads/"+squadID.String(), nil)
	rec := httptest.NewRecorder()

	router.ServeHTTP(rec, req)

	if rec.Code != http.StatusForbidden {
		t.Errorf("Expected status 403, got %d", rec.Code)
	}
}
