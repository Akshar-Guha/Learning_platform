package repository

import (
	"context"
	"database/sql"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
)

// FocusStatsRepository handles database operations for focus statistics
type FocusStatsRepository struct {
	db *sql.DB
}

// NewFocusStatsRepository creates a new focus stats repository
func NewFocusStatsRepository(db *sql.DB) *FocusStatsRepository {
	return &FocusStatsRepository{db: db}
}

// GetUserStats retrieves aggregated focus statistics for a user
func (r *FocusStatsRepository) GetUserStats(ctx context.Context, userID uuid.UUID) (*domain.FocusStats, error) {
	log.Printf("[FocusStatsRepository.GetUserStats] Fetching stats for user %s", userID)

	// Calculate start of current week (Monday)
	now := time.Now()
	weekday := int(now.Weekday())
	if weekday == 0 {
		weekday = 7 // Sunday
	}
	weekStart := now.AddDate(0, 0, -(weekday - 1)).Truncate(24 * time.Hour)

	query := `
		WITH weekly_stats AS (
			SELECT 
				COALESCE(SUM(duration_minutes), 0) as total_minutes_week,
				COUNT(*) as sessions_week
			FROM focus_sessions
			WHERE user_id = $1 
				AND ended_at IS NOT NULL
				AND started_at >= $2
		),
		all_time_stats AS (
			SELECT 
				COALESCE(SUM(duration_minutes), 0) as total_minutes_all,
				COUNT(*) as total_sessions,
				COALESCE(AVG(duration_minutes), 0) as avg_minutes,
				COALESCE(MAX(duration_minutes), 0) as longest_session
			FROM focus_sessions
			WHERE user_id = $1 AND ended_at IS NOT NULL
		),
		best_hour AS (
			SELECT 
				EXTRACT(HOUR FROM started_at) as hour,
				COUNT(*) as session_count,
				AVG(duration_minutes) as avg_duration
			FROM focus_sessions
			WHERE user_id = $1 AND ended_at IS NOT NULL
			GROUP BY EXTRACT(HOUR FROM started_at)
			ORDER BY avg_duration DESC, session_count DESC
			LIMIT 1
		)
		SELECT 
			w.total_minutes_week,
			w.sessions_week,
			a.total_minutes_all,
			a.total_sessions,
			a.avg_minutes,
			a.longest_session,
			COALESCE(b.hour, 9) as best_hour
		FROM weekly_stats w, all_time_stats a
		LEFT JOIN best_hour b ON true
	`

	stats := &domain.FocusStats{}
	var bestHour int

	err := r.db.QueryRowContext(ctx, query, userID, weekStart).Scan(
		&stats.TotalMinutesThisWeek,
		&stats.SessionsThisWeek,
		&stats.TotalMinutesAllTime,
		&stats.TotalSessions,
		&stats.AvgSessionMins,
		&stats.LongestSessionMins,
		&bestHour,
	)

	if err != nil && err != sql.ErrNoRows {
		log.Printf("[FocusStatsRepository.GetUserStats] Error: %v", err)
		return nil, err
	}

	// Format best focus time
	stats.BestFocusTime = formatBestTime(bestHour)

	log.Printf("[FocusStatsRepository.GetUserStats] Stats: %d mins this week, %d total sessions",
		stats.TotalMinutesThisWeek, stats.TotalSessions)
	return stats, nil
}

