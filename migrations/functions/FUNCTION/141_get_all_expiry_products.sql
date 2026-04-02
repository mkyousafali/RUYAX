CREATE FUNCTION public.get_all_expiry_products() RETURNS TABLE(branch_id integer, barcode character varying, product_name_en character varying, product_name_ar character varying, expiry_date date, days_left integer, managed_by jsonb)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    (entry->>'branch_id')::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    (entry->>'expiry_date')::date AS expiry_date,
    ((entry->>'expiry_date')::date - CURRENT_DATE) AS days_left,
    p.managed_by
  FROM erp_synced_products p,
    jsonb_array_elements(p.expiry_dates) AS entry
  WHERE jsonb_array_length(p.expiry_dates) > 0
    AND (p.expiry_hidden IS NOT TRUE)
    AND (entry->>'expiry_date') IS NOT NULL
    AND (entry->>'branch_id') IS NOT NULL
  ORDER BY ((entry->>'expiry_date')::date - CURRENT_DATE) ASC, p.barcode;
$$;


--
-- Name: get_all_expiry_products(integer, integer, text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

