package repository

import (
	"context"
	"database/sql"
	"encoding/json"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/ulp/backend/internal/domain"
)

// GoalsRepository handles database operations for study goals
type GoalsRepository struct {
	db *sql.DB
}

// NewGoalsRepository creates a new goals repository
func NewGoalsRepository(db *sql.DB) *GoalsRepository {
	return &GoalsRepository{db: db}
}

// Create creates a new study goal
func (r *GoalsRepository) Create(ctx context.Context, goal *domain.StudyGoal) (*domain.StudyGoal, error) {
	query := `
		INSERT INTO study_goals (user_id, title, description, target_hours, deadline, priority, status)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
		RETURNING id, user_id, title, description, target_hours, completed_minutes, deadline, 
		          priority, status, ai_schedule, ai_schedule_generated, created_at, updated_at
	`

	var aiScheduleJSON sql.NullString
	err := r.db.QueryRowContext(ctx, query,
		goal.UserID,
		goal.Title,
		goal.Description,
		goal.TargetHours,
		goal.Deadline,
		goal.Priority,
		goal.Status,
	).Scan(
		&goal.ID,
		&goal.UserID,
		&goal.Title,
		&goal.Description,
		&goal.TargetHours,
		&goal.CompletedMinutes,
		&goal.Deadline,
		&goal.Priority,
		&goal.Status,
		&aiScheduleJSON,
		&goal.AIScheduleGenerated,
		&goal.CreatedAt,
		&goal.UpdatedAt,
	)

	if err != nil {
		// Check for max goals constraint
		if err.Error() == "pq: GOAL_LIMIT_REACHED: Maximum 5 active goals allowed per user" {
			return nil, domain.ErrGoalLimitReached
		}
		log.Printf("[GoalsRepository.Create] Error creating goal: %v", err)
		return nil, err
	}

	if aiScheduleJSON.Valid {
		var schedule domain.AISchedule
		if err := json.Unmarshal([]byte(aiScheduleJSON.String), &schedule); err == nil {
			goal.AISchedule = &schedule
		}
	}

	log.Printf("[GoalsRepository.Create] Created goal %s for user %s", goal.ID, goal.UserID)
	return goal, nil
}

// GetByID retrieves a goal by ID (checks user ownership)
func (r *GoalsRepository) GetByID(ctx context.Context, userID, goalID uuid.UUID) (*domain.StudyGoal, error) {
	query := `
		SELECT id, user_id, title, description, target_hours, completed_minutes, deadline,
		       priority, status, ai_schedule, ai_schedule_generated, created_at, updated_at
		FROM study_goals
		WHERE id = $1 AND user_id = $2
	`

	goal := &domain.StudyGoal{}
	var aiScheduleJSON sql.NullString

	err := r.db.QueryRowContext(ctx, query, goalID, userID).Scan(
		&goal.ID,
		&goal.UserID,
		&goal.Title,
		&goal.Description,
		&goal.TargetHours,
		&goal.CompletedMinutes,
		&goal.Deadline,
		&goal.Priority,
		&goal.Status,
		&aiScheduleJSON,
		&goal.AIScheduleGenerated,
		&goal.CreatedAt,
		&goal.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, domain.ErrGoalNotFound
	}
	if err != nil {
		log.Printf("[GoalsRepository.GetByID] Error fetching goal %s: %v", goalID, err)
		return nil, err
	}

	if aiScheduleJSON.Valid {
		var schedule domain.AISchedule
		if err := json.Unmarshal([]byte(aiScheduleJSON.String), &schedule); err == nil {
			goal.AISchedule = &schedule
		}
	}

	return goal, nil
}

// ListByUserID lists all goals for a user
func (r *GoalsRepository) ListByUserID(ctx context.Context, userID uuid.UUID, activeOnly bool) ([]domain.StudyGoal, error) {
	query := `
		SELECT id, user_id, title, description, target_hours, completed_minutes, deadline,
		       priority, status, ai_schedule, ai_schedule_generated, created_at, updated_at
		FROM study_goals
		WHERE user_id = $1
	`
	args := []interface{}{userID}

	if activeOnly {
		query += " AND status = 'active'"
	}

	query += " ORDER BY priority ASC, deadline ASC"

	rows, err := r.db.QueryContext(ctx, query, args...)
	if err != nil {
		log.Printf("[GoalsRepository.ListByUserID] Error listing goals: %v", err)
		return nil, err
	}
	defer rows.Close()

	var goals []domain.StudyGoal
	for rows.Next() {
		var goal domain.StudyGoal
		var aiScheduleJSON sql.NullString

		err := rows.Scan(
			&goal.ID,
			&goal.UserID,
			&goal.Title,
			&goal.Description,
			&goal.TargetHours,
			&goal.CompletedMinutes,
			&goal.Deadline,
			&goal.Priority,
			&goal.Status,
			&aiScheduleJSON,
			&goal.AIScheduleGenerated,
			&goal.CreatedAt,
			&goal.UpdatedAt,
		)
		if err != nil {
			log.Printf("[GoalsRepository.ListByUserID] Error scanning row: %v", err)
			continue
		}

		if aiScheduleJSON.Valid {
			var schedule domain.AISchedule
			if err := json.Unmarshal([]byte(aiScheduleJSON.String), &schedule); err == nil {
				goal.AISchedule = &schedule
			}
		}

		goals = append(goals, goal)
	}

	log.Printf("[GoalsRepository.ListByUserID] Found %d goals for user %s", len(goals), userID)
	return goals, nil
}

