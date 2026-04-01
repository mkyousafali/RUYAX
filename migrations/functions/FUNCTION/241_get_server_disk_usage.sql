CREATE FUNCTION public.get_server_disk_usage() RETURNS TABLE(filesystem text, total_size text, used_size text, available_size text, use_percent integer, mount_point text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
BEGIN
  CREATE TEMP TABLE IF NOT EXISTS _disk_raw (line text) ON COMMIT DROP;
  TRUNCATE _disk_raw;

  COPY _disk_raw (line) FROM PROGRAM
    'df -h / | tail -n 1 | awk ''{print $1"|"$2"|"$3"|"$4"|"$5"|"$6}''';

  RETURN QUERY
  SELECT
    split_part(line, '|', 1),
    split_part(line, '|', 2),
    split_part(line, '|', 3),
    split_part(line, '|', 4),
    REPLACE(split_part(line, '|', 5), '%', '')::int,
    split_part(line, '|', 6)
  FROM _disk_raw
  LIMIT 1;
END;
$_$;


--
-- Name: get_stock_requests_with_details(); Type: FUNCTION; Schema: public; Owner: -
--

