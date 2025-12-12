-- ============================================================
-- 002_create_squads.sql
-- Feature 2: Squad Engine - Tables, Functions, RLS
-- Agent Alpha | Project Antigravity
-- ============================================================

-- ============================================================
-- 1. HELPER FUNCTION: Generate Invite Code
-- Returns unique 8-character alphanumeric string
-- ============================================================

CREATE OR REPLACE FUNCTION public.generate_invite_code()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; -- Excludes confusing chars (0,O,1,I)
    result TEXT := '';
    i INTEGER;
BEGIN
    FOR i IN 1..8 LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::integer, 1);
    END LOOP;
    RETURN result;
END;
$$;

-- ============================================================
-- 2. SQUADS TABLE
-- ============================================================

CREATE TABLE public.squads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL CHECK (char_length(name) >= 1 AND char_length(name) <= 50),
    description TEXT CHECK (description IS NULL OR char_length(description) <= 200),
    invite_code TEXT NOT NULL UNIQUE DEFAULT public.generate_invite_code() 
        CHECK (char_length(invite_code) = 8),
    owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    max_members INTEGER DEFAULT 4 CHECK (max_members >= 2 AND max_members <= 4),
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Indexes
CREATE INDEX idx_squads_owner_id ON public.squads(owner_id);
CREATE INDEX idx_squads_invite_code ON public.squads(invite_code);

-- Comments
COMMENT ON TABLE public.squads IS 'Accountability groups (max 4 members each)';
COMMENT ON COLUMN public.squads.invite_code IS 'Unique 8-char alphanumeric code for joining';

-- ============================================================
-- 3. SQUAD MEMBERS TABLE (Junction Table)
-- ============================================================

CREATE TABLE public.squad_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    squad_id UUID NOT NULL REFERENCES public.squads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role TEXT DEFAULT 'member' CHECK (role IN ('owner', 'member')),
    joined_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    
    -- Prevent duplicate memberships
    UNIQUE (squad_id, user_id)
);

-- Indexes
CREATE INDEX idx_squad_members_squad_id ON public.squad_members(squad_id);
CREATE INDEX idx_squad_members_user_id ON public.squad_members(user_id);

-- Comments
COMMENT ON TABLE public.squad_members IS 'Squad membership records';

-- ============================================================
-- 4. RLS POLICIES - SQUADS
-- ============================================================

ALTER TABLE public.squads ENABLE ROW LEVEL SECURITY;

-- SELECT: Authenticated users can view all squads (public discovery)
CREATE POLICY "Squads are viewable by authenticated users"
    ON public.squads
    FOR SELECT
    TO authenticated
    USING (true);

-- INSERT: Authenticated users can create squads
CREATE POLICY "Authenticated users can create squads"
    ON public.squads
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = owner_id);

-- UPDATE: Only owner can update squad
CREATE POLICY "Owners can update their squads"
    ON public.squads
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = owner_id)
    WITH CHECK (auth.uid() = owner_id);

-- DELETE: Only owner can delete squad
CREATE POLICY "Owners can delete their squads"
    ON public.squads
    FOR DELETE
    TO authenticated
    USING (auth.uid() = owner_id);

-- ============================================================
-- 5. RLS POLICIES - SQUAD MEMBERS
-- ============================================================

ALTER TABLE public.squad_members ENABLE ROW LEVEL SECURITY;

-- SELECT: Members can see their squad's members
CREATE POLICY "Members can view squad members"
    ON public.squad_members
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.squad_members sm
            WHERE sm.squad_id = squad_members.squad_id
            AND sm.user_id = auth.uid()
        )
    );

-- INSERT: Handled via join_squad() function (SECURITY DEFINER)
CREATE POLICY "Members inserted via function"
    ON public.squad_members
    FOR INSERT
    TO authenticated
    WITH CHECK (false); -- Blocked directly, use join_squad()

-- DELETE: Owner can kick, member can leave (self-delete)
CREATE POLICY "Members can leave or owners can kick"
    ON public.squad_members
    FOR DELETE
    TO authenticated
    USING (
        -- Self-leave
        user_id = auth.uid()
        OR
        -- Owner kick
        EXISTS (
            SELECT 1 FROM public.squads s
            WHERE s.id = squad_members.squad_id
            AND s.owner_id = auth.uid()
        )
    );

