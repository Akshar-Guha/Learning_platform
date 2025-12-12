package domain

import "errors"

// Domain errors
var (
	// Profile errors
	ErrProfileNotFound = errors.New("profile not found")
	
	// Squad errors
	ErrSquadNotFound          = errors.New("squad not found")
	ErrSquadNameRequired      = errors.New("squad name is required")
	ErrSquadNameTooLong       = errors.New("squad name must be 50 characters or less")
	ErrSquadDescriptionTooLong = errors.New("squad description must be 200 characters or less")
	ErrNotSquadOwner          = errors.New("only squad owner can perform this action")
	ErrSquadFull              = errors.New("squad is full")
	ErrAlreadyMember          = errors.New("already a member of this squad")
	ErrInvalidInviteCode      = errors.New("invalid invite code")
	ErrNotSquadMember         = errors.New("not a member of this squad")
	ErrCannotKickOwner        = errors.New("cannot kick squad owner")
	
	// Auth errors
	ErrUnauthorized = errors.New("unauthorized")
)