// GetSquadStats retrieves aggregated focus statistics for a squad
func (r *FocusStatsRepository) GetSquadStats(ctx context.Context, squadID uuid.UUID) (*domain.SquadFocusStats, error) {
	log.Printf("[FocusStatsRepository.GetSquadStats] Fetching stats for squad %s", squadID)

	now := time.Now()
	weekday := int(now.Weekday())
	if weekday == 0 {
		weekday = 7
	}
	weekStart := now.AddDate(0, 0, -(weekday - 1)).Truncate(24 * time.Hour)

	// Get squad aggregate stats
	squadQuery := `
		SELECT COALESCE(SUM(duration_minutes), 0) as total_minutes
		FROM focus_sessions
		WHERE squad_id = $1 
			AND ended_at IS NOT NULL
			AND started_at >= $2
	`

	var totalMinutes int
	err := r.db.QueryRowContext(ctx, squadQuery, squadID, weekStart).Scan(&totalMinutes)
	if err != nil && err != sql.ErrNoRows {
		log.Printf("[FocusStatsRepository.GetSquadStats] Error getting squad total: %v", err)
		return nil, err
	}

	// Get member stats
	memberQuery := `
		SELECT 
			p.id as user_id,
			COALESCE(p.display_name, p.email) as display_name,
			p.avatar_url,
			COALESCE(SUM(fs.duration_minutes), 0) as minutes_week,
			COUNT(fs.id) as sessions_week,
			EXISTS(
				SELECT 1 FROM focus_sessions 
				WHERE user_id = p.id AND squad_id = $1 AND ended_at IS NULL
			) as is_focusing,
			COALESCE(
				(SELECT EXTRACT(EPOCH FROM (NOW() - started_at))::int / 60
				 FROM focus_sessions 
				 WHERE user_id = p.id AND squad_id = $1 AND ended_at IS NULL
				 LIMIT 1), 0
			) as current_session_mins
		FROM squad_members sm
		JOIN profiles p ON sm.user_id = p.id
		LEFT JOIN focus_sessions fs ON fs.user_id = p.id 
			AND fs.squad_id = $1 
			AND fs.ended_at IS NOT NULL
			AND fs.started_at >= $2
		WHERE sm.squad_id = $1
		GROUP BY p.id, p.display_name, p.email, p.avatar_url
		ORDER BY minutes_week DESC
	`

	rows, err := r.db.QueryContext(ctx, memberQuery, squadID, weekStart)
	if err != nil {
		log.Printf("[FocusStatsRepository.GetSquadStats] Error getting members: %v", err)
		return nil, err
	}
	defer rows.Close()

	var members []domain.MemberFocusStat
	for rows.Next() {
		var member domain.MemberFocusStat
		err := rows.Scan(
			&member.UserID,
			&member.DisplayName,
			&member.AvatarURL,
			&member.MinutesThisWeek,
			&member.SessionsThisWeek,
			&member.IsFocusing,
			&member.CurrentSessionMins,
		)
		if err != nil {
			log.Printf("[FocusStatsRepository.GetSquadStats] Error scanning member: %v", err)
			continue
		}
		members = append(members, member)
	}

	// Calculate average
	avgMemberMins := 0
	if len(members) > 0 {
		avgMemberMins = totalMinutes / len(members)
	}

	stats := &domain.SquadFocusStats{
		SquadID:              squadID,
		TotalMinutesThisWeek: totalMinutes,
		AvgMemberMinutes:     avgMemberMins,
		MemberStats:          members,
	}

	log.Printf("[FocusStatsRepository.GetSquadStats] Squad has %d members, %d total mins this week",
		len(members), totalMinutes)
	return stats, nil
}

// GetRecentInsights retrieves recent session insights for a user
func (r *FocusStatsRepository) GetRecentInsights(ctx context.Context, userID uuid.UUID, limit int) ([]domain.SessionInsight, error) {
	log.Printf("[FocusStatsRepository.GetRecentInsights] Fetching last %d insights for user %s", limit, userID)

	query := `
		SELECT id, session_id, user_id, goal_id, insight_type, insight_text, data_points, created_at
		FROM session_insights
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2
	`

	rows, err := r.db.QueryContext(ctx, query, userID, limit)
	if err != nil {
		log.Printf("[FocusStatsRepository.GetRecentInsights] Error: %v", err)
		return nil, err
	}
	defer rows.Close()

	var insights []domain.SessionInsight
	for rows.Next() {
		var insight domain.SessionInsight
		var dataPointsJSON []byte
		err := rows.Scan(
			&insight.ID,
			&insight.SessionID,
			&insight.UserID,
			&insight.GoalID,
			&insight.InsightType,
			&insight.InsightText,
			&dataPointsJSON,
			&insight.CreatedAt,
		)
		if err != nil {
			log.Printf("[FocusStatsRepository.GetRecentInsights] Error scanning: %v", err)
			continue
		}
		// TODO: Parse dataPointsJSON into insight.DataPoints
		insights = append(insights, insight)
	}

	log.Printf("[FocusStatsRepository.GetRecentInsights] Found %d insights", len(insights))
	return insights, nil
}

// formatBestTime converts hour to readable time range
func formatBestTime(hour int) string {
	endHour := hour + 2
	if endHour > 23 {
		endHour = 23
	}
	return formatHour(hour) + " - " + formatHour(endHour)
}

func formatHour(h int) string {
	if h == 0 {
		return "12 AM"
	} else if h < 12 {
		return string(rune('0'+h/10)) + string(rune('0'+h%10)) + " AM"
	} else if h == 12 {
		return "12 PM"
	} else {
		h -= 12
		return string(rune('0'+h/10)) + string(rune('0'+h%10)) + " PM"
	}
}
