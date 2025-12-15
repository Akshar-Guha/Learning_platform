package mocks

import (
	"context"

	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
)

type MockSquadService struct {
	CreateSquadFunc          func(ctx context.Context, userID uuid.UUID, req *domain.CreateSquadRequest) (*domain.Squad, error)
	GetMySquadsFunc          func(ctx context.Context, userID uuid.UUID) ([]domain.Squad, error)
	GetSquadDetailFunc       func(ctx context.Context, squadID, userID uuid.UUID) (*domain.SquadDetail, error)
	UpdateSquadFunc          func(ctx context.Context, squadID, userID uuid.UUID, req *domain.UpdateSquadRequest) (*domain.Squad, error)
	DeleteSquadFunc          func(ctx context.Context, squadID, userID uuid.UUID) error
	JoinSquadFunc            func(ctx context.Context, userID uuid.UUID, inviteCode string) (*domain.Squad, error)
	RemoveMemberFunc         func(ctx context.Context, squadID, targetUserID, callerUserID uuid.UUID) error
	RegenerateInviteCodeFunc func(ctx context.Context, squadID, userID uuid.UUID) (string, error)
}

func (m *MockSquadService) CreateSquad(ctx context.Context, userID uuid.UUID, req *domain.CreateSquadRequest) (*domain.Squad, error) {
	if m.CreateSquadFunc != nil {
		return m.CreateSquadFunc(ctx, userID, req)
	}
	return nil, nil
}

func (m *MockSquadService) GetMySquads(ctx context.Context, userID uuid.UUID) ([]domain.Squad, error) {
	if m.GetMySquadsFunc != nil {
		return m.GetMySquadsFunc(ctx, userID)
	}
	return nil, nil
}

func (m *MockSquadService) GetSquadDetail(ctx context.Context, squadID, userID uuid.UUID) (*domain.SquadDetail, error) {
	if m.GetSquadDetailFunc != nil {
		return m.GetSquadDetailFunc(ctx, squadID, userID)
	}
	return nil, nil
}

func (m *MockSquadService) UpdateSquad(ctx context.Context, squadID, userID uuid.UUID, req *domain.UpdateSquadRequest) (*domain.Squad, error) {
	if m.UpdateSquadFunc != nil {
		return m.UpdateSquadFunc(ctx, squadID, userID, req)
	}
	return nil, nil
}

func (m *MockSquadService) DeleteSquad(ctx context.Context, squadID, userID uuid.UUID) error {
	if m.DeleteSquadFunc != nil {
		return m.DeleteSquadFunc(ctx, squadID, userID)
	}
	return nil
}

func (m *MockSquadService) JoinSquad(ctx context.Context, userID uuid.UUID, inviteCode string) (*domain.Squad, error) {
	if m.JoinSquadFunc != nil {
		return m.JoinSquadFunc(ctx, userID, inviteCode)
	}
	return nil, nil
}

func (m *MockSquadService) RemoveMember(ctx context.Context, squadID, targetUserID, callerUserID uuid.UUID) error {
	if m.RemoveMemberFunc != nil {
		return m.RemoveMemberFunc(ctx, squadID, targetUserID, callerUserID)
	}
	return nil
}

func (m *MockSquadService) RegenerateInviteCode(ctx context.Context, squadID, userID uuid.UUID) (string, error) {
	if m.RegenerateInviteCodeFunc != nil {
		return m.RegenerateInviteCodeFunc(ctx, squadID, userID)
	}
	return "", nil
}
