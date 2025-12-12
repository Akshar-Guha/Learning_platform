-- ============================================================
-- 006_create_notifications.sql
-- Feature 5: The Nudge System - Notifications Table
-- Agent Alpha | Project Antigravity
-- ============================================================

-- ============================================================
-- 1. NOTIFICATIONS TABLE
-- Stores AI nudges and system alerts
-- ============================================================

CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('nudge', 'streak_alert', 'squad_invite')),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Comments
COMMENT ON TABLE public.notifications IS 'Stores AI-generated nudges and system notifications';
COMMENT ON COLUMN public.notifications.metadata IS 'Context payload (e.g., related squad_id, streak_count)';

-- ============================================================
-- 2. INDEXES
-- ============================================================

-- Fast lookup for user's notification feed (most recent first)
CREATE INDEX idx_notifications_user_created ON public.notifications(user_id, created_at DESC);

-- Fast lookup for unread count
CREATE INDEX idx_notifications_user_unread ON public.notifications(user_id) WHERE is_read = FALSE;

-- ============================================================
-- 3. RLS POLICIES
-- ============================================================

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Policy 1: Users can view their own notifications
CREATE POLICY "Users can view own notifications"
    ON public.notifications
    FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

-- Policy 2: Users can update their own notifications (e.g., mark as read)
CREATE POLICY "Users can update own notifications"
    ON public.notifications
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Policy 3: Only Service Role can insert notifications (System/AI generated)
-- Note: 'service_role' is the role used by the backend generic service account
CREATE POLICY "Service role can insert notifications"
    ON public.notifications
    FOR INSERT
    TO service_role
    WITH CHECK (true);

-- Allow authenticated users to insert if they are the recipient?? 
-- NO. Nudges come from the System. Squad invites might come from users actions but usually processed by backend logic.
-- STRICT: Only backend inserts.

-- ============================================================
-- 4. REALTIME
-- ============================================================

-- Enable Realtime for INSERT events so users get notified instantly
-- Run this in Supabase Dashboard if the SQL command below is not sufficient for your setup (usually requires publication alteration)
-- ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- ============================================================
-- END OF MIGRATION
-- ============================================================
