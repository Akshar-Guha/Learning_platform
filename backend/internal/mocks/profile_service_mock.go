package mocks

import (
	"context"

	"github.com/antigravity/backend/internal/domain"
	"github.com/google/uuid"
)

type MockProfileService struct {
	GetMyProfileFunc     func(ctx context.Context, userID uuid.UUID) (*domain.Profile, error)
	UpdateMyProfileFunc  func(ctx context.Context, userID uuid.UUID, req *domain.UpdateProfileRequest) (*domain.Profile, error)
	GetPublicProfileFunc func(ctx context.Context, userID uuid.UUID) (*domain.PublicProfile, error)
}

func (m *MockProfileService) GetMyProfile(ctx context.Context, userID uuid.UUID) (*domain.Profile, error) {
	if m.GetMyProfileFunc != nil {
		return m.GetMyProfileFunc(ctx, userID)
	}
	return nil, nil
}

func (m *MockProfileService) UpdateMyProfile(ctx context.Context, userID uuid.UUID, req *domain.UpdateProfileRequest) (*domain.Profile, error) {
	if m.UpdateMyProfileFunc != nil {
		return m.UpdateMyProfileFunc(ctx, userID, req)
	}
	return nil, nil
}

func (m *MockProfileService) GetPublicProfile(ctx context.Context, userID uuid.UUID) (*domain.PublicProfile, error) {
	if m.GetPublicProfileFunc != nil {
		return m.GetPublicProfileFunc(ctx, userID)
	}
	return nil, nil
}