// Update updates a goal's fields
func (r *GoalsRepository) Update(ctx context.Context, goal *domain.StudyGoal) (*domain.StudyGoal, error) {
	query := `
		UPDATE study_goals
		SET title = $1, description = $2, target_hours = $3, deadline = $4, 
		    priority = $5, status = $6, updated_at = NOW()
		WHERE id = $7 AND user_id = $8
		RETURNING id, user_id, title, description, target_hours, completed_minutes, deadline,
		          priority, status, ai_schedule, ai_schedule_generated, created_at, updated_at
	`

	var aiScheduleJSON sql.NullString
	err := r.db.QueryRowContext(ctx, query,
		goal.Title,
		goal.Description,
		goal.TargetHours,
		goal.Deadline,
		goal.Priority,
		goal.Status,
		goal.ID,
		goal.UserID,
	).Scan(
		&goal.ID,
		&goal.UserID,
		&goal.Title,
		&goal.Description,
		&goal.TargetHours,
		&goal.CompletedMinutes,
		&goal.Deadline,
		&goal.Priority,
		&goal.Status,
		&aiScheduleJSON,
		&goal.AIScheduleGenerated,
		&goal.CreatedAt,
		&goal.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, domain.ErrGoalNotFound
	}
	if err != nil {
		log.Printf("[GoalsRepository.Update] Error updating goal %s: %v", goal.ID, err)
		return nil, err
	}

	if aiScheduleJSON.Valid {
		var schedule domain.AISchedule
		if err := json.Unmarshal([]byte(aiScheduleJSON.String), &schedule); err == nil {
			goal.AISchedule = &schedule
		}
	}

	log.Printf("[GoalsRepository.Update] Updated goal %s", goal.ID)
	return goal, nil
}

// SaveAISchedule saves the AI-generated schedule for a goal
func (r *GoalsRepository) SaveAISchedule(ctx context.Context, goalID uuid.UUID, schedule *domain.AISchedule) error {
	scheduleJSON, err := json.Marshal(schedule)
	if err != nil {
		return err
	}

	query := `
		UPDATE study_goals
		SET ai_schedule = $1, ai_schedule_generated = true, updated_at = NOW()
		WHERE id = $2 AND ai_schedule_generated = false
	`

	result, err := r.db.ExecContext(ctx, query, scheduleJSON, goalID)
	if err != nil {
		log.Printf("[GoalsRepository.SaveAISchedule] Error saving schedule: %v", err)
		return err
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		return domain.ErrScheduleAlreadyGenerated
	}

	log.Printf("[GoalsRepository.SaveAISchedule] Saved AI schedule for goal %s", goalID)
	return nil
}

// Delete soft-deletes (archives) a goal
func (r *GoalsRepository) Delete(ctx context.Context, userID, goalID uuid.UUID) error {
	query := `
		UPDATE study_goals
		SET status = 'archived', updated_at = NOW()
		WHERE id = $1 AND user_id = $2
	`

	result, err := r.db.ExecContext(ctx, query, goalID, userID)
	if err != nil {
		log.Printf("[GoalsRepository.Delete] Error archiving goal %s: %v", goalID, err)
		return err
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		return domain.ErrGoalNotFound
	}

	log.Printf("[GoalsRepository.Delete] Archived goal %s", goalID)
	return nil
}

// AddFocusTime adds focus minutes to a goal
func (r *GoalsRepository) AddFocusTime(ctx context.Context, goalID uuid.UUID, minutes int) error {
	query := `
		UPDATE study_goals
		SET completed_minutes = completed_minutes + $1, updated_at = NOW()
		WHERE id = $2
	`

	_, err := r.db.ExecContext(ctx, query, minutes, goalID)
	if err != nil {
		log.Printf("[GoalsRepository.AddFocusTime] Error adding time to goal %s: %v", goalID, err)
		return err
	}

	log.Printf("[GoalsRepository.AddFocusTime] Added %d minutes to goal %s", minutes, goalID)
	return nil
}

// CountActiveByUserID counts active goals for a user
func (r *GoalsRepository) CountActiveByUserID(ctx context.Context, userID uuid.UUID) (int, error) {
	query := `SELECT COUNT(*) FROM study_goals WHERE user_id = $1 AND status = 'active'`

	var count int
	err := r.db.QueryRowContext(ctx, query, userID).Scan(&count)
	if err != nil {
		return 0, err
	}

	return count, nil
}

// ExpireOverdueGoals marks overdue active goals as expired
func (r *GoalsRepository) ExpireOverdueGoals(ctx context.Context) (int64, error) {
	query := `
		UPDATE study_goals
		SET status = 'expired', updated_at = NOW()
		WHERE status = 'active' AND deadline < $1
	`

	result, err := r.db.ExecContext(ctx, query, time.Now().Format("2006-01-02"))
	if err != nil {
		log.Printf("[GoalsRepository.ExpireOverdueGoals] Error: %v", err)
		return 0, err
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected > 0 {
		log.Printf("[GoalsRepository.ExpireOverdueGoals] Expired %d overdue goals", rowsAffected)
	}
	return rowsAffected, nil
}
