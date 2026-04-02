CREATE FUNCTION public.clear_sync_tables(p_tables text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_table text;
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
    -- Disable FK constraint triggers
    PERFORM set_config('session_replication_role', 'replica', true);
    
    FOREACH v_table IN ARRAY p_tables LOOP
        IF v_table = ANY(v_allowed_tables) THEN
            EXECUTE format('DELETE FROM %I', v_table);
        END IF;
    END LOOP;
    
    -- Re-enable
    PERFORM set_config('session_replication_role', 'origin', true);
EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('session_replication_role', 'origin', true);
    RAISE;
END;
$$;


--
-- Name: complete_receiving_task(uuid, uuid, character varying, text, boolean, boolean, boolean, text, text); Type: FUNCTION; Schema: public; Owner: -
--

