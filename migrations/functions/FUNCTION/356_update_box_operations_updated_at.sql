CREATE FUNCTION public.update_box_operations_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_branch_default_positions_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

