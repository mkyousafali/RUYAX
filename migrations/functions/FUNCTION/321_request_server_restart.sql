CREATE FUNCTION public.request_server_restart() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- Write a trigger file to the shared volume (PG data dir)
  -- Host path: /opt/supabase/supabase/docker/volumes/db/data/restart_trigger
  -- Container path: /var/lib/postgresql/data/restart_trigger
  COPY (SELECT 'restart_requested_at_' || now()::text) 
    TO '/var/lib/postgresql/data/restart_trigger';
  
  RETURN 'Restart requested successfully. Services will restart within 30 seconds.';
END;
$$;


--
-- Name: reschedule_visit(uuid, date); Type: FUNCTION; Schema: public; Owner: -
--

