package domain

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// Notification represents a user notification
type Notification struct {
	ID        uuid.UUID       `json:"id"`
	UserID    uuid.UUID       `json:"user_id"`
	Type      string          `json:"type"` // nudge, streak_alert, squad_invite
	Title     string          `json:"title"`
	Message   string          `json:"message"`
	IsRead    bool            `json:"is_read"`
	CreatedAt time.Time       `json:"created_at"`
	Metadata  json.RawMessage `json:"metadata,omitempty"`
}

// NudgeEvent represents the event payload received from NATS for streak risks
type NudgeEvent struct {
	UserID       uuid.UUID `json:"user_id"`
	UserName     string    `json:"user_name"`
	StreakDays   int       `json:"streak_days"`
	LastActivity time.Time `json:"last_activity"`
	RiskFactor   string    `json:"risk_factor"` // e.g., "inactive_24h", "broken_streak"
}

// NotificationResponse is the DTO for list responses
type NotificationResponse struct {
	Data []Notification `json:"data"`
	Meta PaginationMeta `json:"meta"`
}

type PaginationMeta struct {
	Total int `json:"total"`
	Page  int `json:"page"`
	Limit int `json:"limit"`
}
