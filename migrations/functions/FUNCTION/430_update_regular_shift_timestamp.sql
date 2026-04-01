CREATE FUNCTION public.update_regular_shift_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_requisition_balance(); Type: FUNCTION; Schema: public; Owner: -
--

