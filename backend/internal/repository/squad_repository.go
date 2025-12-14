package repository

import (
	"context"
	"database/sql"
	"strings"

	"github.com/ulp/backend/internal/domain"
	"github.com/google/uuid"
)

// SquadRepository handles database operations for squads
type SquadRepository struct {
	db *sql.DB
}

// NewSquadRepository creates a new squad repository
func NewSquadRepository(db *sql.DB) *SquadRepository {
	return &SquadRepository{db: db}
}

// Create creates a new squad (trigger auto-adds owner as member)
func (r *SquadRepository) Create(ctx context.Context, ownerID uuid.UUID, req *domain.CreateSquadRequest) (*domain.Squad, error) {
	query := `
		INSERT INTO squads (name, description, owner_id)
		VALUES ($1, $2, $3)
		RETURNING id, name, description, invite_code, owner_id, max_members, created_at
	`

	squad := &domain.Squad{}
	err := r.db.QueryRowContext(ctx, query, req.Name, req.Description, ownerID).Scan(
		&squad.ID,
		&squad.Name,
		&squad.Description,
		&squad.InviteCode,
		&squad.OwnerID,
		&squad.MaxMembers,
		&squad.CreatedAt,
	)
	if err != nil {
		return nil, err
	}

	squad.MemberCount = 1 // Owner is auto-added
	return squad, nil
}

// GetByID retrieves a squad by ID with member count
func (r *SquadRepository) GetByID(ctx context.Context, squadID uuid.UUID) (*domain.Squad, error) {
	query := `
		SELECT s.id, s.name, s.description, s.invite_code, s.owner_id, s.max_members, s.created_at,
		       (SELECT COUNT(*) FROM squad_members sm WHERE sm.squad_id = s.id) as member_count
		FROM squads s
		WHERE s.id = $1
	`

	squad := &domain.Squad{}
	err := r.db.QueryRowContext(ctx, query, squadID).Scan(
		&squad.ID,
		&squad.Name,
		&squad.Description,
		&squad.InviteCode,
		&squad.OwnerID,
		&squad.MaxMembers,
		&squad.CreatedAt,
		&squad.MemberCount,
	)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return squad, nil
}

