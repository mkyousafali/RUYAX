CREATE FUNCTION public.format_file_size(size_bytes bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    size_kb numeric := size_bytes / 1024.0;
    size_mb numeric := size_kb / 1024.0;
    size_gb numeric := size_mb / 1024.0;
BEGIN
    IF size_gb >= 1 THEN
        RETURN round(size_gb, 2) || ' GB';
    ELSIF size_mb >= 1 THEN
        RETURN round(size_mb, 2) || ' MB';
    ELSIF size_kb >= 1 THEN
        RETURN round(size_kb, 2) || ' KB';
    ELSE
        RETURN size_bytes || ' Bytes';
    END IF;
END;
$$;


--
-- Name: generate_branch_id(); Type: FUNCTION; Schema: public; Owner: -
--

