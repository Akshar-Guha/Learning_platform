package service

import (
	"context"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/ulp/backend/internal/ai"
	"github.com/ulp/backend/internal/domain"
	"github.com/ulp/backend/internal/repository"
)

// GoalsService handles business logic for study goals
type GoalsService struct {
	repo       *repository.GoalsRepository
	groqClient *ai.GroqClient
}

// NewGoalsService creates a new goals service
func NewGoalsService(repo *repository.GoalsRepository, groqClient *ai.GroqClient) *GoalsService {
	return &GoalsService{repo: repo, groqClient: groqClient}
}

// CreateGoal creates a new study goal
func (s *GoalsService) CreateGoal(ctx context.Context, userID uuid.UUID, req domain.CreateGoalRequest) (*domain.StudyGoal, error) {
	log.Printf("[GoalsService.CreateGoal] User %s creating goal: %s", userID, req.Title)

	// Parse and validate deadline
	deadline, err := time.Parse("2006-01-02", req.Deadline)
	if err != nil {
		log.Printf("[GoalsService.CreateGoal] Invalid deadline format: %s", req.Deadline)
		return nil, domain.ErrInvalidDeadline
	}

	// Check deadline is in the future
	if deadline.Before(time.Now().Truncate(24 * time.Hour)) {
		log.Printf("[GoalsService.CreateGoal] Deadline in the past: %s", req.Deadline)
		return nil, domain.ErrInvalidDeadline
	}

	// Check goal limit (additional check, DB trigger is the source of truth)
	count, err := s.repo.CountActiveByUserID(ctx, userID)
	if err != nil {
		log.Printf("[GoalsService.CreateGoal] Error counting active goals: %v", err)
		return nil, err
	}
	if count >= 5 {
		log.Printf("[GoalsService.CreateGoal] User %s has reached goal limit (%d)", userID, count)
		return nil, domain.ErrGoalLimitReached
	}

	goal := &domain.StudyGoal{
		UserID:      userID,
		Title:       req.Title,
		Description: req.Description,
		TargetHours: req.TargetHours,
		Deadline:    deadline,
		Priority:    domain.GoalPriority(req.Priority),
		Status:      domain.GoalStatusActive,
	}

	createdGoal, err := s.repo.Create(ctx, goal)
	if err != nil {
		log.Printf("[GoalsService.CreateGoal] Error creating goal: %v", err)
		return nil, err
	}

	log.Printf("[GoalsService.CreateGoal] Goal created successfully: %s", createdGoal.ID)
	return createdGoal, nil
}

// GetGoal retrieves a goal by ID
func (s *GoalsService) GetGoal(ctx context.Context, userID, goalID uuid.UUID) (*domain.StudyGoal, error) {
	log.Printf("[GoalsService.GetGoal] User %s fetching goal %s", userID, goalID)

	goal, err := s.repo.GetByID(ctx, userID, goalID)
	if err != nil {
		log.Printf("[GoalsService.GetGoal] Error: %v", err)
		return nil, err
	}

	return goal, nil
}

// ListGoals lists all goals for a user
func (s *GoalsService) ListGoals(ctx context.Context, userID uuid.UUID, activeOnly bool) ([]domain.StudyGoal, error) {
	log.Printf("[GoalsService.ListGoals] User %s listing goals (activeOnly=%t)", userID, activeOnly)

	goals, err := s.repo.ListByUserID(ctx, userID, activeOnly)
	if err != nil {
		log.Printf("[GoalsService.ListGoals] Error: %v", err)
		return nil, err
	}

	log.Printf("[GoalsService.ListGoals] Found %d goals", len(goals))
	return goals, nil
}

// UpdateGoal updates a goal's fields
func (s *GoalsService) UpdateGoal(ctx context.Context, userID, goalID uuid.UUID, req domain.UpdateGoalRequest) (*domain.StudyGoal, error) {
	log.Printf("[GoalsService.UpdateGoal] User %s updating goal %s", userID, goalID)

	// Get existing goal
	goal, err := s.repo.GetByID(ctx, userID, goalID)
	if err != nil {
		return nil, err
	}

	// Apply updates
	if req.Title != nil {
		goal.Title = *req.Title
	}
	if req.Description != nil {
		goal.Description = req.Description
	}
	if req.TargetHours != nil {
		goal.TargetHours = *req.TargetHours
	}
	if req.Deadline != nil {
		deadline, err := time.Parse("2006-01-02", *req.Deadline)
		if err != nil {
			return nil, domain.ErrInvalidDeadline
		}
		goal.Deadline = deadline
	}
	if req.Priority != nil {
		goal.Priority = domain.GoalPriority(*req.Priority)
	}
	if req.Status != nil {
		goal.Status = domain.GoalStatus(*req.Status)
	}

	updatedGoal, err := s.repo.Update(ctx, goal)
	if err != nil {
		log.Printf("[GoalsService.UpdateGoal] Error: %v", err)
		return nil, err
	}

	log.Printf("[GoalsService.UpdateGoal] Goal updated successfully")
	return updatedGoal, nil
}

