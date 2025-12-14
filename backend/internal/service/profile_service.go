package service

import (
	"context"
	"errors"

	"github.com/ulp/backend/internal/domain"
	"github.com/google/uuid"
)

var (
	ErrProfileNotFound = errors.New("profile not found")
	ErrUnauthorized    = errors.New("unauthorized")
)

// ProfileService handles business logic for profiles
type ProfileService struct {
	repo domain.ProfileRepository
}

// NewProfileService creates a new profile service
func NewProfileService(repo domain.ProfileRepository) *ProfileService {
	return &ProfileService{repo: repo}
}

// GetMyProfile retrieves the current user's profile
func (s *ProfileService) GetMyProfile(ctx context.Context, userID uuid.UUID) (*domain.Profile, error) {
	profile, err := s.repo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}
	if profile == nil {
		return nil, ErrProfileNotFound
	}
	return profile, nil
}

// UpdateMyProfile updates the current user's profile
func (s *ProfileService) UpdateMyProfile(ctx context.Context, userID uuid.UUID, req *domain.UpdateProfileRequest) (*domain.Profile, error) {
	// Validate the user exists
	existing, err := s.repo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}
	if existing == nil {
		return nil, ErrProfileNotFound
	}

	// Perform update
	return s.repo.Update(ctx, userID, req)
}

// GetPublicProfile retrieves a public profile by ID
func (s *ProfileService) GetPublicProfile(ctx context.Context, userID uuid.UUID) (*domain.PublicProfile, error) {
	profile, err := s.repo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}
	if profile == nil {
		return nil, ErrProfileNotFound
	}
	return profile.ToPublic(), nil
}
