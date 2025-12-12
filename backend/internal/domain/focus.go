package domain

import (
	"time"

	"github.com/google/uuid"
)

// FocusSession represents a focus/study session
type FocusSession struct {
	ID              uuid.UUID  `json:"id"`
	UserID          uuid.UUID  `json:"user_id"`
	SquadID         uuid.UUID  `json:"squad_id"`
	StartedAt       time.Time  `json:"started_at"`
	EndedAt         *time.Time `json:"ended_at"`
	DurationMinutes *int       `json:"duration_minutes"`
}

// ActiveSession represents an active focus session with user info
type ActiveSession struct {
	UserID          uuid.UUID `json:"user_id"`
	DisplayName     string    `json:"display_name"`
	AvatarURL       *string   `json:"avatar_url"`
	StartedAt       time.Time `json:"started_at"`
	DurationMinutes int       `json:"duration_minutes"`
}

// FocusHistory represents a completed focus session
type FocusHistory struct {
	ID              uuid.UUID  `json:"id"`
	UserID          uuid.UUID  `json:"user_id"`
	DisplayName     string     `json:"display_name"`
	AvatarURL       *string    `json:"avatar_url"`
	StartedAt       time.Time  `json:"started_at"`
	EndedAt         *time.Time `json:"ended_at"`
	DurationMinutes int        `json:"duration_minutes"`
}

// StartFocusRequest is the request body for starting a focus session
type StartFocusRequest struct {
	SquadID uuid.UUID `json:"squad_id"`
}

// StartFocusResponse is the response after starting a focus session
type StartFocusResponse struct {
	SessionID uuid.UUID `json:"session_id"`
	StartedAt time.Time `json:"started_at"`
}

// StopFocusResponse is the response after stopping a focus session
type StopFocusResponse struct {
	SessionID       uuid.UUID `json:"session_id"`
	DurationMinutes int       `json:"duration_minutes"`
}

// ActiveSessionsResponse is the response for active sessions query
type ActiveSessionsResponse struct {
	ActiveSessions []ActiveSession `json:"active_sessions"`
}

// FocusHistoryResponse is the response for focus history query
type FocusHistoryResponse struct {
	History []FocusHistory `json:"history"`
}
