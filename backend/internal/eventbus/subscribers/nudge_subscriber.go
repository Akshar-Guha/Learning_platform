package subscribers

import (
	"context"
	"encoding/json"
	"log"

	"github.com/antigravity/backend/internal/ai"
	"github.com/antigravity/backend/internal/domain"
	"github.com/antigravity/backend/internal/eventbus"
	"github.com/antigravity/backend/internal/repository"
)

// NudgeSubscriber listens to streak risk events and creates AI nudges
type NudgeSubscriber struct {
	bus       *eventbus.EventBus
	groq      *ai.GroqClient
	notifRepo *repository.NotificationRepository
}

// NewNudgeSubscriber creates a new subscriber
func NewNudgeSubscriber(bus *eventbus.EventBus, groq *ai.GroqClient, notifRepo *repository.NotificationRepository) *NudgeSubscriber {
	return &NudgeSubscriber{
		bus:       bus,
		groq:      groq,
		notifRepo: notifRepo,
	}
}

// Start begins listening on streak.risk events
func (s *NudgeSubscriber) Start(ctx context.Context) error {
	log.Println("📡 Starting NudgeSubscriber on events.streak.risk...")

	// Ensure stream exists
	if err := s.bus.InitStream(ctx, "ANTIGRAVITY", []string{"events.>"}); err != nil {
		log.Printf("Warning: Stream init failed (may exist): %v", err)
	}

	return s.bus.Subscribe(ctx, "ANTIGRAVITY", eventbus.SubjectStreakRisk, "nudge_processor", s.handleMessage)
}

func (s *NudgeSubscriber) handleMessage(msg []byte) error {
	var event eventbus.StreakRiskEvent
	if err := json.Unmarshal(msg, &event); err != nil {
		log.Printf("Failed to parse event: %v", err)
		return err
	}

	log.Printf("⚠️ Streak risk for %s (%d days): %s", event.UserName, event.StreakDays, event.RiskFactor)

	// Generate AI nudge
	ctx := context.Background()
	nudgeMsg, err := s.groq.GenerateNudge(ctx, event.UserName, event.StreakDays, event.RiskFactor)
	if err != nil {
		log.Printf("Groq error (using fallback): %v", err)
		nudgeMsg = "hey, your streak is at risk. just one quick check-in can save it!"
	}

	// Create notification
	notification := &domain.Notification{
		UserID:   event.UserID,
		Type:     "streak_alert",
		Title:    "Streak at Risk! 🔥",
		Message:  nudgeMsg,
		Metadata: json.RawMessage(`{"risk_factor":"` + event.RiskFactor + `","streak_days":` + string(rune(event.StreakDays)) + `}`),
	}

	if err := s.notifRepo.Create(ctx, notification); err != nil {
		log.Printf("Failed to save notification: %v", err)
		return err
	}

	log.Printf("✅ Nudge sent to %s: %q", event.UserName, nudgeMsg)
	return nil
}
