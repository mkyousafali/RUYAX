CREATE FUNCTION public.update_early_leave_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


--
-- Name: update_employee_positions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

