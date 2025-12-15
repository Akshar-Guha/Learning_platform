package domain

import (
	"time"

	"github.com/google/uuid"
)

// Squad represents a squad in the system
type Squad struct {
	ID          uuid.UUID `json:"id"`
	Name        string    `json:"name"`
	Description *string   `json:"description"`
	InviteCode  string    `json:"invite_code"`
	OwnerID     uuid.UUID `json:"owner_id"`
	MaxMembers  int       `json:"max_members"`
	MemberCount int       `json:"member_count"`
	CreatedAt   time.Time `json:"created_at"`
}

// SquadDetail includes squad info plus member list
type SquadDetail struct {
	ID          uuid.UUID     `json:"id"`
	Name        string        `json:"name"`
	Description *string       `json:"description"`
	InviteCode  string        `json:"invite_code"`
	OwnerID     uuid.UUID     `json:"owner_id"`
	MaxMembers  int           `json:"max_members"`
	CreatedAt   time.Time     `json:"created_at"`
	Members     []SquadMember `json:"members"`
}

// SquadMember represents a member in a squad
type SquadMember struct {
	UserID      uuid.UUID `json:"user_id"`
	DisplayName string    `json:"display_name"`
	AvatarURL   *string   `json:"avatar_url"`
	Role        string    `json:"role"`
	JoinedAt    time.Time `json:"joined_at"`
}

// CreateSquadRequest is the request body for creating a squad
type CreateSquadRequest struct {
	Name        string  `json:"name"`
	Description *string `json:"description,omitempty"`
}

// UpdateSquadRequest is the request body for updating a squad
type UpdateSquadRequest struct {
	Name        *string `json:"name,omitempty"`
	Description *string `json:"description,omitempty"`
}

// JoinSquadRequest is the request body for joining a squad
type JoinSquadRequest struct {
	InviteCode string `json:"invite_code"`
}

// Validate validates the create squad request
func (r *CreateSquadRequest) Validate() error {
	if r.Name == "" {
		return ErrSquadNameRequired
	}
	if len(r.Name) > 50 {
		return ErrSquadNameTooLong
	}
	if r.Description != nil && len(*r.Description) > 200 {
		return ErrSquadDescriptionTooLong
	}
	return nil
}
