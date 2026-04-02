CREATE FUNCTION public.get_system_expiry_dates(barcode_list text[], branch_id_param integer) RETURNS TABLE(barcode text, expiry_date_formatted text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT 
    esp.barcode,
    COALESCE(
      (SELECT TO_CHAR((e->>'expiry_date')::date, 'DD-MM-YYYY')
       FROM jsonb_array_elements(esp.expiry_dates) as e
       WHERE (e->>'branch_id')::integer = branch_id_param
       LIMIT 1),
      '├óΓé¼ΓÇ¥'
    ) as expiry_date_formatted
  FROM erp_synced_products esp
  WHERE esp.barcode = ANY(barcode_list)
  ORDER BY esp.barcode;
$$;


--
-- Name: get_table_schemas(); Type: FUNCTION; Schema: public; Owner: -
--

