-- Ensure pgcrypto exists for gen_random_uuid() usage
CREATE EXTENSION IF NOT EXISTS pgcrypto;