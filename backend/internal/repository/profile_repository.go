package repository

import (
	"context"
	"database/sql"
	"net"
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
// Forces IPv4 resolution to avoid Render's IPv6 connectivity issues
func NewPostgresDB(databaseURL string) (*sql.DB, error) {
	// Parse the database URL to extract hostname
	parsedURL, err := url.Parse(databaseURL)
	if err != nil {
		return nil, fmt.Errorf("failed to parse database URL: %w", err)
	}

	// Extract hostname (remove port if present)
	hostname := parsedURL.Hostname()

	// Resolve hostname to IPv4 address
	ips, err := net.LookupIP(hostname)
	if err != nil {
		return nil, fmt.Errorf("failed to resolve hostname %s: %w", hostname, err)
	}

	// Find first IPv4 address
	var ipv4 string
	for _, ip := range ips {
		if ip.To4() != nil {
			ipv4 = ip.String()
			break
		}
	}

	if ipv4 == "" {
		return nil, fmt.Errorf("no IPv4 address found for hostname %s", hostname)
	}

	// Replace hostname with IPv4 address in the connection string
	// Handle both cases: hostname with port and without port
	var modifiedURL string
	if parsedURL.Port() != "" {
		// Replace "hostname:port" with "ipv4:port"
		modifiedURL = strings.Replace(databaseURL, parsedURL.Host, ipv4+":"+parsedURL.Port(), 1)
	} else {
		// Replace "hostname" with "ipv4"
		modifiedURL = strings.Replace(databaseURL, hostname, ipv4, 1)
	}

	db, err := sql.Open("postgres", modifiedURL)
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
