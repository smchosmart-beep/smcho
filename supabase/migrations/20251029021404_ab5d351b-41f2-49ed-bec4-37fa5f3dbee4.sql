-- Ensure pgcrypto extension exists for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Drop foreign key constraints to auth.users from profiles table
ALTER TABLE public.profiles 
  DROP CONSTRAINT IF EXISTS profiles_user_id_fkey;

-- Drop foreign key constraints to auth.users from user_roles table
ALTER TABLE public.user_roles 
  DROP CONSTRAINT IF EXISTS user_roles_user_id_fkey;