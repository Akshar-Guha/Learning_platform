-- ============================================================
-- 009_add_goal_to_focus_sessions.sql
-- Feature: Link Focus Sessions to Study Goals
-- Agent Alpha | Project Antigravity
-- ============================================================

-- ============================================================
-- 1. ADD GOAL_ID COLUMN TO FOCUS_SESSIONS
-- Optional: User can select which goal they're focusing on
-- ============================================================

ALTER TABLE public.focus_sessions 
ADD COLUMN goal_id UUID REFERENCES public.study_goals(id) ON DELETE SET NULL;

COMMENT ON COLUMN public.focus_sessions.goal_id IS 'Optional: The goal user is working toward during this session';

-- ============================================================
-- 2. INDEX FOR GOAL-BASED QUERIES
-- ============================================================

CREATE INDEX idx_focus_sessions_goal 
    ON public.focus_sessions(goal_id) 
    WHERE goal_id IS NOT NULL;

-- ============================================================
-- 3. TRIGGER: AUTO-UPDATE GOAL PROGRESS ON SESSION END
-- When a focus session ends, add the duration to the goal
-- ============================================================

CREATE OR REPLACE FUNCTION public.update_goal_on_session_end()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- Only trigger when session ends (ended_at changes from NULL to a value)
    IF NEW.ended_at IS NOT NULL AND OLD.ended_at IS NULL AND NEW.goal_id IS NOT NULL THEN
        -- Calculate duration in minutes
        PERFORM public.add_focus_time_to_goal(
            NEW.goal_id,
            EXTRACT(EPOCH FROM (NEW.ended_at - NEW.started_at))::INTEGER / 60
        );
    END IF;
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_update_goal_on_session_end
    AFTER UPDATE ON public.focus_sessions
    FOR EACH ROW EXECUTE FUNCTION public.update_goal_on_session_end();

-- ============================================================
-- 4. ADD NEW NOTIFICATION TYPE FOR FOCUS ACTIVITY
-- Extend the notifications table check constraint
-- ============================================================

-- First drop the existing constraint
ALTER TABLE public.notifications 
DROP CONSTRAINT IF EXISTS notifications_type_check;

-- Add new constraint with additional types
ALTER TABLE public.notifications 
ADD CONSTRAINT notifications_type_check 
CHECK (type IN (
    'nudge',           -- AI-generated nudge
    'streak_alert',    -- Streak at risk
    'squad_invite',    -- Invited to squad
    'squad_focus',     -- Squad member started focusing
    'session_complete',-- Focus session completed with insight
    'goal_complete'    -- Goal achieved!
));

-- ============================================================
-- END OF MIGRATION
-- ============================================================
