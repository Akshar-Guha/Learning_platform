package service

import (
	"context"

	"github.com/ulp/backend/internal/domain"
	"github.com/google/uuid"
)

// SquadService handles business logic for squads
type SquadService struct {
	repo domain.SquadRepository
}

// NewSquadService creates a new squad service
func NewSquadService(repo domain.SquadRepository) *SquadService {
	return &SquadService{repo: repo}
}

// CreateSquad creates a new squad
func (s *SquadService) CreateSquad(ctx context.Context, userID uuid.UUID, req *domain.CreateSquadRequest) (*domain.Squad, error) {
	if err := req.Validate(); err != nil {
		return nil, err
	}
	return s.repo.Create(ctx, userID, req)
}

// GetMySquads returns all squads the user belongs to
func (s *SquadService) GetMySquads(ctx context.Context, userID uuid.UUID) ([]domain.Squad, error) {
	return s.repo.GetUserSquads(ctx, userID)
}

// GetSquadDetail returns detailed squad info if user is a member
func (s *SquadService) GetSquadDetail(ctx context.Context, squadID, userID uuid.UUID) (*domain.SquadDetail, error) {
	// Check membership
	isMember, err := s.repo.IsMember(ctx, squadID, userID)
	if err != nil {
		return nil, err
	}
	if !isMember {
		return nil, domain.ErrNotSquadMember
	}

	detail, err := s.repo.GetDetailByID(ctx, squadID)
	if err != nil {
		return nil, err
	}
	if detail == nil {
		return nil, domain.ErrSquadNotFound
	}

	return detail, nil
}

// UpdateSquad updates squad details (owner only)
func (s *SquadService) UpdateSquad(ctx context.Context, squadID, userID uuid.UUID, req *domain.UpdateSquadRequest) (*domain.Squad, error) {
	// Check ownership
	squad, err := s.repo.GetByID(ctx, squadID)
	if err != nil {
		return nil, err
	}
	if squad == nil {
		return nil, domain.ErrSquadNotFound
	}
	if squad.OwnerID != userID {
		return nil, domain.ErrNotSquadOwner
	}

	return s.repo.Update(ctx, squadID, req)
}

// DeleteSquad deletes a squad (owner only)
func (s *SquadService) DeleteSquad(ctx context.Context, squadID, userID uuid.UUID) error {
	// Check ownership
	squad, err := s.repo.GetByID(ctx, squadID)
	if err != nil {
		return err
	}
	if squad == nil {
		return domain.ErrSquadNotFound
	}
	if squad.OwnerID != userID {
		return domain.ErrNotSquadOwner
	}

	return s.repo.Delete(ctx, squadID)
}

// JoinSquad joins a squad via invite code
func (s *SquadService) JoinSquad(ctx context.Context, userID uuid.UUID, inviteCode string) (*domain.Squad, error) {
	squadID, err := s.repo.JoinByInviteCode(ctx, inviteCode, userID)
	if err != nil {
		return nil, err
	}

	return s.repo.GetByID(ctx, squadID)
}

// RemoveMember removes a member (owner kicks or member leaves)
func (s *SquadService) RemoveMember(ctx context.Context, squadID, targetUserID, callerUserID uuid.UUID) error {
	// Get squad to check ownership
	squad, err := s.repo.GetByID(ctx, squadID)
	if err != nil {
		return err
	}
	if squad == nil {
		return domain.ErrSquadNotFound
	}

	// Check permissions
	isSelfLeave := targetUserID == callerUserID
	isOwner := squad.OwnerID == callerUserID
	targetIsOwner := squad.OwnerID == targetUserID

	// Owner cannot be kicked
	if targetIsOwner && !isSelfLeave {
		return domain.ErrCannotKickOwner
	}

	// Must be owner or self
	if !isOwner && !isSelfLeave {
		return domain.ErrNotSquadOwner
	}

	return s.repo.RemoveMember(ctx, squadID, targetUserID)
}

// RegenerateInviteCode generates a new invite code (owner only)
func (s *SquadService) RegenerateInviteCode(ctx context.Context, squadID, userID uuid.UUID) (string, error) {
	// Check ownership
	squad, err := s.repo.GetByID(ctx, squadID)
	if err != nil {
		return "", err
	}
	if squad == nil {
		return "", domain.ErrSquadNotFound
	}
	if squad.OwnerID != userID {
		return "", domain.ErrNotSquadOwner
	}

	return s.repo.RegenerateInviteCode(ctx, squadID)
}
