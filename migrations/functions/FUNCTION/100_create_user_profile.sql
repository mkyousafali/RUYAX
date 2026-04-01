CREATE FUNCTION public.create_user_profile() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO user_profiles (user_id)
    VALUES (NEW.id);
    RETURN NEW;
END;
$$;


--
-- Name: create_variation_group(text, text[], text, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

