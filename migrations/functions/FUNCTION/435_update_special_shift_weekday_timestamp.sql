CREATE FUNCTION public.update_special_shift_weekday_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_stock_request_status(uuid, character varying); Type: FUNCTION; Schema: public; Owner: -
--

