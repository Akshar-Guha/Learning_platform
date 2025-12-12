package repository

import (
	"context"
	"database/sql"
	"encoding/json"
	"time"

	"github.com/antigravity/backend/internal/domain"
)

// StreakRepository handles database operations for streak management
type StreakRepository struct {
	db *sql.DB
}

// NewStreakRepository creates a new streak repository
func NewStreakRepository(db *sql.DB) *StreakRepository {
	return &StreakRepository{db: db}
}

// LogActivity logs a daily activity using the smart SQL function
func (r *StreakRepository) LogActivity(
	ctx context.Context,
	userID string,
	activityType domain.ActivityType,
	metadata map[string]interface{},
) (*domain.LogActivityResponse, error) {
	// Convert metadata to JSONB
	metadataJSON, err := json.Marshal(metadata)
	if err != nil {
		return nil, err
	}

	query := `
		SELECT success, activity_id, activity_date, is_new
		FROM log_daily_activity($1::UUID, $2::TEXT, $3::JSONB)
	`

	var response domain.LogActivityResponse
	var activityDate time.Time

	err = r.db.QueryRowContext(ctx, query, userID, string(activityType), metadataJSON).Scan(
		&response.Success,
		&response.ActivityID,
		&activityDate,
		&response.IsNew,
	)
	if err != nil {
		return nil, err
	}

	response.ActivityDate = activityDate

	// Get current streak after logging
	streakData, err := r.calculateStreak(ctx, userID)
	if err == nil && streakData != nil {
		response.CurrentStreak = streakData.CurrentStreak
	}

	return &response, nil
}

// calculateStreak calls the SQL function to calculate streak
func (r *StreakRepository) calculateStreak(ctx context.Context, userID string) (*domain.StreakCalculationResult, error) {
	query := `
		SELECT current_streak, longest_streak, last_active_date
		FROM calculate_streak($1::UUID)
	`

	result := &domain.StreakCalculationResult{}
	err := r.db.QueryRowContext(ctx, query, userID).Scan(
		&result.CurrentStreak,
		&result.LongestStreak,
		&result.LastActiveDate,
	)
	if err != nil {
		return nil, err
	}

	return result, nil
}

// GetUserStreak returns full streak data for a user
func (r *StreakRepository) GetUserStreak(
	ctx context.Context,
	userID string,
	includeHistory bool,
	historyDays int,
) (*domain.StreakData, error) {
	// Get streak calculation from SQL function
	streakCalc, err := r.calculateStreak(ctx, userID)
	if err != nil {
		return nil, err
	}

	// Get consistency score
	consistencyQuery := `
		SELECT get_consistency_score($1::UUID, $2::INTEGER)
	`
	var consistencyScore int
	err = r.db.QueryRowContext(ctx, consistencyQuery, userID, 0).Scan(&consistencyScore)
	if err != nil {
		return nil, err
	}

	// Get total active days
	totalActiveDaysQuery := `
		SELECT COUNT(DISTINCT activity_date)
		FROM activity_logs
		WHERE user_id = $1
	`
	var totalActiveDays int
	err = r.db.QueryRowContext(ctx, totalActiveDaysQuery, userID).Scan(&totalActiveDays)
	if err != nil {
		return nil, err
	}

	streakData := &domain.StreakData{
		UserID:           userID,
		CurrentStreak:    streakCalc.CurrentStreak,
		LongestStreak:    streakCalc.LongestStreak,
		LastActiveDate:   streakCalc.LastActiveDate,
		ConsistencyScore: consistencyScore,
		TotalActiveDays:  totalActiveDays,
	}

	// Optionally include activity history
	if includeHistory && historyDays > 0 {
		history, err := r.GetActivityHistory(ctx, userID, historyDays)
		if err == nil {
			streakData.StreakHistory = history
		}
	}

	return streakData, nil
}

// GetActivityHistory returns activity status for last N days
func (r *StreakRepository) GetActivityHistory(
	ctx context.Context,
	userID string,
	days int,
) ([]domain.ActivityDay, error) {
	query := `
		WITH date_series AS (
			SELECT 
				generate_series(
					(NOW() - ($2 || ' days')::INTERVAL)::DATE,
					NOW()::DATE,
					'1 day'::INTERVAL
				)::DATE AS date
		)
		SELECT 
			ds.date,
			CASE WHEN al.activity_date IS NOT NULL THEN true ELSE false END AS active
		FROM date_series ds
		LEFT JOIN activity_logs al ON al.activity_date = ds.date AND al.user_id = $1
		ORDER BY ds.date DESC
	`

	rows, err := r.db.QueryContext(ctx, query, userID, days)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	history := []domain.ActivityDay{}
	for rows.Next() {
		var day domain.ActivityDay
		if err := rows.Scan(&day.Date, &day.Active); err != nil {
			return nil, err
		}
		history = append(history, day)
	}

	return history, nil
}

// GetLeaderboard returns top N users by current streak
func (r *StreakRepository) GetLeaderboard(ctx context.Context, limit int) ([]domain.LeaderboardEntry, error) {
	query := `
		SELECT 
			p.id,
			p.display_name,
			p.avatar_url,
			p.current_streak,
			p.consistency_score,
			ROW_NUMBER() OVER (ORDER BY p.current_streak DESC, p.consistency_score DESC) AS rank
		FROM profiles p
		WHERE p.current_streak > 0
		ORDER BY p.current_streak DESC, p.consistency_score DESC
		LIMIT $1
	`

	rows, err := r.db.QueryContext(ctx, query, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	leaderboard := []domain.LeaderboardEntry{}
	for rows.Next() {
		entry := domain.LeaderboardEntry{}
		if err := rows.Scan(
			&entry.UserID,
			&entry.DisplayName,
			&entry.AvatarURL,
			&entry.CurrentStreak,
			&entry.ConsistencyScore,
			&entry.Rank,
		); err != nil {
			return nil, err
		}
		leaderboard = append(leaderboard, entry)
	}

	return leaderboard, nil
}

// RecalculateAllStreaks triggers recalculation for all users
// This should be run by a daily cron job
func (r *StreakRepository) RecalculateAllStreaks(ctx context.Context) error {
	query := `
		UPDATE profiles
		SET 
			current_streak = streak_calc.current_streak,
			longest_streak = GREATEST(longest_streak, streak_calc.longest_streak),
			consistency_score = get_consistency_score(id, 0),
			updated_at = NOW()
		FROM (
			SELECT 
				p.id,
				COALESCE((SELECT current_streak FROM calculate_streak(p.id)), 0) AS current_streak,
				COALESCE((SELECT longest_streak FROM calculate_streak(p.id)), 0) AS longest_streak
			FROM profiles p
		) AS streak_calc
		WHERE profiles.id = streak_calc.id
	`

	_, err := r.db.ExecContext(ctx, query)
	return err
}
