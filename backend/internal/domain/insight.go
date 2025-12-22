package domain

import (
	"time"

	"github.com/google/uuid"
)

// ============================================================
// SESSION INSIGHTS DOMAIN
// For AI-generated insights after focus sessions
// ============================================================

// InsightType represents the type of AI-generated insight
type InsightType string

const (
	InsightTypePattern        InsightType = "pattern"        // Observable pattern in user behavior
	InsightTypeComparison     InsightType = "comparison"     // Comparison to averages/previous data
	InsightTypeMilestone      InsightType = "milestone"      // Achievement of a specific milestone
	InsightTypeRecommendation InsightType = "recommendation" // Actionable suggestion based on data
)

// SessionInsight represents an AI-generated insight for a focus session
type SessionInsight struct {
	ID          uuid.UUID   `json:"id"`
	SessionID   uuid.UUID   `json:"session_id"`
	UserID      uuid.UUID   `json:"user_id"`
	GoalID      *uuid.UUID  `json:"goal_id,omitempty"`
	InsightType InsightType `json:"insight_type"`
	InsightText string      `json:"insight_text"`
	DataPoints  DataPoints  `json:"data_points"`
	CreatedAt   time.Time   `json:"created_at"`
}

// DataPoints contains the raw statistics backing an insight
type DataPoints struct {
	ThisSessionMins  int     `json:"this_session_mins,omitempty"`
	AvgSessionMins   int     `json:"avg_session_mins,omitempty"`
	SessionTime      string  `json:"session_time,omitempty"`    // e.g., "14:30"
	BestFocusTime    string  `json:"best_focus_time,omitempty"` // e.g., "09:00-11:00"
	WeeklyTotalMins  int     `json:"weekly_total_mins,omitempty"`
	GoalProgressPct  float64 `json:"goal_progress_pct,omitempty"`
	StreakDays       int     `json:"streak_days,omitempty"`
	ComparisonChange float64 `json:"comparison_change,omitempty"` // e.g., +40% vs last week
}

// ============================================================
// SESSION CONTEXT FOR AI
// ============================================================

// SessionContext is the data sent to Groq for insight generation
type SessionContext struct {
	UserID            uuid.UUID  `json:"user_id"`
	SessionID         uuid.UUID  `json:"session_id"`
	GoalID            *uuid.UUID `json:"goal_id,omitempty"`
	GoalTitle         string     `json:"goal_title,omitempty"`
	DurationMins      int        `json:"duration_mins"`
	StartTime         string     `json:"start_time"` // Format: "14:30"
	AvgSessionMins    int        `json:"avg_session_mins"`
	WeeklyTotalMins   int        `json:"weekly_total_mins"`
	BestFocusTime     string     `json:"best_focus_time"`
	CurrentStreakDays int        `json:"current_streak_days"`
}

// ============================================================
// API RESPONSE TYPES
// ============================================================

// InsightResponse is the response for a single insight
type InsightResponse struct {
	Insight SessionInsight `json:"insight"`
}

// InsightsListResponse is the response for listing insights
type InsightsListResponse struct {
	Insights   []SessionInsight `json:"insights"`
	TotalCount int              `json:"total_count"`
}

// ============================================================
// FOCUS STATS TYPES
// ============================================================

// FocusStats represents aggregated focus statistics for a user
type FocusStats struct {
	TotalMinutesThisWeek int    `json:"total_minutes_this_week"`
	TotalMinutesAllTime  int    `json:"total_minutes_all_time"`
	AvgSessionMins       int    `json:"avg_session_mins"`
	TotalSessions        int    `json:"total_sessions"`
	SessionsThisWeek     int    `json:"sessions_this_week"`
	BestFocusTime        string `json:"best_focus_time"` // e.g., "09:00-11:00"
	LongestSessionMins   int    `json:"longest_session_mins"`
}

// SquadFocusStats represents aggregated stats for a squad
type SquadFocusStats struct {
	SquadID              uuid.UUID         `json:"squad_id"`
	TotalMinutesThisWeek int               `json:"total_minutes_this_week"`
	AvgMemberMinutes     int               `json:"avg_member_minutes"`
	MemberStats          []MemberFocusStat `json:"member_stats"`
}

// MemberFocusStat represents focus stats for a squad member
type MemberFocusStat struct {
	UserID             uuid.UUID `json:"user_id"`
	DisplayName        string    `json:"display_name"`
	AvatarURL          *string   `json:"avatar_url,omitempty"`
	MinutesThisWeek    int       `json:"minutes_this_week"`
	SessionsThisWeek   int       `json:"sessions_this_week"`
	IsFocusing         bool      `json:"is_focusing"`
	CurrentSessionMins int       `json:"current_session_mins,omitempty"`
}

// FocusStatsResponse is the API response for focus stats
type FocusStatsResponse struct {
	Stats FocusStats `json:"stats"`
}

// SquadStatsResponse is the API response for squad focus stats
type SquadStatsResponse struct {
	Stats SquadFocusStats `json:"stats"`
}
