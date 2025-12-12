-- ============================================================
-- 001_create_profiles.sql
-- Phase 1: Foundation - User Profiles Schema
-- Agent Alpha | Project Antigravity
-- ============================================================

-- ============================================================
-- 1. TABLE DEFINITION
-- ============================================================
CREATE TABLE public.profiles (
    -- Primary key linked to Supabase Auth
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- Core profile fields
    email TEXT NOT NULL UNIQUE,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    
    -- Verification
    is_edu_verified BOOLEAN DEFAULT FALSE,
    
    -- Timezone for streak calculations
    timezone TEXT DEFAULT 'UTC',
    
    -- Gamification metrics
    consistency_score INTEGER DEFAULT 0 CHECK (consistency_score >= 0 AND consistency_score <= 100),
    current_streak INTEGER DEFAULT 0 CHECK (current_streak >= 0),
    longest_streak INTEGER DEFAULT 0 CHECK (longest_streak >= 0),
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Add table comments
COMMENT ON TABLE public.profiles IS 'User profiles extending Supabase Auth. Links 1:1 with auth.users.';
COMMENT ON COLUMN public.profiles.consistency_score IS 'Core gamification metric (0-100). Calculated by StreakEngine.';
COMMENT ON COLUMN public.profiles.is_edu_verified IS 'True if user email ends with .edu domain.';

-- ============================================================
-- 2. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policy 1: Users can read their own profile
CREATE POLICY "Users can read own profile"
    ON public.profiles
    FOR SELECT
    USING (auth.uid() = id);

-- Policy 2: Authenticated users can view public profiles
CREATE POLICY "Authenticated users can view profiles"
    ON public.profiles
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- Policy 3: Users can only update their own profile
CREATE POLICY "Users can update own profile"
    ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Policy 4: Profile insert handled by trigger (service role)
CREATE POLICY "Service role can insert profiles"
    ON public.profiles
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- ============================================================
-- 3. AUTO-CREATE PROFILE TRIGGER
-- Creates profile on auth.users insert, checks .edu email
-- ============================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    INSERT INTO public.profiles (id, email, display_name, is_edu_verified)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(
            NEW.raw_user_meta_data->>'display_name',
            SPLIT_PART(NEW.email, '@', 1)
        ),
        -- Check if email ends with .edu
        NEW.email LIKE '%.edu'
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- 4. UPDATED_AT TRIGGER
-- ============================================================

CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_profile_updated
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- ============================================================
-- 5. INDEXES FOR PERFORMANCE
-- ============================================================

CREATE INDEX idx_profiles_consistency_score ON public.profiles(consistency_score DESC);
CREATE INDEX idx_profiles_current_streak ON public.profiles(current_streak DESC);
CREATE INDEX idx_profiles_is_edu_verified ON public.profiles(is_edu_verified) WHERE is_edu_verified = TRUE;

-- ============================================================
-- END OF MIGRATION
-- ============================================================
