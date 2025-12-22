package ai

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/ulp/backend/internal/domain"
)

type GroqClient struct {
	apiKey     string
	httpClient *http.Client
}

func NewGroqClient(apiKey string) *GroqClient {
	return &GroqClient{
		apiKey: apiKey,
		httpClient: &http.Client{
			Timeout: 30 * time.Second, // Increased for complex generations
		},
	}
}

// GenerateNudge calls Groq (Llama 3 70B) to generate a supportive message
func (c *GroqClient) GenerateNudge(ctx context.Context, userName string, streakDays int, riskFactor string) (string, error) {
	if c.apiKey == "" {
		return fmt.Sprintf("Hey %s! Keep up the great work on your %d day streak! You got this!", userName, streakDays), nil
	}

	// Prompt construction
	prompt := fmt.Sprintf(`
You are a supportive, chill gym buddy. 
User: %s
Current Streak: %d days
Risk Factor: %s
Goal: Keep them consistent.
Constraint: Maximum 15 words. Lowercase only. No emojis. Punchy and motivating.
Message:
`, userName, streakDays, riskFactor)

	return c.callGroq(ctx, prompt, 50)
}

// GenerateStudyPlan creates an AI-powered study schedule for a goal
func (c *GroqClient) GenerateStudyPlan(ctx context.Context, input domain.GoalInput) (*domain.AISchedule, error) {
	log.Printf("[GroqClient.GenerateStudyPlan] Generating schedule for goal: %s", input.Title)

	if c.apiKey == "" {
		log.Printf("[GroqClient.GenerateStudyPlan] No API key, returning nil for fallback")
		return nil, fmt.Errorf("groq api key not configured")
	}

	prompt := fmt.Sprintf(`You are a practical study planner AI. Generate an evidence-based schedule in JSON format.

RULES:
- Output ONLY valid JSON, no other text
- Use 45-52 minute focus blocks with breaks
- Max 4 productive hours per day (realistic for students)
- Distribute hours evenly across available days
- Account for weekends having more availability

GOAL CONTEXT:
- Title: %s
- Target Hours: %d
- Deadline: %s (%d days remaining)
- Priority: %d (1=High, 2=Medium, 3=Low)

REQUIRED JSON FORMAT:
{
  "days": [
    { "date": "YYYY-MM-DD", "blocks": [{ "start": "HH:MM", "duration": 50 }] }
  ],
  "daily_target_mins": <number>,
  "buffer_hours": <number>
}

Generate the schedule:`, input.Title, input.TargetHours, input.Deadline, input.DaysLeft, input.Priority)

	response, err := c.callGroq(ctx, prompt, 2000)
	if err != nil {
		log.Printf("[GroqClient.GenerateStudyPlan] API call failed: %v", err)
		return nil, err
	}

	// Parse JSON response
	var schedule domain.AISchedule
	if err := json.Unmarshal([]byte(response), &schedule); err != nil {
		log.Printf("[GroqClient.GenerateStudyPlan] JSON parse failed: %v, response: %s", err, response)
		return nil, fmt.Errorf("failed to parse AI response as JSON")
	}

	schedule.GeneratedAt = time.Now()
	log.Printf("[GroqClient.GenerateStudyPlan] Schedule generated with %d days", len(schedule.Days))
	return &schedule, nil
}

