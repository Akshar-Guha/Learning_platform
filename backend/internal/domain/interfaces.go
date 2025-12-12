package domain

import (
	"context"

	"github.com/google/uuid"
)

// Repository Interfaces

type ProfileRepository interface {
	GetByID(ctx context.Context, userID uuid.UUID) (*Profile, error)
	Update(ctx context.Context, userID uuid.UUID, req *UpdateProfileRequest) (*Profile, error)
}

type SquadRepository interface {
	Create(ctx context.Context, userID uuid.UUID, req *CreateSquadRequest) (*Squad, error)
	GetUserSquads(ctx context.Context, userID uuid.UUID) ([]Squad, error)
	GetByID(ctx context.Context, squadID uuid.UUID) (*Squad, error)
	GetDetailByID(ctx context.Context, squadID uuid.UUID) (*SquadDetail, error)
	IsMember(ctx context.Context, squadID, userID uuid.UUID) (bool, error)
	Update(ctx context.Context, squadID uuid.UUID, req *UpdateSquadRequest) (*Squad, error)
	Delete(ctx context.Context, squadID uuid.UUID) error
	JoinByInviteCode(ctx context.Context, inviteCode string, userID uuid.UUID) (uuid.UUID, error)
	RemoveMember(ctx context.Context, squadID, userID uuid.UUID) error
	RegenerateInviteCode(ctx context.Context, squadID uuid.UUID) (string, error)
}

type FocusRepository interface {
	IsMemberOfSquad(ctx context.Context, userID, squadID uuid.UUID) (bool, error)
	StartSession(ctx context.Context, userID, squadID uuid.UUID) (*FocusSession, error)
	EndSession(ctx context.Context, userID uuid.UUID) (*FocusSession, error)
	GetActiveBySquad(ctx context.Context, squadID uuid.UUID) ([]ActiveSession, error)
	GetHistoryBySquad(ctx context.Context, squadID uuid.UUID, limit int) ([]FocusHistory, error)
}

// Service Interfaces

type ProfileService interface {
	GetMyProfile(ctx context.Context, userID uuid.UUID) (*Profile, error)
	UpdateMyProfile(ctx context.Context, userID uuid.UUID, req *UpdateProfileRequest) (*Profile, error)
	GetPublicProfile(ctx context.Context, userID uuid.UUID) (*PublicProfile, error)
}

type SquadService interface {
	CreateSquad(ctx context.Context, userID uuid.UUID, req *CreateSquadRequest) (*Squad, error)
	GetMySquads(ctx context.Context, userID uuid.UUID) ([]Squad, error)
	GetSquadDetail(ctx context.Context, squadID, userID uuid.UUID) (*SquadDetail, error)
	UpdateSquad(ctx context.Context, squadID, userID uuid.UUID, req *UpdateSquadRequest) (*Squad, error)
	DeleteSquad(ctx context.Context, squadID, userID uuid.UUID) error
	JoinSquad(ctx context.Context, userID uuid.UUID, inviteCode string) (*Squad, error)
	RemoveMember(ctx context.Context, squadID, targetUserID, callerUserID uuid.UUID) error
	RegenerateInviteCode(ctx context.Context, squadID, userID uuid.UUID) (string, error)
}

type FocusService interface {
	StartFocus(ctx context.Context, userID uuid.UUID, squadID uuid.UUID) (*StartFocusResponse, error)
	StopFocus(ctx context.Context, userID uuid.UUID) (*StopFocusResponse, error)
	GetActiveInSquad(ctx context.Context, userID, squadID uuid.UUID) (*ActiveSessionsResponse, error)
	GetFocusHistory(ctx context.Context, userID, squadID uuid.UUID) (*FocusHistoryResponse, error)
}

type StreakRepository interface {
	LogActivity(ctx context.Context, userID string, activityType ActivityType, metadata map[string]interface{}) (*LogActivityResponse, error)
	GetUserStreak(ctx context.Context, userID string, includeHistory bool, historyDays int) (*StreakData, error)
	GetActivityHistory(ctx context.Context, userID string, days int) ([]ActivityDay, error)
	GetLeaderboard(ctx context.Context, limit int) ([]LeaderboardEntry, error)
	RecalculateAllStreaks(ctx context.Context) error
}

type StreakService interface {
	LogManualCheckin(ctx context.Context, userID string) (*LogActivityResponse, error)
	LogFocusSession(ctx context.Context, userID string, sessionID string, duration int) (*LogActivityResponse, error)
	GetMyStreak(ctx context.Context, userID string) (*StreakData, error)
	GetUserPublicStreak(ctx context.Context, userID string) (*StreakData, error)
	GetLeaderboard(ctx context.Context, limit int) ([]LeaderboardEntry, error)
	TriggerRecalculation(ctx context.Context) error
	ValidateActivityType(activityType ActivityType) error
}
