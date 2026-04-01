CREATE FUNCTION public.import_sync_batch(p_table_name text, p_data jsonb) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE 
    v_count integer := 0;
    v_allowed_tables text[] := ARRAY[
        'branches', 'users', 'user_sessions', 'user_device_sessions',
        'button_permissions', 'sidebar_buttons', 'button_main_sections', 'button_sub_sections',
        'interface_permissions', 'user_favorite_buttons',
        'erp_synced_products', 'product_categories', 'products', 'product_units',
        'offers', 'offer_products', 'offer_names', 'offer_bundles', 'offer_cart_tiers',
        'bogo_offer_rules', 'flyer_offers', 'flyer_offer_products',
        'customers', 'privilege_cards_master', 'privilege_cards_branch',
        'desktop_themes', 'user_theme_assignments',
        'erp_connections', 'erp_sync_logs'
    ];
BEGIN
    IF NOT (p_table_name = ANY(v_allowed_tables)) THEN
        RAISE EXCEPTION 'Table % is not allowed for sync import', p_table_name;
    END IF;

    IF p_data IS NULL OR jsonb_array_length(p_data) = 0 THEN 
        RETURN 0; 
    END IF;

    -- Disable FK constraint triggers
    PERFORM set_config('session_replication_role', 'replica', true);
    
    -- Insert with OVERRIDING SYSTEM VALUE to handle GENERATED ALWAYS identity columns
    EXECUTE format(
        'INSERT INTO %I OVERRIDING SYSTEM VALUE SELECT * FROM jsonb_populate_recordset(null::%I, $1)',
        p_table_name, p_table_name
    ) USING p_data;
    
    GET DIAGNOSTICS v_count = ROW_COUNT;
    
    -- Re-enable
    PERFORM set_config('session_replication_role', 'origin', true);
    
    RETURN v_count;
EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('session_replication_role', 'origin', true);
    RAISE;
END;
$_$;


--
-- Name: increment_ai_token_usage(uuid, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

