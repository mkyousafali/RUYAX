CREATE FUNCTION public.export_table_for_sync(p_table_name text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_result jsonb;
    v_allowed_tables text[] := ARRAY[
        'branches', 'users', 'user_sessions', 'user_device_sessions',
        'button_permissions', 'sidebar_buttons', 'button_main_sections', 'button_sub_sections',
        'interface_permissions', 'user_favorite_buttons',
        'erp_synced_products', 'product_categories', 'products', 'product_units',
        'offers', 'offer_products', 'offer_names', 'offer_bundles', 'offer_cart_tiers',
        'bogo_offer_rules', 'flyer_offers', 'flyer_offer_products',
        'customers', 'privilege_cards_master', 'privilege_cards_branch',
        'desktop_themes', 'user_theme_assignments',
        'erp_connections', 'erp_sync_logs',
        'coupon_campaigns', 'coupon_products', 'coupon_eligible_customers',
        'delivery_fee_tiers', 'delivery_service_settings',
        'social_links', 'ai_chat_guide',
        'nationalities', 'vendors',
        'expense_parent_categories', 'expense_sub_categories',
        'notification_attachments', 'notifications', 'notification_recipients',
        'push_subscriptions'
    ];
BEGIN
    -- Security: Only allow whitelisted tables
    IF NOT (p_table_name = ANY(v_allowed_tables)) THEN
        RAISE EXCEPTION 'Table % is not allowed for sync', p_table_name;
    END IF;

    EXECUTE format('SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), ''[]''::jsonb) FROM %I t', p_table_name)
    INTO v_result;

    RETURN v_result;
END;
$$;


--
-- Name: format_file_size(bigint); Type: FUNCTION; Schema: public; Owner: -
--

