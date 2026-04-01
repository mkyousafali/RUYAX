CREATE FUNCTION public.update_non_approved_scheduler_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: update_notification_attachments_flag(); Type: FUNCTION; Schema: public; Owner: -
--

