-- ============================================================
-- 008_create_session_insights.sql
-- Feature: AI-Generated Session Insights
-- Agent Alpha | Project Antigravity
-- ============================================================

-- ============================================================
-- 1. SESSION INSIGHTS TABLE
-- Stores AI-generated insights after focus sessions
-- NOTE: Insights are DATA-DRIVEN, NOT motivational
-- ============================================================

CREATE TABLE public.session_insights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES public.focus_sessions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    goal_id UUID REFERENCES public.study_goals(id) ON DELETE SET NULL,
    insight_type TEXT NOT NULL CHECK (insight_type IN (
        'pattern',        -- Observable pattern in user behavior
        'comparison',     -- Comparison to averages/previous data
        'milestone',      -- Achievement of a specific milestone
        'recommendation'  -- Actionable suggestion based on data
    )),
    insight_text TEXT NOT NULL CHECK (char_length(insight_text) >= 10 AND char_length(insight_text) <= 200),
    data_points JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Comments for clarity
COMMENT ON TABLE public.session_insights IS 'AI-generated insights after focus sessions - data-driven, NOT motivational';
COMMENT ON COLUMN public.session_insights.insight_type IS 'Type of insight: pattern, comparison, milestone, or recommendation';
COMMENT ON COLUMN public.session_insights.insight_text IS 'The actual insight text (max 200 chars)';
COMMENT ON COLUMN public.session_insights.data_points IS 'JSON with raw stats backing the insight e.g. {"avg_session": 32, "this_session": 47}';

-- ============================================================
-- 2. INDEXES FOR PERFORMANCE
-- ============================================================

-- Recent insights for user (dashboard display)
CREATE INDEX idx_session_insights_user_recent 
    ON public.session_insights(user_id, created_at DESC);

-- Insights by session (for session detail view)
CREATE INDEX idx_session_insights_session 
    ON public.session_insights(session_id);

-- Insights by goal (for goal analytics)
CREATE INDEX idx_session_insights_goal 
    ON public.session_insights(goal_id) 
    WHERE goal_id IS NOT NULL;

-- ============================================================
-- 3. RLS POLICIES
-- ============================================================

ALTER TABLE public.session_insights ENABLE ROW LEVEL SECURITY;

-- Policy 1: Users can view their own insights
CREATE POLICY "Users can view own insights"
    ON public.session_insights
    FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

-- Policy 2: Service role can insert insights (AI-generated via backend)
CREATE POLICY "Service role can insert insights"
    ON public.session_insights
    FOR INSERT
    TO service_role
    WITH CHECK (true);

-- Policy 3: Authenticated can insert own insights (for fallback from client)
CREATE POLICY "Users can insert own insights"
    ON public.session_insights
    FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

-- ============================================================
-- 4. HELPER VIEW: Recent Insights with Session Info
-- For efficient dashboard queries
-- ============================================================

CREATE OR REPLACE VIEW public.recent_insights_view AS
SELECT 
    si.id,
    si.user_id,
    si.session_id,
    si.goal_id,
    si.insight_type,
    si.insight_text,
    si.data_points,
    si.created_at,
    fs.started_at AS session_started_at,
    fs.duration_minutes AS session_duration,
    sg.title AS goal_title
FROM public.session_insights si
LEFT JOIN public.focus_sessions fs ON si.session_id = fs.id
LEFT JOIN public.study_goals sg ON si.goal_id = sg.id
ORDER BY si.created_at DESC;

COMMENT ON VIEW public.recent_insights_view IS 'Joined view of insights with session and goal context';

-- ============================================================
-- END OF MIGRATION
-- ============================================================
