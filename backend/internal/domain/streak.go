package domain

import (
	"time"
)

// ActivityLog represents a daily activity entry for streak tracking
type ActivityLog struct {
	ID           string                 `json:"id" db:"id"`
	UserID       string                 `json:"user_id" db:"user_id"`
	ActivityType ActivityType           `json:"activity_type" db:"activity_type"`
	ActivityDate time.Time              `json:"activity_date" db:"activity_date"` // Date only (no time)
	LoggedAt     time.Time              `json:"logged_at" db:"logged_at"`
	Metadata     map[string]interface{} `json:"metadata" db:"metadata"`
}

// ActivityType represents the type of activity logged
type ActivityType string

const (
	ActivityTypeFocusSession  ActivityType = "focus_session"
	ActivityTypeSquadJoin     ActivityType = "squad_join"
	ActivityTypeManualCheckin ActivityType = "manual_checkin"
)

// Validate checks if the activity type is valid
func (a ActivityType) IsValid() bool {
	switch a {
	case ActivityTypeFocusSession, ActivityTypeSquadJoin, ActivityTypeManualCheckin:
		return true
	}
	return false
}

// StreakData represents comprehensive streak information for a user
type StreakData struct {
	UserID           string             `json:"user_id"`
	CurrentStreak    int                `json:"current_streak"`
	LongestStreak    int                `json:"longest_streak"`
	LastActiveDate   *time.Time         `json:"last_active_date,omitempty"`
	ConsistencyScore int                `json:"consistency_score"`
	TotalActiveDays  int                `json:"total_active_days"`
	StreakHistory    []ActivityDay      `json:"streak_history,omitempty"`
}

// ActivityDay represents a single day's activity status
type ActivityDay struct {
	Date   time.Time `json:"date"`
	Active bool      `json:"active"`
}

// LeaderboardEntry represents a user's position in the streak leaderboard
type LeaderboardEntry struct {
	UserID           string  `json:"user_id"`
	DisplayName      string  `json:"display_name"`
	AvatarURL        *string `json:"avatar_url,omitempty"`
	CurrentStreak    int     `json:"current_streak"`
	ConsistencyScore int     `json:"consistency_score"`
	Rank             int     `json:"rank"`
}

// LogActivityRequest represents the request to log a daily activity
type LogActivityRequest struct {
	ActivityType ActivityType           `json:"activity_type" binding:"required"`
	Metadata     map[string]interface{} `json:"metadata,omitempty"`
}

// LogActivityResponse represents the response after logging activity
type LogActivityResponse struct {
	Success        bool      `json:"success"`
	ActivityID     string    `json:"activity_id"`
	ActivityDate   time.Time `json:"activity_date"`
	CurrentStreak  int       `json:"current_streak"`
	IsNew          bool      `json:"is_new"` // Whether this was a new log or duplicate
}

// StreakCalculationResult represents the result from calculate_streak() SQL function
type StreakCalculationResult struct {
	CurrentStreak  int        `db:"current_streak"`
	LongestStreak  int        `db:"longest_streak"`
	LastActiveDate *time.Time `db:"last_active_date"`
}

// AtRiskUser represents a user whose streak is at risk of breaking
type AtRiskUser struct {
	UserID           string
	DisplayName      string
	CurrentStreak    int
	LastActivityDate time.Time
}
