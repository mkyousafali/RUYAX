CREATE FUNCTION public.update_offers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_official_holidays_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

