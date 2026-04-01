CREATE FUNCTION public.create_default_interface_permissions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public.interface_permissions (user_id, updated_by)
    VALUES (NEW.id, NEW.id)
    ON CONFLICT (user_id) DO NOTHING;
    RETURN NEW;
END;
$$;


--
-- Name: create_notification_recipients(); Type: FUNCTION; Schema: public; Owner: -
--