// GenerateSessionInsight creates a data-driven insight after a focus session
// IMPORTANT: No motivational text - only factual, actionable insights
func (c *GroqClient) GenerateSessionInsight(ctx context.Context, session domain.SessionContext) (*domain.SessionInsight, error) {
	log.Printf("[GroqClient.GenerateSessionInsight] Generating insight for session %s", session.SessionID)

	if c.apiKey == "" {
		// Fallback: generate simple pattern insight
		return c.generateFallbackInsight(session), nil
	}

	prompt := fmt.Sprintf(`You are a focus analytics AI. Provide ONE practical insight based on data.

CRITICAL RULES:
- Maximum 30 words
- Must reference actual numbers from the data
- Provide actionable suggestion OR pattern observation
- NEVER use motivational phrases like: "Great job", "Keep up", "Awesome", "You got this", "Well done"
- Be specific with numbers and percentages

SESSION DATA:
- Duration: %d mins
- Time of day: %s
- Goal: %s
- Average session (last 7 days): %d mins
- Total focus this week: %d mins
- Best performing time: %s
- Current streak: %d days

GOOD EXAMPLE INSIGHTS:
- "Session was 47 mins vs avg 32. This 45-50 min range shows optimal retention."
- "3 PM sessions average 28 mins vs 45 mins at 9 AM. Morning focus is stronger."
- "You've completed 12 of 24 target hours with 8 days left. On track."

BAD (NEVER GENERATE):
- "Great work today!"
- "Keep pushing, you're doing amazing!"

Generate insight:`,
		session.DurationMins,
		session.StartTime,
		session.GoalTitle,
		session.AvgSessionMins,
		session.WeeklyTotalMins,
		session.BestFocusTime,
		session.CurrentStreakDays)

	response, err := c.callGroq(ctx, prompt, 100)
	if err != nil {
		log.Printf("[GroqClient.GenerateSessionInsight] API call failed: %v", err)
		return c.generateFallbackInsight(session), nil
	}

	insight := &domain.SessionInsight{
		SessionID:   session.SessionID,
		UserID:      session.UserID,
		GoalID:      session.GoalID,
		InsightType: domain.InsightTypePattern,
		InsightText: response,
		DataPoints: domain.DataPoints{
			ThisSessionMins: session.DurationMins,
			AvgSessionMins:  session.AvgSessionMins,
			SessionTime:     session.StartTime,
			BestFocusTime:   session.BestFocusTime,
			WeeklyTotalMins: session.WeeklyTotalMins,
			StreakDays:      session.CurrentStreakDays,
		},
		CreatedAt: time.Now(),
	}

	log.Printf("[GroqClient.GenerateSessionInsight] Insight generated: %s", response)
	return insight, nil
}

// generateFallbackInsight creates a simple insight when AI is unavailable
func (c *GroqClient) generateFallbackInsight(session domain.SessionContext) *domain.SessionInsight {
	// Generate data-driven insight without AI
	var insightText string
	var insightType domain.InsightType

	if session.DurationMins > session.AvgSessionMins+10 {
		insightType = domain.InsightTypePattern
		insightText = fmt.Sprintf("Session was %d mins, %d mins longer than your average.",
			session.DurationMins, session.DurationMins-session.AvgSessionMins)
	} else if session.DurationMins < session.AvgSessionMins-10 {
		insightType = domain.InsightTypeRecommendation
		insightText = fmt.Sprintf("Session was %d mins, shorter than avg %d. Try %s for longer focus.",
			session.DurationMins, session.AvgSessionMins, session.BestFocusTime)
	} else {
		insightType = domain.InsightTypeComparison
		insightText = fmt.Sprintf("Session: %d mins. Weekly total: %d mins. Current streak: %d days.",
			session.DurationMins, session.WeeklyTotalMins, session.CurrentStreakDays)
	}

	return &domain.SessionInsight{
		SessionID:   session.SessionID,
		UserID:      session.UserID,
		GoalID:      session.GoalID,
		InsightType: insightType,
		InsightText: insightText,
		DataPoints: domain.DataPoints{
			ThisSessionMins: session.DurationMins,
			AvgSessionMins:  session.AvgSessionMins,
			SessionTime:     session.StartTime,
			BestFocusTime:   session.BestFocusTime,
			WeeklyTotalMins: session.WeeklyTotalMins,
			StreakDays:      session.CurrentStreakDays,
		},
		CreatedAt: time.Now(),
	}
}

// callGroq makes the actual API call to Groq
func (c *GroqClient) callGroq(ctx context.Context, prompt string, maxTokens int) (string, error) {
	reqBody := map[string]interface{}{
		"model": "llama3-70b-8192",
		"messages": []map[string]string{
			{"role": "user", "content": prompt},
		},
		"temperature": 0.7,
		"max_tokens":  maxTokens,
	}

	jsonBody, _ := json.Marshal(reqBody)

	req, err := http.NewRequestWithContext(ctx, "POST", "https://api.groq.com/openai/v1/chat/completions", bytes.NewBuffer(jsonBody))
	if err != nil {
		return "", err
	}

	req.Header.Set("Authorization", "Bearer "+c.apiKey)
	req.Header.Set("Content-Type", "application/json")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		log.Printf("[GroqClient.callGroq] API error: status %d", resp.StatusCode)
		return "", fmt.Errorf("groq api error: status %d", resp.StatusCode)
	}

	var result struct {
		Choices []struct {
			Message struct {
				Content string `json:"content"`
			} `json:"message"`
		} `json:"choices"`
	}

	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return "", err
	}

	if len(result.Choices) > 0 {
		return result.Choices[0].Message.Content, nil
	}

	return "", fmt.Errorf("no response from groq")
}