// GetDetailByID retrieves a squad with full member list
func (r *SquadRepository) GetDetailByID(ctx context.Context, squadID uuid.UUID) (*domain.SquadDetail, error) {
	// Get squad info
	squadQuery := `
		SELECT id, name, description, invite_code, owner_id, max_members, created_at
		FROM squads WHERE id = $1
	`
	
	detail := &domain.SquadDetail{}
	err := r.db.QueryRowContext(ctx, squadQuery, squadID).Scan(
		&detail.ID,
		&detail.Name,
		&detail.Description,
		&detail.InviteCode,
		&detail.OwnerID,
		&detail.MaxMembers,
		&detail.CreatedAt,
	)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	// Get members
	membersQuery := `
		SELECT sm.user_id, p.display_name, p.avatar_url, sm.role, sm.joined_at
		FROM squad_members sm
		JOIN profiles p ON p.id = sm.user_id
		WHERE sm.squad_id = $1
		ORDER BY sm.role DESC, sm.joined_at ASC
	`
	
	rows, err := r.db.QueryContext(ctx, membersQuery, squadID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	detail.Members = []domain.SquadMember{}
	for rows.Next() {
		member := domain.SquadMember{}
		if err := rows.Scan(
			&member.UserID,
			&member.DisplayName,
			&member.AvatarURL,
			&member.Role,
			&member.JoinedAt,
		); err != nil {
			return nil, err
		}
		detail.Members = append(detail.Members, member)
	}

	return detail, nil
}

// GetUserSquads retrieves all squads a user belongs to
func (r *SquadRepository) GetUserSquads(ctx context.Context, userID uuid.UUID) ([]domain.Squad, error) {
	query := `
		SELECT s.id, s.name, s.description, s.invite_code, s.owner_id, s.max_members, s.created_at,
		       (SELECT COUNT(*) FROM squad_members sm2 WHERE sm2.squad_id = s.id) as member_count
		FROM squads s
		JOIN squad_members sm ON sm.squad_id = s.id
		WHERE sm.user_id = $1
		ORDER BY s.created_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	squads := []domain.Squad{}
	for rows.Next() {
		squad := domain.Squad{}
		if err := rows.Scan(
			&squad.ID,
			&squad.Name,
			&squad.Description,
			&squad.InviteCode,
			&squad.OwnerID,
			&squad.MaxMembers,
			&squad.CreatedAt,
			&squad.MemberCount,
		); err != nil {
			return nil, err
		}
		squads = append(squads, squad)
	}

	return squads, nil
}

// Update updates a squad's details
func (r *SquadRepository) Update(ctx context.Context, squadID uuid.UUID, req *domain.UpdateSquadRequest) (*domain.Squad, error) {
	// Build dynamic update
	setParts := []string{}
	args := []interface{}{}
	argNum := 1

	if req.Name != nil {
		setParts = append(setParts, "name = $"+string(rune('0'+argNum)))
		args = append(args, *req.Name)
		argNum++
	}
	if req.Description != nil {
		setParts = append(setParts, "description = $"+string(rune('0'+argNum)))
		args = append(args, *req.Description)
		argNum++
	}

	if len(setParts) == 0 {
		return r.GetByID(ctx, squadID)
	}

	args = append(args, squadID)
	query := `
		UPDATE squads SET ` + strings.Join(setParts, ", ") + `
		WHERE id = $` + string(rune('0'+argNum)) + `
		RETURNING id, name, description, invite_code, owner_id, max_members, created_at
	`

	squad := &domain.Squad{}
	err := r.db.QueryRowContext(ctx, query, args...).Scan(
		&squad.ID,
		&squad.Name,
		&squad.Description,
		&squad.InviteCode,
		&squad.OwnerID,
		&squad.MaxMembers,
		&squad.CreatedAt,
	)
	if err != nil {
		return nil, err
	}

	return squad, nil
}

// Delete deletes a squad
func (r *SquadRepository) Delete(ctx context.Context, squadID uuid.UUID) error {
	_, err := r.db.ExecContext(ctx, "DELETE FROM squads WHERE id = $1", squadID)
	return err
}

// JoinByInviteCode joins a squad using invite code (calls DB function)
func (r *SquadRepository) JoinByInviteCode(ctx context.Context, inviteCode string, userID uuid.UUID) (uuid.UUID, error) {
	var squadID uuid.UUID
	err := r.db.QueryRowContext(ctx,
		"SELECT public.join_squad($1)",
		strings.ToUpper(inviteCode),
	).Scan(&squadID)
	
	if err != nil {
		// Parse PostgreSQL error messages
		errMsg := err.Error()
		if strings.Contains(errMsg, "Invalid invite code") {
			return uuid.Nil, domain.ErrInvalidInviteCode
		}
		if strings.Contains(errMsg, "Already a member") {
			return uuid.Nil, domain.ErrAlreadyMember
		}
		if strings.Contains(errMsg, "full") {
			return uuid.Nil, domain.ErrSquadFull
		}
		return uuid.Nil, err
	}

	return squadID, nil
}

// RemoveMember removes a member from a squad
func (r *SquadRepository) RemoveMember(ctx context.Context, squadID, userID uuid.UUID) error {
	result, err := r.db.ExecContext(ctx,
		"DELETE FROM squad_members WHERE squad_id = $1 AND user_id = $2",
		squadID, userID,
	)
	if err != nil {
		return err
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		return domain.ErrNotSquadMember
	}

	return nil
}

// RegenerateInviteCode generates a new invite code (calls DB function)
func (r *SquadRepository) RegenerateInviteCode(ctx context.Context, squadID uuid.UUID) (string, error) {
	var newCode string
	err := r.db.QueryRowContext(ctx,
		"SELECT public.regenerate_invite_code($1)",
		squadID,
	).Scan(&newCode)
	
	if err != nil {
		errMsg := err.Error()
		if strings.Contains(errMsg, "not found") {
			return "", domain.ErrSquadNotFound
		}
		if strings.Contains(errMsg, "owner") {
			return "", domain.ErrNotSquadOwner
		}
		return "", err
	}

	return newCode, nil
}

// IsMember checks if a user is a member of a squad
func (r *SquadRepository) IsMember(ctx context.Context, squadID, userID uuid.UUID) (bool, error) {
	var exists bool
	err := r.db.QueryRowContext(ctx,
		"SELECT EXISTS(SELECT 1 FROM squad_members WHERE squad_id = $1 AND user_id = $2)",
		squadID, userID,
	).Scan(&exists)
	return exists, err
}
