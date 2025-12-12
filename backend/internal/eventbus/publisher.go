package eventbus

import (
	"context"
	"encoding/json"
	"log"
)

// Publisher wraps the EventBus for publishing events
type Publisher struct {
	bus *EventBus
}

// NewPublisher creates a new Publisher
func NewPublisher(bus *EventBus) *Publisher {
	return &Publisher{bus: bus}
}

// PublishActivityLogged publishes when user completes activity
func (p *Publisher) PublishActivityLogged(ctx context.Context, event ActivityLoggedEvent) error {
	if p.bus == nil {
		log.Println("Warning: EventBus is nil, skipping publish")
		return nil
	}
	return p.publish(ctx, SubjectActivityLogged, event)
}

// PublishStreakRisk publishes when streak is at risk
func (p *Publisher) PublishStreakRisk(ctx context.Context, event StreakRiskEvent) error {
	if p.bus == nil {
		log.Println("Warning: EventBus is nil, skipping publish")
		return nil
	}
	return p.publish(ctx, SubjectStreakRisk, event)
}

// PublishStreakBroken publishes when streak breaks
func (p *Publisher) PublishStreakBroken(ctx context.Context, event StreakBrokenEvent) error {
	if p.bus == nil {
		log.Println("Warning: EventBus is nil, skipping publish")
		return nil
	}
	return p.publish(ctx, SubjectStreakBroken, event)
}

func (p *Publisher) publish(ctx context.Context, subject string, event interface{}) error {
	payload, err := json.Marshal(event)
	if err != nil {
		return err
	}

	log.Printf("📤 Publishing to %s: %s", subject, string(payload))
	return p.bus.Publish(ctx, subject, event)
}
