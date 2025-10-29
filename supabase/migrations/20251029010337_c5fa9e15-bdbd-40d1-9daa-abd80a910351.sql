-- Add INSERT policy for profiles table
-- This allows authenticated users to create their own profile
CREATE POLICY "Users can insert their own profile"
  ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Note: The existing trigger on auth.users (on_auth_user_created) may cause
-- issues during project Remix. This policy ensures profiles can be created
-- even if the trigger is not available.