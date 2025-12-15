package mocks

import (
	"context"

	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
)

type MockFocusService struct {
	StartFocusFunc       func(ctx context.Context, userID uuid.UUID, squadID uuid.UUID) (*domain.StartFocusResponse, error)
	StopFocusFunc        func(ctx context.Context, userID uuid.UUID) (*domain.StopFocusResponse, error)
	GetActiveInSquadFunc func(ctx context.Context, userID, squadID uuid.UUID) (*domain.ActiveSessionsResponse, error)
	GetFocusHistoryFunc  func(ctx context.Context, userID, squadID uuid.UUID) (*domain.FocusHistoryResponse, error)
}

func (m *MockFocusService) StartFocus(ctx context.Context, userID uuid.UUID, squadID uuid.UUID) (*domain.StartFocusResponse, error) {
	if m.StartFocusFunc != nil {
		return m.StartFocusFunc(ctx, userID, squadID)
	}
	return nil, nil
}

func (m *MockFocusService) StopFocus(ctx context.Context, userID uuid.UUID) (*domain.StopFocusResponse, error) {
	if m.StopFocusFunc != nil {
		return m.StopFocusFunc(ctx, userID)
	}
	return nil, nil
}

func (m *MockFocusService) GetActiveInSquad(ctx context.Context, userID, squadID uuid.UUID) (*domain.ActiveSessionsResponse, error) {
	if m.GetActiveInSquadFunc != nil {
		return m.GetActiveInSquadFunc(ctx, userID, squadID)
	}
	return nil, nil
}

func (m *MockFocusService) GetFocusHistory(ctx context.Context, userID, squadID uuid.UUID) (*domain.FocusHistoryResponse, error) {
	if m.GetFocusHistoryFunc != nil {
		return m.GetFocusHistoryFunc(ctx, userID, squadID)
	}
	return nil, nil
}
