-- ============================================================
-- 003_create_focus_sessions.sql
-- Feature 3: Real-time Presence (Body Doubling)
-- Agent Alpha | Project Antigravity
-- ============================================================

-- ============================================================
-- 1. FOCUS SESSIONS TABLE
-- Tracks when users are in "focus mode" for their squad
-- ended_at = NULL indicates an active session
-- ============================================================

CREATE TABLE public.focus_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    squad_id UUID NOT NULL REFERENCES public.squads(id) ON DELETE CASCADE,
    started_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    ended_at TIMESTAMPTZ,
    
    -- Auto-calculated duration in minutes
    duration_minutes INTEGER GENERATED ALWAYS AS (
        EXTRACT(EPOCH FROM (COALESCE(ended_at, NOW()) - started_at))::INTEGER / 60
    ) STORED
);

-- Comments
COMMENT ON TABLE public.focus_sessions IS 'Tracks focus/study sessions for body doubling feature';
COMMENT ON COLUMN public.focus_sessions.ended_at IS 'NULL indicates session is currently active';
COMMENT ON COLUMN public.focus_sessions.duration_minutes IS 'Auto-calculated session duration';

-- ============================================================
-- 2. INDEXES FOR PERFORMANCE
-- ============================================================

-- Fast lookup of active sessions per squad
CREATE INDEX idx_focus_sessions_squad_active 
    ON public.focus_sessions(squad_id) 
    WHERE ended_at IS NULL;

-- Fast lookup of user's active session
CREATE INDEX idx_focus_sessions_user_active 
    ON public.focus_sessions(user_id) 
    WHERE ended_at IS NULL;

-- History queries by squad and time
CREATE INDEX idx_focus_sessions_squad_time 
    ON public.focus_sessions(squad_id, started_at DESC);

-- ============================================================
-- 3. RLS POLICIES
-- ============================================================

ALTER TABLE public.focus_sessions ENABLE ROW LEVEL SECURITY;

-- Policy 1: Squad members can view focus sessions for their squad
CREATE POLICY "Squad members can view focus sessions"
    ON public.focus_sessions
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.squad_members sm
            WHERE sm.squad_id = focus_sessions.squad_id
            AND sm.user_id = auth.uid()
        )
    );

-- Policy 2: Users can only start their own focus sessions
CREATE POLICY "Users can start own focus sessions"
    ON public.focus_sessions
    FOR INSERT
    TO authenticated
    WITH CHECK (
        user_id = auth.uid()
        AND EXISTS (
            SELECT 1 FROM public.squad_members sm
            WHERE sm.squad_id = focus_sessions.squad_id
            AND sm.user_id = auth.uid()
        )
    );

-- Policy 3: Users can only end their own focus sessions
CREATE POLICY "Users can end own focus sessions"
    ON public.focus_sessions
    FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- No DELETE policy - sessions are historical data

-- ============================================================
-- 4. HELPER FUNCTION: End active session
-- Ends any active session for a user, returns the session ID
-- ============================================================

CREATE OR REPLACE FUNCTION public.end_focus_session(p_user_id UUID)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_session_id UUID;
BEGIN
    UPDATE public.focus_sessions
    SET ended_at = NOW()
    WHERE user_id = p_user_id
    AND ended_at IS NULL
    RETURNING id INTO v_session_id;
    
    RETURN v_session_id;
END;
$$;

-- ============================================================
-- 5. ENABLE REALTIME
-- Run this in Supabase Dashboard or via API:
-- ALTER PUBLICATION supabase_realtime ADD TABLE focus_sessions;
-- ============================================================

-- Note: Realtime must be enabled via Supabase Dashboard:
-- 1. Go to Database > Replication
-- 2. Enable Realtime for 'focus_sessions' table
-- 3. Select INSERT and UPDATE events

-- ============================================================
-- END OF MIGRATION
-- ============================================================
