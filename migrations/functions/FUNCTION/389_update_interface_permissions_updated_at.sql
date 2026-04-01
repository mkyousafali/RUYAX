CREATE FUNCTION public.update_interface_permissions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_issue_types_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

