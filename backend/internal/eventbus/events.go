package eventbus

import (
	"time"

	"github.com/google/uuid"
)

// Event subjects
const (
	SubjectActivityLogged = "events.activity.logged"
	SubjectStreakRisk     = "events.streak.risk"
	SubjectStreakBroken   = "events.streak.broken"
)

// BaseEvent is the common structure for all events
type BaseEvent struct {
	Type      string    `json:"type"`
	UserID    uuid.UUID `json:"user_id"`
	Timestamp time.Time `json:"timestamp"`
}

// ActivityLoggedEvent is published when user completes an activity
type ActivityLoggedEvent struct {
	BaseEvent
	ActivityType string `json:"activity_type"` // focus_session, manual_checkin, squad_join
	SquadID      string `json:"squad_id,omitempty"`
	Duration     int    `json:"duration_minutes,omitempty"`
}

// StreakRiskEvent is published when a user's streak is at risk
type StreakRiskEvent struct {
	BaseEvent
	UserName     string    `json:"user_name"`
	StreakDays   int       `json:"streak_days"`
	LastActivity time.Time `json:"last_activity"`
	RiskFactor   string    `json:"risk_factor"` // inactive_24h, approaching_deadline
}

// StreakBrokenEvent is published when a user's streak breaks
type StreakBrokenEvent struct {
	BaseEvent
	UserName      string `json:"user_name"`
	BrokenStreak  int    `json:"broken_streak"`
	LongestStreak int    `json:"longest_streak"`
}

// NewActivityLoggedEvent creates a new activity event
func NewActivityLoggedEvent(userID uuid.UUID, activityType string) ActivityLoggedEvent {
	return ActivityLoggedEvent{
		BaseEvent: BaseEvent{
			Type:      SubjectActivityLogged,
			UserID:    userID,
			Timestamp: time.Now(),
		},
		ActivityType: activityType,
	}
}

// NewStreakRiskEvent creates a new streak risk event
func NewStreakRiskEvent(userID uuid.UUID, userName string, streakDays int, lastActivity time.Time, riskFactor string) StreakRiskEvent {
	return StreakRiskEvent{
		BaseEvent: BaseEvent{
			Type:      SubjectStreakRisk,
			UserID:    userID,
			Timestamp: time.Now(),
		},
		UserName:     userName,
		StreakDays:   streakDays,
		LastActivity: lastActivity,
		RiskFactor:   riskFactor,
	}
}

// NewStreakBrokenEvent creates a new streak broken event
func NewStreakBrokenEvent(userID uuid.UUID, userName string, brokenStreak, longestStreak int) StreakBrokenEvent {
	return StreakBrokenEvent{
		BaseEvent: BaseEvent{
			Type:      SubjectStreakBroken,
			UserID:    userID,
			Timestamp: time.Now(),
		},
		UserName:      userName,
		BrokenStreak:  brokenStreak,
		LongestStreak: longestStreak,
	}
}
