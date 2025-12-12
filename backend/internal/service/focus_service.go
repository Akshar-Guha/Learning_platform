package service

import (
	"context"
	"errors"
	"log"

	"github.com/antigravity/backend/internal/domain"
	"github.com/antigravity/backend/internal/eventbus"
	"github.com/google/uuid"
)

var (
	ErrNotSquadMember  = errors.New("not a member of this squad")
	ErrNoActiveSession = errors.New("no active focus session")
	ErrAlreadyFocusing = errors.New("already have an active focus session")
)

// FocusService handles business logic for focus sessions
type FocusService struct {
	repo      domain.FocusRepository
	publisher *eventbus.Publisher
}

// NewFocusService creates a new focus service
func NewFocusService(repo domain.FocusRepository, publisher *eventbus.Publisher) *FocusService {
	return &FocusService{repo: repo, publisher: publisher}
}

// StartFocus starts a new focus session for a user
func (s *FocusService) StartFocus(ctx context.Context, userID uuid.UUID, squadID uuid.UUID) (*domain.StartFocusResponse, error) {
	// Validate squad membership
	isMember, err := s.repo.IsMemberOfSquad(ctx, userID, squadID)
	if err != nil {
		return nil, err
	}
	if !isMember {
		return nil, ErrNotSquadMember
	}

	// End any existing active session first
	_, _ = s.repo.EndSession(ctx, userID)

	// Start new session
	session, err := s.repo.StartSession(ctx, userID, squadID)
	if err != nil {
		return nil, err
	}

	return &domain.StartFocusResponse{
		SessionID: session.ID,
		StartedAt: session.StartedAt,
	}, nil
}

// StopFocus ends the user's current active focus session
func (s *FocusService) StopFocus(ctx context.Context, userID uuid.UUID) (*domain.StopFocusResponse, error) {
	session, err := s.repo.EndSession(ctx, userID)
	if err != nil {
		return nil, err
	}
	if session == nil {
		return nil, ErrNoActiveSession
	}

	durationMinutes := 0
	if session.DurationMinutes != nil {
		durationMinutes = *session.DurationMinutes
	}

	// Publish activity event
	if s.publisher != nil {
		event := eventbus.NewActivityLoggedEvent(userID, "focus_session")
		event.SquadID = session.SquadID.String()
		event.Duration = durationMinutes
		if err := s.publisher.PublishActivityLogged(ctx, event); err != nil {
			log.Printf("Failed to publish activity event: %v", err)
		}
	}

	return &domain.StopFocusResponse{
		SessionID:       session.ID,
		DurationMinutes: durationMinutes,
	}, nil
}

// GetActiveInSquad returns all active focus sessions for a squad
func (s *FocusService) GetActiveInSquad(ctx context.Context, userID, squadID uuid.UUID) (*domain.ActiveSessionsResponse, error) {
	// Validate squad membership
	isMember, err := s.repo.IsMemberOfSquad(ctx, userID, squadID)
	if err != nil {
		return nil, err
	}
	if !isMember {
		return nil, ErrNotSquadMember
	}

	sessions, err := s.repo.GetActiveBySquad(ctx, squadID)
	if err != nil {
		return nil, err
	}

	return &domain.ActiveSessionsResponse{
		ActiveSessions: sessions,
	}, nil
}

// GetFocusHistory returns completed focus sessions for a squad (last 7 days)
func (s *FocusService) GetFocusHistory(ctx context.Context, userID, squadID uuid.UUID) (*domain.FocusHistoryResponse, error) {
	// Validate squad membership
	isMember, err := s.repo.IsMemberOfSquad(ctx, userID, squadID)
	if err != nil {
		return nil, err
	}
	if !isMember {
		return nil, ErrNotSquadMember
	}

	history, err := s.repo.GetHistoryBySquad(ctx, squadID, 7)
	if err != nil {
		return nil, err
	}

	return &domain.FocusHistoryResponse{
		History: history,
	}, nil
}
