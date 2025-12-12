-- ============================================================
-- 004_fix_squad_members_rls.sql
-- Fix infinite recursion in squad_members SELECT policy
-- ============================================================

-- Drop the problematic policy
DROP POLICY IF EXISTS "Members can view squad members" ON public.squad_members;

-- Create a helper function to check squad membership without recursion
-- This uses a SECURITY DEFINER function to bypass RLS
CREATE OR REPLACE FUNCTION public.is_squad_member(p_squad_id UUID, p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.squad_members
        WHERE squad_id = p_squad_id AND user_id = p_user_id
    );
$$;

-- Recreate the policy using a simpler approach:
-- Option 1: Allow users to see memberships for squads they own OR their own memberships
-- This avoids recursion by not querying squad_members inside the policy

CREATE POLICY "Members can view squad members"
    ON public.squad_members
    FOR SELECT
    TO authenticated
    USING (
        -- User can see their own membership records
        user_id = auth.uid()
        OR
        -- User can see members of squads they own
        squad_id IN (
            SELECT id FROM public.squads WHERE owner_id = auth.uid()
        )
        OR
        -- User can see members of squads they belong to
        -- Use the SECURITY DEFINER function to avoid recursion
        public.is_squad_member(squad_id, auth.uid())
    );

-- ============================================================
-- END OF FIX
-- ============================================================
