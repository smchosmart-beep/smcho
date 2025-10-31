-- Fix security warning: Add search_path to function
DROP FUNCTION IF EXISTS assign_seat_with_lock(uuid, text, integer, integer);

CREATE OR REPLACE FUNCTION assign_seat_with_lock(
  p_attendee_id uuid,
  p_seat_number text,
  p_attendee_count integer,
  p_current_version integer
)
RETURNS json AS $$
DECLARE
  v_result json;
  v_current_version integer;
BEGIN
  -- Lock the attendee row (NOWAIT to fail immediately if locked)
  SELECT version INTO v_current_version
  FROM attendees 
  WHERE id = p_attendee_id 
  FOR UPDATE NOWAIT;
  
  -- Check version match
  IF v_current_version != p_current_version THEN
    RAISE EXCEPTION 'version_conflict';
  END IF;
  
  -- Update with version increment
  UPDATE attendees
  SET 
    seat_number = p_seat_number,
    attendee_count = p_attendee_count,
    version = p_current_version + 1,
    updated_at = now()
  WHERE id = p_attendee_id
  RETURNING json_build_object(
    'id', id,
    'name', name,
    'phone', phone,
    'seat_number', seat_number,
    'attendee_count', attendee_count,
    'version', version,
    'session_id', session_id,
    'is_onsite_registration', is_onsite_registration,
    'created_at', created_at,
    'updated_at', updated_at
  ) INTO v_result;
  
  RETURN v_result;
EXCEPTION
  WHEN lock_not_available THEN
    RAISE EXCEPTION 'lock_not_available';
  WHEN others THEN
    RAISE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;