// DeleteGoal archives a goal (soft delete)
func (s *GoalsService) DeleteGoal(ctx context.Context, userID, goalID uuid.UUID) error {
	log.Printf("[GoalsService.DeleteGoal] User %s archiving goal %s", userID, goalID)

	err := s.repo.Delete(ctx, userID, goalID)
	if err != nil {
		log.Printf("[GoalsService.DeleteGoal] Error: %v", err)
		return err
	}

	log.Printf("[GoalsService.DeleteGoal] Goal archived successfully")
	return nil
}

// GenerateSchedule generates an AI study schedule for a goal (once only)
func (s *GoalsService) GenerateSchedule(ctx context.Context, userID, goalID uuid.UUID) (*domain.AISchedule, error) {
	log.Printf("[GoalsService.GenerateSchedule] User %s generating schedule for goal %s", userID, goalID)

	// Get the goal
	goal, err := s.repo.GetByID(ctx, userID, goalID)
	if err != nil {
		return nil, err
	}

	// Check if schedule already generated
	if goal.AIScheduleGenerated {
		log.Printf("[GoalsService.GenerateSchedule] Schedule already generated for goal %s", goalID)
		return nil, domain.ErrScheduleAlreadyGenerated
	}

	// Prepare input for AI
	input := domain.GoalInput{
		Title:       goal.Title,
		TargetHours: goal.TargetHours,
		Deadline:    goal.Deadline.Format("2006-01-02"),
		DaysLeft:    goal.DaysRemaining(),
		Priority:    int(goal.Priority),
	}

	// Generate schedule via Groq
	schedule, err := s.groqClient.GenerateStudyPlan(ctx, input)
	if err != nil {
		log.Printf("[GoalsService.GenerateSchedule] AI generation failed: %v", err)
		// Return fallback schedule
		schedule = s.generateFallbackSchedule(goal)
	}

	// Save schedule to database
	err = s.repo.SaveAISchedule(ctx, goalID, schedule)
	if err != nil {
		log.Printf("[GoalsService.GenerateSchedule] Failed to save schedule: %v", err)
		return nil, err
	}

	log.Printf("[GoalsService.GenerateSchedule] Schedule generated and saved for goal %s", goalID)
	return schedule, nil
}

// generateFallbackSchedule creates a simple schedule when AI is unavailable
func (s *GoalsService) generateFallbackSchedule(goal *domain.StudyGoal) *domain.AISchedule {
	daysLeft := goal.DaysRemaining()
	if daysLeft <= 0 {
		daysLeft = 1
	}

	// Calculate daily target (max 4 hours per day)
	totalMinutes := goal.TargetHours * 60
	remainingMinutes := totalMinutes - goal.CompletedMinutes
	dailyMinutes := remainingMinutes / daysLeft
	if dailyMinutes > 240 { // Max 4 hours
		dailyMinutes = 240
	}

	// Generate simple daily plan
	var days []domain.DailyPlan
	currentDate := time.Now()

	for i := 0; i < daysLeft && i < 14; i++ { // Max 14 days shown
		date := currentDate.AddDate(0, 0, i)

		// Create focus blocks (50-min sessions with 10-min breaks)
		var blocks []domain.FocusBlock
		remainingDaily := dailyMinutes
		startHour := 9 // Default start at 9 AM

		for remainingDaily > 0 && startHour < 20 { // Until 8 PM
			blockDuration := 50
			if remainingDaily < 50 {
				blockDuration = remainingDaily
			}

			blocks = append(blocks, domain.FocusBlock{
				Start:    time.Date(2000, 1, 1, startHour, 0, 0, 0, time.UTC).Format("15:04"),
				Duration: blockDuration,
			})

			remainingDaily -= blockDuration
			startHour++ // Move to next hour (50 min work + 10 min break)
		}

		days = append(days, domain.DailyPlan{
			Date:   date.Format("2006-01-02"),
			Blocks: blocks,
		})
	}

	return &domain.AISchedule{
		Days:            days,
		DailyTargetMins: dailyMinutes,
		BufferHours:     goal.TargetHours / 5, // 20% buffer
		GeneratedAt:     time.Now(),
	}
}

// AddFocusTime adds focus minutes to a goal
func (s *GoalsService) AddFocusTime(ctx context.Context, goalID uuid.UUID, minutes int) error {
	log.Printf("[GoalsService.AddFocusTime] Adding %d minutes to goal %s", minutes, goalID)

	err := s.repo.AddFocusTime(ctx, goalID, minutes)
	if err != nil {
		log.Printf("[GoalsService.AddFocusTime] Error: %v", err)
		return err
	}

	return nil
}
