CREATE FUNCTION public.get_storage_buckets_info() RETURNS TABLE(bucket_id text, bucket_name text, is_public boolean, created_at timestamp with time zone, updated_at timestamp with time zone, file_size_limit bigint, allowed_mime_types text[], file_count bigint, total_size bigint)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public', 'storage'
    AS $$
  SELECT 
    b.id::text AS bucket_id,
    b.name::text AS bucket_name,
    b.public AS is_public,
    b.created_at,
    b.updated_at,
    b.file_size_limit,
    b.allowed_mime_types,
    COALESCE(stats.file_count, 0) AS file_count,
    COALESCE(stats.total_size, 0) AS total_size
  FROM storage.buckets b
  LEFT JOIN (
    SELECT 
      bucket_id,
      COUNT(*) AS file_count,
      SUM(COALESCE((metadata->>'size')::bigint, 0)) AS total_size
    FROM storage.objects
    GROUP BY bucket_id
  ) stats ON stats.bucket_id = b.id
  ORDER BY total_size DESC NULLS LAST;
$$;


--
-- Name: get_storage_stats(); Type: FUNCTION; Schema: public; Owner: -
--

