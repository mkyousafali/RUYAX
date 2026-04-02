CREATE FUNCTION public.update_warning_violation_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: upsert_app_icon(text, text, text, text, text, bigint, text); Type: FUNCTION; Schema: public; Owner: -
--

