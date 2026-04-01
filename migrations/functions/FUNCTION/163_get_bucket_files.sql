CREATE FUNCTION public.get_bucket_files(p_bucket_id text) RETURNS TABLE(file_name text, full_path text, file_size bigint, created_at timestamp with time zone, mime_type text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    o.name::text AS file_name,
    o.name::text AS full_path,
    COALESCE((o.metadata->>'size')::bigint, 0) AS file_size,
    o.created_at,
    COALESCE(o.metadata->>'mimetype', o.metadata->>'mimeType', '') AS mime_type
  FROM storage.objects o
  WHERE o.bucket_id = p_bucket_id
  ORDER BY o.name;
$$;


--
-- Name: get_campaign_statistics(uuid); Type: FUNCTION; Schema: public; Owner: -
--

