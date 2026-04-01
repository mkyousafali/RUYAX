CREATE FUNCTION public.update_branch_delivery_receivers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_branch_sync_status(bigint, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

