-- ============================================================
-- 005_create_activity_logs.sql
-- Feature 4: The Streak Engine - Activity Tracking
-- Agent Alpha | Project Antigravity
-- ============================================================

-- ============================================================
-- 1. TABLE DEFINITION
-- ============================================================
CREATE TABLE public.activity_logs (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Foreign key to user
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    -- Activity classification
    activity_type TEXT NOT NULL CHECK (
        activity_type IN ('focus_session', 'squad_join', 'manual_checkin')
    ),
    
    -- Timezone-aware date tracking
    activity_date DATE NOT NULL,
    
    -- UTC timestamp for auditing
    logged_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    
    -- Extensible metadata (e.g., focus duration, session_id)
    metadata JSONB DEFAULT '{}'::jsonb,
    
    -- Constraint: One activity per user per day
    UNIQUE(user_id, activity_date)
);

-- Add table comments
COMMENT ON TABLE public.activity_logs IS 'Records daily user activity for streak calculation. Timezone-aware.';
COMMENT ON COLUMN public.activity_logs.activity_type IS 'Type: focus_session (auto-logged), squad_join, or manual_checkin';
COMMENT ON COLUMN public.activity_logs.activity_date IS 'Activity date in user timezone (from profiles.timezone)';

-- ============================================================
-- 2. INDEXES FOR PERFORMANCE
-- ============================================================

-- Primary query pattern: Get user's activity sorted by date
CREATE INDEX idx_activity_user_date ON public.activity_logs(user_id, activity_date DESC);

-- For global activity tracking and analytics
CREATE INDEX idx_activity_logged_at ON public.activity_logs(logged_at DESC);

-- For activity type filtering
CREATE INDEX idx_activity_type ON public.activity_logs(activity_type);

-- ============================================================
-- 3. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================

ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

-- Policy 1: Users can read their own activity logs only
CREATE POLICY "Users can read own activity logs"
    ON public.activity_logs
    FOR SELECT
    USING (auth.uid() = user_id);

-- Policy 2: Users can insert logs for themselves (for manual check-ins)
CREATE POLICY "Users can insert own activity logs"
    ON public.activity_logs
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy 3: Service role can insert for any user (for auto-logging from focus sessions)
CREATE POLICY "Service role can insert activity logs"
    ON public.activity_logs
    FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

-- Policy 4: No updates allowed (logs are immutable)
-- No UPDATE policy = no one can update

-- Policy 5: No deletes allowed (historical data must be preserved)
-- No DELETE policy = no one can delete

-- ============================================================
-- 4. HELPER FUNCTIONS
-- ============================================================

-- Function to get user's timezone from profiles
CREATE OR REPLACE FUNCTION public.get_user_timezone(p_user_id UUID)
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT COALESCE(timezone, 'UTC')
    FROM public.profiles
    WHERE id = p_user_id;
$$;

-- ============================================================
-- 5. SMART ACTIVITY LOGGING FUNCTION
-- Prevents duplicate entries for the same day
-- ============================================================

