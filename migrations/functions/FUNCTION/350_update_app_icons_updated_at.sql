CREATE FUNCTION public.update_app_icons_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_approval_permissions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