-- ============================================================
-- 6. FUNCTION: Join Squad via Invite Code
-- ============================================================

CREATE OR REPLACE FUNCTION public.join_squad(p_invite_code TEXT)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_squad_id UUID;
    v_max_members INTEGER;
    v_current_count INTEGER;
    v_user_id UUID;
    v_membership_id UUID;
BEGIN
    -- Get current user
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Find squad by invite code
    SELECT id, max_members INTO v_squad_id, v_max_members
    FROM public.squads
    WHERE invite_code = UPPER(p_invite_code);
    
    IF v_squad_id IS NULL THEN
        RAISE EXCEPTION 'Invalid invite code';
    END IF;

    -- Check if already a member
    IF EXISTS (
        SELECT 1 FROM public.squad_members
        WHERE squad_id = v_squad_id AND user_id = v_user_id
    ) THEN
        RAISE EXCEPTION 'Already a member of this squad';
    END IF;

    -- Check member count
    SELECT COUNT(*) INTO v_current_count
    FROM public.squad_members
    WHERE squad_id = v_squad_id;
    
    IF v_current_count >= v_max_members THEN
        RAISE EXCEPTION 'Squad is full (% members max)', v_max_members;
    END IF;

    -- Insert membership
    INSERT INTO public.squad_members (squad_id, user_id, role)
    VALUES (v_squad_id, v_user_id, 'member')
    RETURNING id INTO v_membership_id;

    RETURN v_squad_id;
END;
$$;

-- ============================================================
-- 7. FUNCTION: Kick Member (Owner Only)
-- ============================================================

CREATE OR REPLACE FUNCTION public.kick_member(p_squad_id UUID, p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_owner_id UUID;
    v_caller_id UUID;
BEGIN
    v_caller_id := auth.uid();
    IF v_caller_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Get squad owner
    SELECT owner_id INTO v_owner_id
    FROM public.squads
    WHERE id = p_squad_id;
    
    IF v_owner_id IS NULL THEN
        RAISE EXCEPTION 'Squad not found';
    END IF;

    -- Only owner can kick
    IF v_caller_id != v_owner_id THEN
        RAISE EXCEPTION 'Only squad owner can kick members';
    END IF;

    -- Cannot kick self (owner)
    IF p_user_id = v_owner_id THEN
        RAISE EXCEPTION 'Owner cannot be kicked';
    END IF;

    -- Remove member
    DELETE FROM public.squad_members
    WHERE squad_id = p_squad_id AND user_id = p_user_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'User is not a member of this squad';
    END IF;

    RETURN TRUE;
END;
$$;

-- ============================================================
-- 8. FUNCTION: Regenerate Invite Code (Owner Only)
-- ============================================================

CREATE OR REPLACE FUNCTION public.regenerate_invite_code(p_squad_id UUID)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_owner_id UUID;
    v_caller_id UUID;
    v_new_code TEXT;
BEGIN
    v_caller_id := auth.uid();
    IF v_caller_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Get squad owner
    SELECT owner_id INTO v_owner_id
    FROM public.squads
    WHERE id = p_squad_id;
    
    IF v_owner_id IS NULL THEN
        RAISE EXCEPTION 'Squad not found';
    END IF;

    -- Only owner can regenerate
    IF v_caller_id != v_owner_id THEN
        RAISE EXCEPTION 'Only squad owner can regenerate invite code';
    END IF;

    -- Generate new code
    v_new_code := public.generate_invite_code();
    
    -- Update squad
    UPDATE public.squads
    SET invite_code = v_new_code
    WHERE id = p_squad_id;

    RETURN v_new_code;
END;
$$;

-- ============================================================
-- 9. TRIGGER: Auto-add Owner as First Member
-- ============================================================

CREATE OR REPLACE FUNCTION public.handle_new_squad()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    INSERT INTO public.squad_members (squad_id, user_id, role)
    VALUES (NEW.id, NEW.owner_id, 'owner');
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_squad_created
    AFTER INSERT ON public.squads
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_squad();

-- ============================================================
-- END OF MIGRATION
-- ============================================================
