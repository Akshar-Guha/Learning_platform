package mocks

import (
	"context"

	"github.com/ulp/backend/internal/domain"
)

// MockStreakService is a mock implementation of domain.StreakService
type MockStreakService struct {
	LogManualCheckinFunc     func(ctx context.Context, userID string) (*domain.LogActivityResponse, error)
	LogFocusSessionFunc      func(ctx context.Context, userID string, sessionID string, duration int) (*domain.LogActivityResponse, error)
	GetMyStreakFunc          func(ctx context.Context, userID string) (*domain.StreakData, error)
	GetUserPublicStreakFunc  func(ctx context.Context, userID string) (*domain.StreakData, error)
	GetLeaderboardFunc       func(ctx context.Context, limit int) ([]domain.LeaderboardEntry, error)
	TriggerRecalculationFunc func(ctx context.Context) error
	ValidateActivityTypeFunc func(activityType domain.ActivityType) error
}

func (m *MockStreakService) LogManualCheckin(ctx context.Context, userID string) (*domain.LogActivityResponse, error) {
	if m.LogManualCheckinFunc != nil {
		return m.LogManualCheckinFunc(ctx, userID)
	}
	return nil, nil
}

func (m *MockStreakService) LogFocusSession(ctx context.Context, userID string, sessionID string, duration int) (*domain.LogActivityResponse, error) {
	if m.LogFocusSessionFunc != nil {
		return m.LogFocusSessionFunc(ctx, userID, sessionID, duration)
	}
	return nil, nil
}

func (m *MockStreakService) GetMyStreak(ctx context.Context, userID string) (*domain.StreakData, error) {
	if m.GetMyStreakFunc != nil {
		return m.GetMyStreakFunc(ctx, userID)
	}
	return nil, nil
}

func (m *MockStreakService) GetUserPublicStreak(ctx context.Context, userID string) (*domain.StreakData, error) {
	if m.GetUserPublicStreakFunc != nil {
		return m.GetUserPublicStreakFunc(ctx, userID)
	}
	return nil, nil
}

func (m *MockStreakService) GetLeaderboard(ctx context.Context, limit int) ([]domain.LeaderboardEntry, error) {
	if m.GetLeaderboardFunc != nil {
		return m.GetLeaderboardFunc(ctx, limit)
	}
	return nil, nil
}

func (m *MockStreakService) TriggerRecalculation(ctx context.Context) error {
	if m.TriggerRecalculationFunc != nil {
		return m.TriggerRecalculationFunc(ctx)
	}
	return nil
}

func (m *MockStreakService) ValidateActivityType(activityType domain.ActivityType) error {
	if m.ValidateActivityTypeFunc != nil {
		return m.ValidateActivityTypeFunc(activityType)
	}
	return nil
}
