package repository

import (
	"context"
	"database/sql"
	"time"

	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
)

// FocusRepository handles database operations for focus sessions
type FocusRepository struct {
	db *sql.DB
}

// NewFocusRepository creates a new focus repository
func NewFocusRepository(db *sql.DB) *FocusRepository {
	return &FocusRepository{db: db}
}

// StartSession creates a new focus session for a user in a squad
func (r *FocusRepository) StartSession(ctx context.Context, userID, squadID uuid.UUID) (*domain.FocusSession, error) {
	query := `
		INSERT INTO focus_sessions (user_id, squad_id)
		VALUES ($1, $2)
		RETURNING id, user_id, squad_id, started_at, ended_at, duration_minutes
	`

	session := &domain.FocusSession{}
	err := r.db.QueryRowContext(ctx, query, userID, squadID).Scan(
		&session.ID,
		&session.UserID,
		&session.SquadID,
		&session.StartedAt,
		&session.EndedAt,
		&session.DurationMinutes,
	)
	if err != nil {
		return nil, err
	}

	return session, nil
}

// EndSession ends all active sessions for a user
func (r *FocusRepository) EndSession(ctx context.Context, userID uuid.UUID) (*domain.FocusSession, error) {
	query := `
		UPDATE focus_sessions
		SET ended_at = NOW()
		WHERE user_id = $1 AND ended_at IS NULL
		RETURNING id, user_id, squad_id, started_at, ended_at, duration_minutes
	`

	session := &domain.FocusSession{}
	err := r.db.QueryRowContext(ctx, query, userID).Scan(
		&session.ID,
		&session.UserID,
		&session.SquadID,
		&session.StartedAt,
		&session.EndedAt,
		&session.DurationMinutes,
	)
	if err == sql.ErrNoRows {
		return nil, nil // No active session
	}
	if err != nil {
		return nil, err
	}

	return session, nil
}

// GetActiveSession returns the user's current active session, if any
func (r *FocusRepository) GetActiveSession(ctx context.Context, userID uuid.UUID) (*domain.FocusSession, error) {
	query := `
		SELECT id, user_id, squad_id, started_at, ended_at, duration_minutes
		FROM focus_sessions
		WHERE user_id = $1 AND ended_at IS NULL
		LIMIT 1
	`

	session := &domain.FocusSession{}
	err := r.db.QueryRowContext(ctx, query, userID).Scan(
		&session.ID,
		&session.UserID,
		&session.SquadID,
		&session.StartedAt,
		&session.EndedAt,
		&session.DurationMinutes,
	)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return session, nil
}

// GetActiveBySquad returns all active focus sessions for a squad
func (r *FocusRepository) GetActiveBySquad(ctx context.Context, squadID uuid.UUID) ([]domain.ActiveSession, error) {
	query := `
		SELECT fs.user_id, p.display_name, p.avatar_url, fs.started_at, fs.duration_minutes
		FROM focus_sessions fs
		JOIN profiles p ON p.id = fs.user_id
		WHERE fs.squad_id = $1 AND fs.ended_at IS NULL
		ORDER BY fs.started_at ASC
	`

	rows, err := r.db.QueryContext(ctx, query, squadID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	sessions := []domain.ActiveSession{}
	for rows.Next() {
		session := domain.ActiveSession{}
		if err := rows.Scan(
			&session.UserID,
			&session.DisplayName,
			&session.AvatarURL,
			&session.StartedAt,
			&session.DurationMinutes,
		); err != nil {
			return nil, err
		}
		sessions = append(sessions, session)
	}

	return sessions, nil
}

// GetHistoryBySquad returns completed focus sessions for a squad within the last N days
func (r *FocusRepository) GetHistoryBySquad(ctx context.Context, squadID uuid.UUID, days int) ([]domain.FocusHistory, error) {
	cutoff := time.Now().AddDate(0, 0, -days)

	query := `
		SELECT fs.id, fs.user_id, p.display_name, p.avatar_url, 
		       fs.started_at, fs.ended_at, fs.duration_minutes
		FROM focus_sessions fs
		JOIN profiles p ON p.id = fs.user_id
		WHERE fs.squad_id = $1 
		  AND fs.ended_at IS NOT NULL
		  AND fs.started_at >= $2
		ORDER BY fs.started_at DESC
		LIMIT 100
	`

	rows, err := r.db.QueryContext(ctx, query, squadID, cutoff)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	history := []domain.FocusHistory{}
	for rows.Next() {
		h := domain.FocusHistory{}
		if err := rows.Scan(
			&h.ID,
			&h.UserID,
			&h.DisplayName,
			&h.AvatarURL,
			&h.StartedAt,
			&h.EndedAt,
			&h.DurationMinutes,
		); err != nil {
			return nil, err
		}
		history = append(history, h)
	}

	return history, nil
}

// IsMemberOfSquad checks if a user is a member of a squad
func (r *FocusRepository) IsMemberOfSquad(ctx context.Context, userID, squadID uuid.UUID) (bool, error) {
	var exists bool
	err := r.db.QueryRowContext(ctx,
		"SELECT EXISTS(SELECT 1 FROM squad_members WHERE squad_id = $1 AND user_id = $2)",
		squadID, userID,
	).Scan(&exists)
	return exists, err
}
