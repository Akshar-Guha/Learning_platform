package repository

import (
	"context"
	"database/sql"
	"encoding/json"

	"github.com/antigravity/backend/internal/domain"
	"github.com/google/uuid"
)

type NotificationRepository struct {
	db *sql.DB
}

func NewNotificationRepository(db *sql.DB) *NotificationRepository {
	return &NotificationRepository{db: db}
}

// Create inserts a new notification (System/AI use)
func (r *NotificationRepository) Create(ctx context.Context, n *domain.Notification) error {
	query := `
		INSERT INTO notifications (user_id, type, title, message, metadata)
		VALUES ($1, $2, $3, $4, $5)
		RETURNING id, created_at, is_read
	`

	// Ensure metadata is valid JSON
	if n.Metadata == nil {
		n.Metadata = json.RawMessage("{}")
	}

	return r.db.QueryRowContext(ctx, query,
		n.UserID, n.Type, n.Title, n.Message, n.Metadata,
	).Scan(&n.ID, &n.CreatedAt, &n.IsRead)
}

// List fetches notifications for a user (recent first)
func (r *NotificationRepository) List(ctx context.Context, userID uuid.UUID, limit, offset int) ([]domain.Notification, int, error) {
	// 1. Get total count
	var total int
	countQuery := `SELECT COUNT(*) FROM notifications WHERE user_id = $1`
	err := r.db.QueryRowContext(ctx, countQuery, userID).Scan(&total)
	if err != nil {
		return nil, 0, err
	}

	// 2. Fetch rows
	query := `
		SELECT id, user_id, type, title, message, is_read, created_at, metadata
		FROM notifications
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := r.db.QueryContext(ctx, query, userID, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	notifications := []domain.Notification{}
	for rows.Next() {
		var n domain.Notification
		if err := rows.Scan(
			&n.ID, &n.UserID, &n.Type, &n.Title, &n.Message, &n.IsRead, &n.CreatedAt, &n.Metadata,
		); err != nil {
			return nil, 0, err
		}
		notifications = append(notifications, n)
	}

	return notifications, total, nil
}

// MarkAsRead updates status
func (r *NotificationRepository) MarkAsRead(ctx context.Context, id uuid.UUID, userID uuid.UUID) error {
	query := `UPDATE notifications SET is_read = TRUE WHERE id = $1 AND user_id = $2`
	_, err := r.db.ExecContext(ctx, query, id, userID)
	return err
}

// MarkAllAsRead updates all for user
func (r *NotificationRepository) MarkAllAsRead(ctx context.Context, userID uuid.UUID) error {
	query := `UPDATE notifications SET is_read = TRUE WHERE user_id = $1`
	_, err := r.db.ExecContext(ctx, query, userID)
	return err
}