CREATE OR REPLACE FUNCTION public.log_daily_activity(
    p_user_id UUID,
    p_activity_type TEXT,
    p_metadata JSONB DEFAULT '{}'::jsonb
)
RETURNS TABLE(
    success BOOLEAN,
    activity_id UUID,
    activity_date DATE,
    is_new BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_timezone TEXT;
    v_activity_date DATE;
    v_existing_id UUID;
BEGIN
    -- Get user's timezone
    v_timezone := get_user_timezone(p_user_id);
    
    -- Calculate date in user's timezone
    v_activity_date := (NOW() AT TIME ZONE v_timezone)::DATE;
    
    -- Check if activity already exists for today
    SELECT id INTO v_existing_id
    FROM activity_logs
    WHERE user_id = p_user_id
      AND activity_date = v_activity_date
    LIMIT 1;
    
    IF v_existing_id IS NOT NULL THEN
        -- Activity already logged for today
        RETURN QUERY SELECT
            TRUE,
            v_existing_id,
            v_activity_date,
            FALSE;
    ELSE
        -- Insert new activity
        INSERT INTO activity_logs (user_id, activity_type, activity_date, metadata)
        VALUES (p_user_id, p_activity_type, v_activity_date, p_metadata)
        RETURNING id, v_activity_date, TRUE
        INTO v_existing_id, v_activity_date;
        
        RETURN QUERY SELECT
            TRUE,
            v_existing_id,
            v_activity_date,
            TRUE;
    END IF;
END;
$$;

COMMENT ON FUNCTION public.log_daily_activity IS 'Smart insert: Logs activity only once per user per day. Returns is_new flag.';

-- ============================================================
-- 6. STREAK CALCULATION FUNCTION
-- Implements 1-day grace period logic
-- ============================================================

CREATE OR REPLACE FUNCTION public.calculate_streak(p_user_id UUID)
RETURNS TABLE(
    current_streak INTEGER,
    longest_streak INTEGER,
    last_active_date DATE
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_timezone TEXT;
    v_today DATE;
    v_dates DATE[];
    v_current_streak INT := 0;
    v_longest_streak INT := 0;
    v_temp_streak INT := 0;
    v_last_date DATE;
    v_grace_used BOOLEAN := FALSE;
    v_last_active DATE;
BEGIN
    -- Get user's timezone
    v_timezone := get_user_timezone(p_user_id);
    v_today := (NOW() AT TIME ZONE v_timezone)::DATE;
    
    -- Get all activity dates sorted descending
    SELECT ARRAY_AGG(activity_date ORDER BY activity_date DESC)
    INTO v_dates
    FROM activity_logs
    WHERE user_id = p_user_id;
    
    -- No activity = all zeros
    IF v_dates IS NULL OR ARRAY_LENGTH(v_dates, 1) = 0 THEN
        RETURN QUERY SELECT 0, 0, NULL::DATE;
        RETURN;
    END IF;
    
    -- Get most recent activity
    v_last_active := v_dates[1];
    
    -- Calculate current streak (from today backwards)
    v_last_date := v_today;
    
    FOREACH v_last_active IN ARRAY v_dates LOOP
        -- Check gap from expected date
        IF v_last_active = v_last_date THEN
            v_current_streak := v_current_streak + 1;
            v_last_date := v_last_date - 1;
        ELSIF v_last_active = v_last_date - 1 AND NOT v_grace_used THEN
            -- 1-day grace period
            v_current_streak := v_current_streak + 1;
            v_grace_used := TRUE;
            v_last_date := v_last_active - 1;
        ELSE
            -- Streak broken
            EXIT;
        END IF;
    END LOOP;
    
    -- Calculate longest streak (any time in history)
    v_temp_streak := 1;
    v_longest_streak := 1;
    
    FOR i IN 2..ARRAY_LENGTH(v_dates, 1) LOOP
        IF v_dates[i] = v_dates[i-1] - 1 THEN
            v_temp_streak := v_temp_streak + 1;
            IF v_temp_streak > v_longest_streak THEN
                v_longest_streak := v_temp_streak;
            END IF;
        ELSIF v_dates[i] = v_dates[i-1] - 2 THEN
            -- Grace period for historical streak
            v_temp_streak := v_temp_streak + 1;
            IF v_temp_streak > v_longest_streak THEN
                v_longest_streak := v_temp_streak;
            END IF;
        ELSE
            v_temp_streak := 1;
        END IF;
    END LOOP;
    
    RETURN QUERY SELECT v_current_streak, v_longest_streak, v_dates[1];
END;
$$;

COMMENT ON FUNCTION public.calculate_streak IS 'Calculates current and longest streak with 1-day grace period.';

-- ============================================================
-- 7. CONSISTENCY SCORE FUNCTION
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_consistency_score(
    p_user_id UUID,
    p_days INTEGER DEFAULT 30
)
RETURNS INTEGER
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_active_days INT;
    v_total_days INT;
    v_created_at TIMESTAMPTZ;
    v_timezone TEXT;
    v_score INT;
BEGIN
    -- Get user's creation date and timezone
    SELECT created_at, COALESCE(timezone, 'UTC')
    INTO v_created_at, v_timezone
    FROM public.profiles
    WHERE id = p_user_id;
    
    -- Calculate total days since join
    v_total_days := GREATEST(
        1, -- Minimum 1 day to avoid division by zero
        EXTRACT(DAY FROM NOW() - v_created_at)::INT
    );
    
    -- Optionally limit to recent period
    IF p_days > 0 THEN
        v_total_days := LEAST(v_total_days, p_days);
    END IF;
    
    -- Count distinct active days
    SELECT COUNT(DISTINCT activity_date)
    INTO v_active_days
    FROM activity_logs
    WHERE user_id = p_user_id
      AND activity_date >= (
          (NOW() AT TIME ZONE v_timezone)::DATE - (v_total_days - 1)
      );
    
    -- Calculate score: (Active Days / Total Days) * 100
    v_score := ROUND((v_active_days::NUMERIC / v_total_days::NUMERIC) * 100);
    
    -- Cap at 100
    RETURN LEAST(100, v_score);
END;
$$;

COMMENT ON FUNCTION public.get_consistency_score IS 'Returns consistency score (0-100) based on activity frequency.';

-- ============================================================
-- 8. DAILY STREAK UPDATE TRIGGER
-- Auto-updates profiles table when activity is logged
-- ============================================================

CREATE OR REPLACE FUNCTION public.update_streak_on_activity()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_streak_data RECORD;
    v_consistency INT;
BEGIN
    -- Calculate latest streak data
    SELECT * INTO v_streak_data
    FROM calculate_streak(NEW.user_id);
    
    -- Calculate consistency score (lifetime)
    v_consistency := get_consistency_score(NEW.user_id, 0);
    
    -- Update profiles table
    UPDATE public.profiles
    SET
        current_streak = v_streak_data.current_streak,
        longest_streak = GREATEST(longest_streak, v_streak_data.longest_streak),
        consistency_score = v_consistency,
        updated_at = NOW()
    WHERE id = NEW.user_id;
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_activity_logged
    AFTER INSERT ON public.activity_logs
    FOR EACH ROW
    EXECUTE FUNCTION public.update_streak_on_activity();

COMMENT ON TRIGGER on_activity_logged ON public.activity_logs IS 'Auto-updates streak and consistency score when activity is logged.';

-- ============================================================
-- END OF MIGRATION
-- ============================================================
