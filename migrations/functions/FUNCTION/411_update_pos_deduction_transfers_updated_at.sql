CREATE FUNCTION public.update_pos_deduction_transfers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_positions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

