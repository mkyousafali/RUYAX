CREATE FUNCTION public.update_official_holidays_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


--
-- Name: update_order_status(uuid, character varying, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

