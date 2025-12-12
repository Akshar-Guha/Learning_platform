package ai

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type GroqClient struct {
	apiKey     string
	httpClient *http.Client
}

func NewGroqClient(apiKey string) *GroqClient {
	return &GroqClient{
		apiKey: apiKey,
		httpClient: &http.Client{
			Timeout: 10 * time.Second,
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

	reqBody := map[string]interface{}{
		"model": "llama3-70b-8192",
		"messages": []map[string]string{
			{"role": "user", "content": prompt},
		},
		"temperature": 0.7,
		"max_tokens":  50,
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

	return "keep going!", nil
}
