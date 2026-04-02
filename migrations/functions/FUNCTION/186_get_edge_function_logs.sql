CREATE FUNCTION public.get_edge_function_logs(p_limit integer DEFAULT 100) RETURNS TABLE(runid bigint, jobname text, status text, return_message text, start_time timestamp with time zone, end_time timestamp with time zone, duration_ms double precision)
    LANGUAGE sql SECURITY DEFINER
    AS $$
  SELECT 
    d.runid,
    j.jobname,
    d.status,
    d.return_message,
    d.start_time,
    d.end_time,
    EXTRACT(EPOCH FROM (d.end_time - d.start_time)) * 1000 as duration_ms
  FROM cron.job_run_details d
  JOIN cron.job j ON j.jobid = d.jobid
  ORDER BY d.start_time DESC
  LIMIT p_limit;
$$;


--
-- Name: get_edge_functions(); Type: FUNCTION; Schema: public; Owner: -
--

