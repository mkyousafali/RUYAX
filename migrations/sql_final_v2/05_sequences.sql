BEGIN
    -- ═══ SEQUENCES ═══
    -- Export all sequences in public schema (must come before tables that reference them)
    FOR r IN
        SELECT c.relname AS seq_name,
               s.seqtypid,
               pg_catalog.format_type(s.seqtypid, NULL) AS seq_type,
               s.seqstart, s.seqincrement, s.seqmin, s.seqmax, s.seqcache, s.seqcycle
        FROM pg_class c
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_sequence s ON s.seqrelid = c.oid
        WHERE n.nspname = 'public'
          AND c.relkind = 'S' -- sequences
        ORDER BY c.relname
    LOOP
        v_sequences := v_sequences || format(
            'CREATE SEQUENCE IF NOT EXISTS public.%I AS %s INCREMENT BY %s MINVALUE %s MAXVALUE %s START WITH %s CACHE %s%s;

--

CREATE SEQUENCE IF NOT EXISTS public.ai_chat_guide_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.approval_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.approver_branch_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.approver_visibility_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.asset_main_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.asset_sub_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.bank_reconciliations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.bogo_offer_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.branches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.break_reasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.denomination_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.desktop_themes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.employee_checklist_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.erp_sync_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.erp_synced_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.expense_parent_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.expense_requisitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.expense_scheduler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.expense_sub_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.frontend_builds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.hr_analysed_attendance_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.hr_checklist_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.hr_checklist_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.hr_checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.hr_insurance_company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.incident_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.mobile_themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.multi_shift_date_wise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.multi_shift_regular_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.multi_shift_weekday_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.non_approved_payment_scheduler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.offer_bundles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.offer_cart_tiers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.offer_usage_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.offers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.processed_fingerprint_transactions_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.purchase_vouchers_book_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.recurring_schedule_check_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.shelf_paper_fonts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.system_api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.user_mobile_theme_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.user_theme_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--

CREATE SEQUENCE IF NOT EXISTS public.warning_ref_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;