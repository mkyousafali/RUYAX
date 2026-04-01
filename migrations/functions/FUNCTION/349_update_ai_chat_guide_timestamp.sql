CREATE FUNCTION public.update_ai_chat_guide_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_app_icons_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

