CREATE FUNCTION public.get_expense_category_stats() RETURNS TABLE(total_parent_categories integer, enabled_parent_categories integer, disabled_parent_categories integer, total_sub_categories integer, enabled_sub_categories integer, disabled_sub_categories integer, vat_applicable_categories integer, vat_not_applicable_categories integer, both_vat_categories integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*)::INT FROM expense_parent_categories) as total_parent_categories,
        (SELECT COUNT(*)::INT FROM expense_parent_categories WHERE is_enabled = true) as enabled_parent_categories,
        (SELECT COUNT(*)::INT FROM expense_parent_categories WHERE is_enabled = false) as disabled_parent_categories,
        COUNT(*)::INT as total_sub_categories,
        COUNT(*) FILTER (WHERE is_enabled = true)::INT as enabled_sub_categories,
        COUNT(*) FILTER (WHERE is_enabled = false)::INT as disabled_sub_categories,
        COUNT(*) FILTER (WHERE vat_applicable = true AND vat_not_applicable = false)::INT as vat_applicable_categories,
        COUNT(*) FILTER (WHERE vat_applicable = false AND vat_not_applicable = true)::INT as vat_not_applicable_categories,
        COUNT(*) FILTER (WHERE vat_applicable = true AND vat_not_applicable = true)::INT as both_vat_categories
    FROM expense_categories;
END;
$$;


--
-- Name: get_expiring_products_count(text); Type: FUNCTION; Schema: public; Owner: -
--

