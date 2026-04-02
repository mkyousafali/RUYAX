CREATE FUNCTION public.get_file_extension(filename text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN lower(split_part(filename, '.', array_length(string_to_array(filename, '.'), 1)));
END;
$$;


--
-- Name: get_flyer_generator_data(uuid); Type: FUNCTION; Schema: public; Owner: -
--

