package service

import (
	"context"
	"errors"
	"fmt"
	"log"

	"github.com/antigravity/backend/internal/domain"
	"github.com/antigravity/backend/internal/eventbus"
	"github.com/google/uuid"
)

var (
	ErrInvalidActivityType = errors.New("invalid activity type")
)

// StreakService handles business logic for streak management
type StreakService struct {
	repo      domain.StreakRepository
	publisher *eventbus.Publisher
}

// NewStreakService creates a new streak service
func NewStreakService(repo domain.StreakRepository, publisher *eventbus.Publisher) *StreakService {
	return &StreakService{repo: repo, publisher: publisher}
}

// LogManualCheckin logs a manual check-in activity
func (s *StreakService) LogManualCheckin(ctx context.Context, userID string) (*domain.LogActivityResponse, error) {
	return s.repo.LogActivity(ctx, userID, domain.ActivityTypeManualCheckin, nil)
}

// LogFocusSession logs a focus session activity (called by focus service)
func (s *StreakService) LogFocusSession(ctx context.Context, userID string, sessionID string, duration int) (*domain.LogActivityResponse, error) {
	metadata := map[string]interface{}{
		"session_id": sessionID,
		"duration":   duration,
	}
	return s.repo.LogActivity(ctx, userID, domain.ActivityTypeFocusSession, metadata)
}

// GetMyStreak returns the authenticated user's streak data with history
func (s *StreakService) GetMyStreak(ctx context.Context, userID string) (*domain.StreakData, error) {
	// Include 30 days of history for the user's own view
	return s.repo.GetUserStreak(ctx, userID, true, 30)
}

// GetUserPublicStreak returns another user's public streak data (no history)
func (s *StreakService) GetUserPublicStreak(ctx context.Context, userID string) (*domain.StreakData, error) {
	// Public view: no history included
	return s.repo.GetUserStreak(ctx, userID, false, 0)
}

// GetLeaderboard returns the global streak leaderboard
func (s *StreakService) GetLeaderboard(ctx context.Context, limit int) ([]domain.LeaderboardEntry, error) {
	if limit <= 0 || limit > 100 {
		limit = 50 // Default to 50
	}
	return s.repo.GetLeaderboard(ctx, limit)
}

// TriggerRecalculation triggers streak recalculation for all users
// This should only be called by admin or cron jobs
func (s *StreakService) TriggerRecalculation(ctx context.Context) error {
	return s.repo.RecalculateAllStreaks(ctx)
}

// PublishStreakAtRiskEvents checks for at-risk users and publishes events
// This is called by the cron job
func (s *StreakService) PublishStreakAtRiskEvents(ctx context.Context) error {
	if s.publisher == nil {
		log.Println("Warning: Publisher is nil, skipping streak risk events")
		return nil
	}

	// Get users at risk (no activity in last 20 hours with active streaks)
	atRiskUsers, err := s.repo.GetAtRiskUsers(ctx)
	if err != nil {
		return err
	}

	log.Printf("Found %d users with at-risk streaks", len(atRiskUsers))

	for _, user := range atRiskUsers {
		userID, _ := uuid.Parse(user.UserID)
		event := eventbus.NewStreakRiskEvent(
			userID,
			user.DisplayName,
			user.CurrentStreak,
			user.LastActivityDate,
			"inactive_20h",
		)
		if err := s.publisher.PublishStreakRisk(ctx, event); err != nil {
			log.Printf("Failed to publish risk event for %s: %v", user.UserID, err)
		}
	}

	return nil
}

// PublishStreakBrokenEvent publishes when a streak breaks (called by recalculation)
func (s *StreakService) PublishStreakBrokenEvent(ctx context.Context, userID uuid.UUID, userName string, brokenStreak, longestStreak int) error {
	if s.publisher == nil {
		return nil
	}
	event := eventbus.NewStreakBrokenEvent(userID, userName, brokenStreak, longestStreak)
	return s.publisher.PublishStreakBroken(ctx, event)
}

// ValidateActivityType validates if an activity type is valid
func (s *StreakService) ValidateActivityType(activityType domain.ActivityType) error {
	if !activityType.IsValid() {
		return fmt.Errorf("%w: %s", ErrInvalidActivityType, activityType)
	}
	return nil
}
