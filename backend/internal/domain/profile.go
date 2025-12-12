package domain

import (
	"time"

	"github.com/google/uuid"
)

// Profile represents a user profile in the system
type Profile struct {
	ID               uuid.UUID  `json:"id"`
	Email            string     `json:"email"`
	DisplayName      string     `json:"display_name"`
	AvatarURL        *string    `json:"avatar_url"`
	IsEduVerified    bool       `json:"is_edu_verified"`
	Timezone         string     `json:"timezone"`
	ConsistencyScore int        `json:"consistency_score"`
	CurrentStreak    int        `json:"current_streak"`
	LongestStreak    int        `json:"longest_streak"`
	CreatedAt        time.Time  `json:"created_at"`
	UpdatedAt        time.Time  `json:"updated_at"`
}

// PublicProfile contains limited profile fields for public viewing
type PublicProfile struct {
	ID               uuid.UUID `json:"id"`
	DisplayName      string    `json:"display_name"`
	AvatarURL        *string   `json:"avatar_url"`
	IsEduVerified    bool      `json:"is_edu_verified"`
	ConsistencyScore int       `json:"consistency_score"`
}

// ToPublic converts a Profile to PublicProfile
func (p *Profile) ToPublic() *PublicProfile {
	return &PublicProfile{
		ID:               p.ID,
		DisplayName:      p.DisplayName,
		AvatarURL:        p.AvatarURL,
		IsEduVerified:    p.IsEduVerified,
		ConsistencyScore: p.ConsistencyScore,
	}
}

// UpdateProfileRequest represents the request body for updating a profile
type UpdateProfileRequest struct {
	DisplayName *string `json:"display_name,omitempty"`
	AvatarURL   *string `json:"avatar_url,omitempty"`
	Timezone    *string `json:"timezone,omitempty"`
}
