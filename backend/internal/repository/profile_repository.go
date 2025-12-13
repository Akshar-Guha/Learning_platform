package repository

import (
	"context"
	"database/sql"
	"strings"

	"fmt"

	"github.com/antigravity/backend/internal/domain"
	"github.com/google/uuid"
	_ "github.com/lib/pq"
)

// ProfileRepository handles database operations for profiles
type ProfileRepository struct {
	db *sql.DB
}

// NewProfileRepository creates a new profile repository
func NewProfileRepository(db *sql.DB) *ProfileRepository {
	return &ProfileRepository{db: db}
}

// GetByID retrieves a profile by user ID
func (r *ProfileRepository) GetByID(ctx context.Context, userID uuid.UUID) (*domain.Profile, error) {
	query := `
		SELECT id, email, display_name, avatar_url, is_edu_verified, 
		       timezone, consistency_score, current_streak, longest_streak,
		       created_at, updated_at
		FROM profiles
		WHERE id = $1
	`

	profile := &domain.Profile{}
	err := r.db.QueryRowContext(ctx, query, userID).Scan(
		&profile.ID,
		&profile.Email,
		&profile.DisplayName,
		&profile.AvatarURL,
		&profile.IsEduVerified,
		&profile.Timezone,
		&profile.ConsistencyScore,
		&profile.CurrentStreak,
		&profile.LongestStreak,
		&profile.CreatedAt,
		&profile.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return profile, nil
}

// Update updates a user's profile
func (r *ProfileRepository) Update(ctx context.Context, userID uuid.UUID, req *domain.UpdateProfileRequest) (*domain.Profile, error) {
	// Build dynamic update query
	query := `
		UPDATE profiles
		SET updated_at = NOW()
	`
	args := []interface{}{}
	argCount := 0

	if req.DisplayName != nil {
		argCount++
		query += fmt.Sprintf(", display_name = $%d", argCount)
		args = append(args, *req.DisplayName)
	}
	if req.AvatarURL != nil {
		argCount++
		query += fmt.Sprintf(", avatar_url = $%d", argCount)
		args = append(args, *req.AvatarURL)
	}
	if req.Timezone != nil {
		argCount++
		query += fmt.Sprintf(", timezone = $%d", argCount)
		args = append(args, *req.Timezone)
	}

	argCount++
	argCount++
	query += fmt.Sprintf(" WHERE id = $%d", argCount)
	args = append(args, userID)

	query += `
		RETURNING id, email, display_name, avatar_url, is_edu_verified,
		          timezone, consistency_score, current_streak, longest_streak,
		          created_at, updated_at
	`

	profile := &domain.Profile{}
	err := r.db.QueryRowContext(ctx, query, args...).Scan(
		&profile.ID,
		&profile.Email,
		&profile.DisplayName,
		&profile.AvatarURL,
		&profile.IsEduVerified,
		&profile.Timezone,
		&profile.ConsistencyScore,
		&profile.CurrentStreak,
		&profile.LongestStreak,
		&profile.CreatedAt,
		&profile.UpdatedAt,
	)

	if err != nil {
		return nil, err
	}

	return profile, nil
}

// NewPostgresDB creates a new PostgreSQL database connection
func NewPostgresDB(databaseURL string) (*sql.DB, error) {
	// Auto-fix: Switch to Transaction Pooler (Port 6543) for better cloud connectivity
	// This resolves IPv6/IPv4 direct connection issues on Render where direct port 5432 is unreachable
	if strings.Contains(databaseURL, "supabase.co") && strings.Contains(databaseURL, ":5432") {
		databaseURL = strings.Replace(databaseURL, ":5432", ":6543", 1)
	}

	db, err := sql.Open("postgres", databaseURL)
	if err != nil {
		return nil, err
	}

	if err := db.Ping(); err != nil {
		return nil, err
	}

	// Connection pool settings
	db.SetMaxOpenConns(25)
	db.SetMaxIdleConns(5)

	return db, nil
}
