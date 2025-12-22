package domain

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
)

// ============================================================
// STUDY GOALS DOMAIN
// ============================================================

// GoalStatus represents the current state of a study goal
type GoalStatus string

const (
	GoalStatusActive    GoalStatus = "active"
	GoalStatusCompleted GoalStatus = "completed"
	GoalStatusExpired   GoalStatus = "expired"
	GoalStatusArchived  GoalStatus = "archived"
)

// GoalPriority represents goal priority levels
type GoalPriority int

const (
	GoalPriorityHigh   GoalPriority = 1
	GoalPriorityMedium GoalPriority = 2
	GoalPriorityLow    GoalPriority = 3
)

// StudyGoal represents a user's study goal with optional AI schedule
type StudyGoal struct {
	ID                  uuid.UUID    `json:"id"`
	UserID              uuid.UUID    `json:"user_id"`
	Title               string       `json:"title"`
	Description         *string      `json:"description,omitempty"`
	TargetHours         int          `json:"target_hours"`
	CompletedMinutes    int          `json:"completed_minutes"`
	Deadline            time.Time    `json:"deadline"`
	Priority            GoalPriority `json:"priority"`
	Status              GoalStatus   `json:"status"`
	AISchedule          *AISchedule  `json:"ai_schedule,omitempty"`
	AIScheduleGenerated bool         `json:"ai_schedule_generated"`
	CreatedAt           time.Time    `json:"created_at"`
	UpdatedAt           time.Time    `json:"updated_at"`
}

// ProgressPercent calculates completion progress (0.0 to 1.0)
func (g *StudyGoal) ProgressPercent() float64 {
	if g.TargetHours <= 0 {
		return 0
	}
	targetMinutes := float64(g.TargetHours * 60)
	progress := float64(g.CompletedMinutes) / targetMinutes
	if progress > 1 {
		return 1
	}
	return progress
}

// DaysRemaining calculates days until deadline
func (g *StudyGoal) DaysRemaining() int {
	days := int(time.Until(g.Deadline).Hours() / 24)
	if days < 0 {
		return 0
	}
	return days
}

// ============================================================
// AI SCHEDULE TYPES
// ============================================================

// AISchedule represents an AI-generated study plan
type AISchedule struct {
	Days            []DailyPlan `json:"days"`
	DailyTargetMins int         `json:"daily_target_mins"`
	BufferHours     int         `json:"buffer_hours"`
	GeneratedAt     time.Time   `json:"generated_at"`
}

// DailyPlan represents one day in the AI schedule
type DailyPlan struct {
	Date   string       `json:"date"` // Format: "2025-12-23"
	Blocks []FocusBlock `json:"blocks"`
}

// FocusBlock represents a single focus session block
type FocusBlock struct {
	Start    string `json:"start"`    // Format: "09:00"
	Duration int    `json:"duration"` // Minutes
}

// ============================================================
// API REQUEST/RESPONSE TYPES
// ============================================================

// CreateGoalRequest is the request body for creating a goal
type CreateGoalRequest struct {
	Title       string  `json:"title" validate:"required,min=1,max=100"`
	Description *string `json:"description,omitempty" validate:"omitempty,max=500"`
	TargetHours int     `json:"target_hours" validate:"required,min=1,max=1000"`
	Deadline    string  `json:"deadline" validate:"required"` // Format: "2025-12-30"
	Priority    int     `json:"priority" validate:"required,min=1,max=3"`
}

// UpdateGoalRequest is the request body for updating a goal
type UpdateGoalRequest struct {
	Title       *string `json:"title,omitempty" validate:"omitempty,min=1,max=100"`
	Description *string `json:"description,omitempty" validate:"omitempty,max=500"`
	TargetHours *int    `json:"target_hours,omitempty" validate:"omitempty,min=1,max=1000"`
	Deadline    *string `json:"deadline,omitempty"`
	Priority    *int    `json:"priority,omitempty" validate:"omitempty,min=1,max=3"`
	Status      *string `json:"status,omitempty" validate:"omitempty,oneof=active completed expired archived"`
}

// GoalResponse is the response for a single goal
type GoalResponse struct {
	Goal StudyGoal `json:"goal"`
}

// GoalsListResponse is the response for listing goals
type GoalsListResponse struct {
	Goals      []StudyGoal `json:"goals"`
	TotalCount int         `json:"total_count"`
}

// GenerateScheduleResponse is the response for AI schedule generation
type GenerateScheduleResponse struct {
	Schedule  AISchedule `json:"schedule"`
	Generated bool       `json:"generated"`
	Message   string     `json:"message,omitempty"`
}

// GoalInput is the context sent to Groq for schedule generation
type GoalInput struct {
	Title         string `json:"title"`
	TargetHours   int    `json:"target_hours"`
	Deadline      string `json:"deadline"`
	DaysLeft      int    `json:"days_left"`
	Priority      int    `json:"priority"`
	BestFocusTime string `json:"best_focus_time,omitempty"`
}

// ============================================================
// SERVICE INTERFACE
// ============================================================

// GoalsService defines the goals service interface
type GoalsService interface {
	CreateGoal(ctx context.Context, userID uuid.UUID, req CreateGoalRequest) (*StudyGoal, error)
	GetGoal(ctx context.Context, userID, goalID uuid.UUID) (*StudyGoal, error)
	ListGoals(ctx context.Context, userID uuid.UUID, activeOnly bool) ([]StudyGoal, error)
	UpdateGoal(ctx context.Context, userID, goalID uuid.UUID, req UpdateGoalRequest) (*StudyGoal, error)
	DeleteGoal(ctx context.Context, userID, goalID uuid.UUID) error
	GenerateSchedule(ctx context.Context, userID, goalID uuid.UUID) (*AISchedule, error)
	AddFocusTime(ctx context.Context, goalID uuid.UUID, minutes int) error
}

// ============================================================
// ERRORS
// ============================================================

var (
	// ErrGoalNotFound is returned when a goal doesn't exist
	ErrGoalNotFound = errors.New("goal not found")
	// ErrGoalLimitReached is returned when user has 5 active goals
	ErrGoalLimitReached = errors.New("maximum 5 active goals allowed")
	// ErrScheduleAlreadyGenerated is returned when trying to regenerate
	ErrScheduleAlreadyGenerated = errors.New("AI schedule already generated for this goal")
	// ErrInvalidDeadline is returned when deadline is in the past
	ErrInvalidDeadline = errors.New("deadline must be in the future")
)
