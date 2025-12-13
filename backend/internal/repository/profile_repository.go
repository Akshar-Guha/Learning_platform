package repository

import (
	"context"
	"database/sql"
	"net/url"
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
	// Auto-fix: Force Supavisor Session Pooler (IPv4 compatible)
	// Render fails to connect to the direct IPv6 hostname (db.REF.supabase.co).
	// We switch to the pooler hostname (aws-0-REGION.pooler.supabase.com) which supports IPv4.
	// We use DIRECT SESSION MODE (Port 5432) to avoid "Tenant or user not found" errors
	// that occur with Transaction Mode (6543) when using the 'postgres' superuser.

	// Check if we are using the direct Supabase URL
	if strings.Contains(databaseURL, "supabase.co") && strings.Contains(databaseURL, "db.") {
		u, err := url.Parse(databaseURL)
		if err == nil {
			hostParts := strings.Split(u.Hostname(), ".")
			// Expecting db.[ref].supabase.co
			if len(hostParts) >= 2 && hostParts[0] == "db" {
				projectRef := hostParts[1]

				// 1. Switch Host to Pooler (Hardcoded to ap-south-1 as confirmed)
				// Replaces entire hostname to ensure cleaner switch
				u.Host = strings.Replace(u.Host, u.Hostname(), "aws-0-ap-south-1.pooler.supabase.com", 1)

				// 2. Ensure Port is 5432 (Session Mode)
				// If port is present, ensure it's 5432. If missing, default is 5432 anyway.
				if u.Port() != "5432" && u.Port() != "" {
					u.Host = strings.Replace(u.Host, ":"+u.Port(), ":5432", 1)
				}
				// Note: If port is missing from Host string, it defaults to standard when using lib/pq,
				// but for clarity in the URL string we leave it or ensure it's correct if valid.

				// 3. Update User to [user].[ref] format (Required for Pooler)
				if u.User != nil {
					username := u.User.Username()
					// Only append ref if not already present
					if !strings.Contains(username, ".") {
						password, hasPassword := u.User.Password()
						newUsername := fmt.Sprintf("%s.%s", username, projectRef)

						if hasPassword {
							u.User = url.UserPassword(newUsername, password)
						} else {
							u.User = url.User(newUsername)
						}
					}
				}

				// Apply the new URL
				databaseURL = u.String()
				fmt.Println("FYI: Switched to Supavisor Session Pooler (port 5432) for IPv4 support")
			}
		}
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
