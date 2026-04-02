ALTER TYPE public.audit_action_enum OWNER TO supabase_admin;

ALTER TYPE public.document_category_enum OWNER TO supabase_admin;

ALTER TYPE public.document_type_enum OWNER TO supabase_admin;

ALTER TYPE public.employee_status_enum OWNER TO supabase_admin;

ALTER TYPE public.fine_payment_status_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_priority_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_queue_status_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_status_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_target_type_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_type_enum OWNER TO supabase_admin;

ALTER TYPE public.payment_method_type OWNER TO supabase_admin;

ALTER TYPE public.pos_deduction_status OWNER TO supabase_admin;

ALTER TYPE public.push_subscription_status_enum OWNER TO supabase_admin;

ALTER TYPE public.resolution_status OWNER TO supabase_admin;

ALTER TYPE public.role_type_enum OWNER TO supabase_admin;

ALTER TYPE public.session_status_enum OWNER TO supabase_admin;

ALTER TYPE public.task_priority_enum OWNER TO supabase_admin;

ALTER TYPE public.task_status_enum OWNER TO supabase_admin;

ALTER TYPE public.user_role OWNER TO supabase_admin;

ALTER TYPE public.user_status_enum OWNER TO supabase_admin;

ALTER TYPE public.user_type_enum OWNER TO supabase_admin;

ALTER TYPE public.vendor_status_enum OWNER TO supabase_admin;

ALTER TYPE public.warning_status_enum OWNER TO supabase_admin;

v_sequences := v_sequences || format(
            'GRANT USAGE, SELECT ON SEQUENCE public.%I TO authenticated, anon, service_role;

--

ALTER SEQUENCE public.ai_chat_guide_id_seq OWNED BY public.ai_chat_guide.id;

--

ALTER SEQUENCE public.approval_permissions_id_seq OWNED BY public.approval_permissions.id;

--

ALTER SEQUENCE public.approver_branch_access_id_seq OWNED BY public.approver_branch_access.id;

--

ALTER SEQUENCE public.approver_visibility_config_id_seq OWNED BY public.approver_visibility_config.id;

--

ALTER SEQUENCE public.asset_main_categories_id_seq OWNED BY public.asset_main_categories.id;

--

ALTER SEQUENCE public.asset_sub_categories_id_seq OWNED BY public.asset_sub_categories.id;

--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;

--

ALTER SEQUENCE public.bank_reconciliations_id_seq OWNED BY public.bank_reconciliations.id;

--

ALTER SEQUENCE public.bogo_offer_rules_id_seq OWNED BY public.bogo_offer_rules.id;

--

ALTER TABLE public.branch_sync_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.branch_sync_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--

ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;

--

ALTER SEQUENCE public.break_reasons_id_seq OWNED BY public.break_reasons.id;

--

ALTER TABLE public.button_main_sections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_main_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--

ALTER TABLE public.button_permissions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--

ALTER TABLE public.button_sub_sections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_sub_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--

ALTER SEQUENCE public.denomination_types_id_seq OWNED BY public.denomination_types.id;

--

ALTER SEQUENCE public.desktop_themes_id_seq OWNED BY public.desktop_themes.id;

--

ALTER SEQUENCE public.employee_checklist_assignments_id_seq OWNED BY public.employee_checklist_assignments.id;

--

ALTER SEQUENCE public.erp_sync_logs_id_seq OWNED BY public.erp_sync_logs.id;

--

ALTER SEQUENCE public.erp_synced_products_id_seq OWNED BY public.erp_synced_products.id;

--

ALTER SEQUENCE public.expense_parent_categories_id_seq OWNED BY public.expense_parent_categories.id;

--

ALTER SEQUENCE public.expense_requisitions_id_seq OWNED BY public.expense_requisitions.id;

--

ALTER SEQUENCE public.expense_scheduler_id_seq OWNED BY public.expense_scheduler.id;

--

ALTER SEQUENCE public.expense_sub_categories_id_seq OWNED BY public.expense_sub_categories.id;

--

ALTER SEQUENCE public.frontend_builds_id_seq OWNED BY public.frontend_builds.id;

--

ALTER SEQUENCE public.hr_analysed_attendance_data_id_seq OWNED BY public.hr_analysed_attendance_data.id;

--

ALTER SEQUENCE public.mobile_themes_id_seq OWNED BY public.mobile_themes.id;

--

ALTER SEQUENCE public.multi_shift_date_wise_id_seq OWNED BY public.multi_shift_date_wise.id;

--

ALTER SEQUENCE public.multi_shift_regular_id_seq OWNED BY public.multi_shift_regular.id;

--

ALTER SEQUENCE public.multi_shift_weekday_id_seq OWNED BY public.multi_shift_weekday.id;

--

ALTER SEQUENCE public.non_approved_payment_scheduler_id_seq OWNED BY public.non_approved_payment_scheduler.id;

--

ALTER SEQUENCE public.offer_bundles_id_seq OWNED BY public.offer_bundles.id;

--

ALTER SEQUENCE public.offer_cart_tiers_id_seq OWNED BY public.offer_cart_tiers.id;

--

ALTER SEQUENCE public.offer_usage_logs_id_seq OWNED BY public.offer_usage_logs.id;

--

ALTER SEQUENCE public.offers_id_seq OWNED BY public.offers.id;

--

ALTER SEQUENCE public.recurring_schedule_check_log_id_seq OWNED BY public.recurring_schedule_check_log.id;

--

ALTER TABLE public.sidebar_buttons ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sidebar_buttons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--

ALTER SEQUENCE public.system_api_keys_id_seq OWNED BY public.system_api_keys.id;

--

ALTER SEQUENCE public.user_mobile_theme_assignments_id_seq OWNED BY public.user_mobile_theme_assignments.id;

--

ALTER SEQUENCE public.user_theme_assignments_id_seq OWNED BY public.user_theme_assignments.id;

--

ALTER TABLE public.access_code_otp ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.ai_chat_guide ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.app_icons ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.approval_permissions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.approver_branch_access ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.approver_visibility_config ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.asset_main_categories ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.asset_sub_categories ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.assets ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.bank_reconciliations ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.biometric_connections ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.bogo_offer_rules ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.box_operations ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.branch_default_delivery_receivers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.branch_default_positions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.branch_sync_config ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.break_reasons ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.break_register ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.break_security_seed ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.button_main_sections ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.button_permissions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.button_sub_sections ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.coupon_campaigns ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.coupon_claims ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.coupon_eligible_customers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.coupon_products ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.customer_access_code_history ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.customer_app_media ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.customer_product_requests ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.customer_recovery_requests ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.day_off ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.day_off_reasons ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.day_off_weekday ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.default_incident_users ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.deleted_bundle_offers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.delivery_fee_tiers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.delivery_service_settings ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.denomination_audit_log ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.denomination_records ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.denomination_transactions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.denomination_types ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.desktop_themes ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.employee_checklist_assignments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.employee_fine_payments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.employee_official_holidays ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.erp_connections ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.erp_daily_sales ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.erp_sync_logs ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.erp_synced_products ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.expense_parent_categories ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.expense_requisitions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.expense_scheduler ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.expense_sub_categories ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.flyer_offer_products ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.flyer_offers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.flyer_templates ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.frontend_builds ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_analysed_attendance_data ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_basic_salary ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_checklist_operations ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_checklist_questions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_checklists ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_departments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_employee_master ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_employees ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_fingerprint_transactions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_insurance_companies ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_levels ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_position_assignments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_position_reporting_template ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.hr_positions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.incident_actions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.incident_types ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.incidents ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.interface_permissions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.lease_rent_lease_parties ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.lease_rent_payment_entries ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.lease_rent_payments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.lease_rent_properties ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.lease_rent_property_spaces ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.lease_rent_rent_parties ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.lease_rent_special_changes ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.mobile_themes ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.multi_shift_date_wise ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.multi_shift_regular ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.multi_shift_weekday ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.nationalities ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.near_expiry_reports ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.non_approved_payment_scheduler ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.notification_attachments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.notification_read_states ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.notification_recipients ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.offer_bundles ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.offer_cart_tiers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.offer_names ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.offer_products ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.offer_usage_logs ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.offers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.official_holidays ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.order_audit_logs ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.overtime_registrations ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.pos_deduction_transfers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.privilege_cards_branch ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.privilege_cards_master ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.processed_fingerprint_transactions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.product_request_bt ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.product_request_po ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.product_request_st ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.product_units ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.purchase_voucher_issue_types ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.purchase_voucher_items ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.purchase_vouchers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.push_subscriptions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.quick_task_assignments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.quick_task_comments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.quick_task_completions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.quick_task_files ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.quick_task_user_preferences ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.quick_tasks ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.receiving_records ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.receiving_task_templates ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.receiving_tasks ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.receiving_user_defaults ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.recurring_assignment_schedules ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.recurring_schedule_check_log ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.regular_shift ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.requesters ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.security_code_scroll_texts ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.shelf_paper_fonts ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.shelf_paper_templates ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.sidebar_buttons ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.social_links ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.special_shift_date_wise ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.special_shift_weekday ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.system_api_keys ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.task_assignments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.task_completions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.task_images ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.task_reminder_logs ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.user_audit_logs ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.user_device_sessions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.user_favorite_buttons ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.user_mobile_theme_assignments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.user_password_history ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.user_sessions ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.user_theme_assignments ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.user_voice_preferences ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.variation_audit_log ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.vendor_payment_schedule ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.view_offer ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_accounts ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_ai_bot_config ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_auto_reply_triggers ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_bot_flows ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_broadcast_recipients ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_broadcasts ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_catalog_orders ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_catalog_products ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_catalogs ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_contact_group_members ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_contact_groups ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_conversations ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_messages ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_settings ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.wa_templates ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.warning_main_category ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.warning_sub_category ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.warning_violation ENABLE ROW LEVEL SECURITY;

--

ALTER TABLE public.whatsapp_message_log ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA public TO anon;

GRANT USAGE ON SCHEMA public TO authenticated;

GRANT USAGE ON SCHEMA public TO service_role;

GRANT USAGE ON SCHEMA public TO replication_user;

--

GRANT ALL ON TYPE public.resolution_status TO authenticated;

GRANT ALL ON TYPE public.resolution_status TO service_role;

GRANT ALL ON TYPE public.resolution_status TO anon;

--

GRANT ALL ON FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.acknowledge_warning(warning_id_param uuid, acknowledged_by_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.acknowledge_warning(warning_id_param uuid, acknowledged_by_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.acknowledge_warning(warning_id_param uuid, acknowledged_by_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.adjust_product_stock_on_order_insert() TO authenticated;

GRANT ALL ON FUNCTION public.adjust_product_stock_on_order_insert() TO service_role;

GRANT ALL ON FUNCTION public.adjust_product_stock_on_order_insert() TO anon;

--

GRANT ALL ON FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text, p_approved_by uuid) TO authenticated;

GRANT ALL ON FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text, p_approved_by uuid) TO anon;

GRANT ALL ON FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text, p_approved_by uuid) TO service_role;

--

GRANT ALL ON FUNCTION public.approve_customer_registration(p_customer_id uuid, p_approved_by uuid, p_notes text) TO authenticated;

GRANT ALL ON FUNCTION public.approve_customer_registration(p_customer_id uuid, p_approved_by uuid, p_notes text) TO service_role;

GRANT ALL ON FUNCTION public.approve_customer_registration(p_customer_id uuid, p_approved_by uuid, p_notes text) TO anon;

--

GRANT ALL ON FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) TO authenticated;

GRANT ALL ON FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) TO service_role;

GRANT ALL ON FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) TO anon;

--

GRANT ALL ON FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) TO authenticated;

GRANT ALL ON FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) TO service_role;

GRANT ALL ON FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) TO anon;

--

GRANT ALL ON FUNCTION public.assign_task_simple(task_id_param uuid, assigned_to_user_id_param uuid, assigned_by_param text, assigned_by_name_param text, deadline_datetime_param timestamp with time zone, priority_param text, notes_param text) TO authenticated;

GRANT ALL ON FUNCTION public.assign_task_simple(task_id_param uuid, assigned_to_user_id_param uuid, assigned_by_param text, assigned_by_name_param text, deadline_datetime_param timestamp with time zone, priority_param text, notes_param text) TO service_role;

GRANT ALL ON FUNCTION public.assign_task_simple(task_id_param uuid, assigned_to_user_id_param uuid, assigned_by_param text, assigned_by_name_param text, deadline_datetime_param timestamp with time zone, priority_param text, notes_param text) TO anon;

--

GRANT ALL ON FUNCTION public.authenticate_customer_access_code(p_access_code text) TO authenticated;

GRANT ALL ON FUNCTION public.authenticate_customer_access_code(p_access_code text) TO anon;

--

GRANT ALL ON FUNCTION public.auto_create_payment_schedule() TO authenticated;

GRANT ALL ON FUNCTION public.auto_create_payment_schedule() TO service_role;

GRANT ALL ON FUNCTION public.auto_create_payment_schedule() TO anon;

--

GRANT ALL ON FUNCTION public.bulk_import_customers(p_phone_numbers text[]) TO authenticated;

GRANT ALL ON FUNCTION public.bulk_import_customers(p_phone_numbers text[]) TO anon;

GRANT ALL ON FUNCTION public.bulk_import_customers(p_phone_numbers text[]) TO service_role;

--

GRANT ALL ON FUNCTION public.bulk_toggle_customer_product(p_barcodes text[], p_value boolean) TO authenticated;

GRANT ALL ON FUNCTION public.bulk_toggle_customer_product(p_barcodes text[], p_value boolean) TO service_role;

--

GRANT ALL ON FUNCTION public.calculate_category_days() TO authenticated;

GRANT ALL ON FUNCTION public.calculate_category_days() TO service_role;

GRANT ALL ON FUNCTION public.calculate_category_days() TO anon;

--

GRANT ALL ON FUNCTION public.calculate_flyer_product_profit() TO authenticated;

GRANT ALL ON FUNCTION public.calculate_flyer_product_profit() TO service_role;

GRANT ALL ON FUNCTION public.calculate_flyer_product_profit() TO anon;

--

GRANT ALL ON FUNCTION public.calculate_next_visit_date(visit_type text, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date date, current_next_date date) TO authenticated;

GRANT ALL ON FUNCTION public.calculate_next_visit_date(visit_type text, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date date, current_next_date date) TO service_role;

GRANT ALL ON FUNCTION public.calculate_next_visit_date(visit_type text, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date date, current_next_date date) TO anon;

--

GRANT ALL ON FUNCTION public.calculate_profit() TO authenticated;

GRANT ALL ON FUNCTION public.calculate_profit() TO service_role;

GRANT ALL ON FUNCTION public.calculate_profit() TO anon;

--

GRANT ALL ON FUNCTION public.calculate_receiving_amounts() TO authenticated;

GRANT ALL ON FUNCTION public.calculate_receiving_amounts() TO service_role;

GRANT ALL ON FUNCTION public.calculate_receiving_amounts() TO anon;

--

GRANT ALL ON FUNCTION public.calculate_return_totals() TO authenticated;

GRANT ALL ON FUNCTION public.calculate_return_totals() TO service_role;

GRANT ALL ON FUNCTION public.calculate_return_totals() TO anon;

--

GRANT ALL ON FUNCTION public.calculate_schedule_details() TO authenticated;

GRANT ALL ON FUNCTION public.calculate_schedule_details() TO service_role;

GRANT ALL ON FUNCTION public.calculate_schedule_details() TO anon;

--

GRANT ALL ON FUNCTION public.calculate_working_hours() TO authenticated;

GRANT ALL ON FUNCTION public.calculate_working_hours() TO service_role;

GRANT ALL ON FUNCTION public.calculate_working_hours() TO anon;

--

GRANT ALL ON FUNCTION public.calculate_working_hours(check_in timestamp with time zone, check_out timestamp with time zone) TO authenticated;

GRANT ALL ON FUNCTION public.calculate_working_hours(check_in timestamp with time zone, check_out timestamp with time zone) TO service_role;

GRANT ALL ON FUNCTION public.calculate_working_hours(check_in timestamp with time zone, check_out timestamp with time zone) TO anon;

--

GRANT ALL ON FUNCTION public.calculate_working_hours(start_time time without time zone, end_time time without time zone, is_overnight_shift boolean) TO authenticated;

GRANT ALL ON FUNCTION public.calculate_working_hours(start_time time without time zone, end_time time without time zone, is_overnight_shift boolean) TO service_role;

GRANT ALL ON FUNCTION public.calculate_working_hours(start_time time without time zone, end_time time without time zone, is_overnight_shift boolean) TO anon;

--

GRANT ALL ON FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) TO authenticated;

GRANT ALL ON FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) TO service_role;

GRANT ALL ON FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) TO anon;

--

GRANT ALL ON FUNCTION public.check_accountant_dependency(receiving_record_id_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.check_accountant_dependency(receiving_record_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.check_accountant_dependency(receiving_record_id_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules() TO authenticated;

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules() TO service_role;

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules() TO anon;

--

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules_with_logging() TO authenticated;

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules_with_logging() TO service_role;

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules_with_logging() TO anon;

--

GRANT ALL ON FUNCTION public.check_erp_sync_status() TO authenticated;

GRANT ALL ON FUNCTION public.check_erp_sync_status() TO service_role;

GRANT ALL ON FUNCTION public.check_erp_sync_status() TO anon;

--

GRANT ALL ON FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.check_offer_eligibility(p_offer_id integer, p_customer_id uuid, p_cart_total numeric, p_cart_quantity integer) TO authenticated;

GRANT ALL ON FUNCTION public.check_offer_eligibility(p_offer_id integer, p_customer_id uuid, p_cart_total numeric, p_cart_quantity integer) TO service_role;

GRANT ALL ON FUNCTION public.check_offer_eligibility(p_offer_id integer, p_customer_id uuid, p_cart_total numeric, p_cart_quantity integer) TO anon;

--

GRANT ALL ON FUNCTION public.check_orphaned_variations() TO authenticated;

GRANT ALL ON FUNCTION public.check_orphaned_variations() TO service_role;

GRANT ALL ON FUNCTION public.check_orphaned_variations() TO anon;

--

GRANT ALL ON FUNCTION public.check_overdue_tasks_and_send_reminders() TO authenticated;

GRANT ALL ON FUNCTION public.check_overdue_tasks_and_send_reminders() TO service_role;

GRANT ALL ON FUNCTION public.check_overdue_tasks_and_send_reminders() TO anon;

--

GRANT ALL ON FUNCTION public.check_receiving_task_dependencies(receiving_record_id_param uuid, role_type_param text) TO authenticated;

GRANT ALL ON FUNCTION public.check_receiving_task_dependencies(receiving_record_id_param uuid, role_type_param text) TO service_role;

GRANT ALL ON FUNCTION public.check_receiving_task_dependencies(receiving_record_id_param uuid, role_type_param text) TO anon;

--

GRANT ALL ON FUNCTION public.check_task_completion_criteria(task_uuid uuid, task_finished_val boolean, photo_uploaded_val boolean, erp_reference_val boolean) TO authenticated;

GRANT ALL ON FUNCTION public.check_task_completion_criteria(task_uuid uuid, task_finished_val boolean, photo_uploaded_val boolean, erp_reference_val boolean) TO service_role;

GRANT ALL ON FUNCTION public.check_task_completion_criteria(task_uuid uuid, task_finished_val boolean, photo_uploaded_val boolean, erp_reference_val boolean) TO anon;

--

GRANT ALL ON FUNCTION public.check_user_permission(p_function_code text, p_permission text) TO authenticated;

GRANT ALL ON FUNCTION public.check_user_permission(p_function_code text, p_permission text) TO service_role;

GRANT ALL ON FUNCTION public.check_user_permission(p_function_code text, p_permission text) TO anon;

--

GRANT ALL ON FUNCTION public.check_visit_conflicts(branch_uuid uuid, visit_date_param date, visit_time_param time without time zone, duration_minutes integer, exclude_visit_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.check_visit_conflicts(branch_uuid uuid, visit_date_param date, visit_time_param time without time zone, duration_minutes integer, exclude_visit_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.check_visit_conflicts(branch_uuid uuid, visit_date_param date, visit_time_param time without time zone, duration_minutes integer, exclude_visit_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.claim_coupon(p_campaign_id uuid, p_mobile_number character varying, p_product_id uuid, p_branch_id bigint, p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.claim_coupon(p_campaign_id uuid, p_mobile_number character varying, p_product_id uuid, p_branch_id bigint, p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.claim_coupon(p_campaign_id uuid, p_mobile_number character varying, p_product_id uuid, p_branch_id bigint, p_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.cleanup_expired_otps() TO service_role;

--

GRANT ALL ON FUNCTION public.cleanup_expired_sessions() TO authenticated;

GRANT ALL ON FUNCTION public.cleanup_expired_sessions() TO service_role;

GRANT ALL ON FUNCTION public.cleanup_expired_sessions() TO anon;

--

GRANT ALL ON FUNCTION public.clear_analytics_logs() TO service_role;

--

GRANT ALL ON FUNCTION public.clear_main_document_columns() TO authenticated;

GRANT ALL ON FUNCTION public.clear_main_document_columns() TO service_role;

GRANT ALL ON FUNCTION public.clear_main_document_columns() TO anon;

--

GRANT ALL ON FUNCTION public.clear_sync_tables(p_tables text[]) TO authenticated;

GRANT ALL ON FUNCTION public.clear_sync_tables(p_tables text[]) TO anon;

GRANT ALL ON FUNCTION public.clear_sync_tables(p_tables text[]) TO service_role;

--

GRANT ALL ON FUNCTION public.complete_receiving_task(receiving_task_id_param uuid, user_id_param uuid, erp_reference_param character varying, original_bill_file_path_param text, has_erp_purchase_invoice boolean, has_pr_excel_file boolean, has_original_bill boolean, completion_photo_url_param text, completion_notes_param text) TO authenticated;

GRANT ALL ON FUNCTION public.complete_receiving_task(receiving_task_id_param uuid, user_id_param uuid, erp_reference_param character varying, original_bill_file_path_param text, has_erp_purchase_invoice boolean, has_pr_excel_file boolean, has_original_bill boolean, completion_photo_url_param text, completion_notes_param text) TO service_role;

GRANT ALL ON FUNCTION public.complete_receiving_task(receiving_task_id_param uuid, user_id_param uuid, erp_reference_param character varying, original_bill_file_path_param text, has_erp_purchase_invoice boolean, has_pr_excel_file boolean, has_original_bill boolean, completion_photo_url_param text, completion_notes_param text) TO anon;

--

GRANT ALL ON FUNCTION public.complete_receiving_task_fixed(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO authenticated;

GRANT ALL ON FUNCTION public.complete_receiving_task_fixed(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO service_role;

GRANT ALL ON FUNCTION public.complete_receiving_task_fixed(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO anon;

--

GRANT ALL ON FUNCTION public.complete_receiving_task_simple(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO authenticated;

GRANT ALL ON FUNCTION public.complete_receiving_task_simple(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO service_role;

GRANT ALL ON FUNCTION public.complete_receiving_task_simple(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO anon;

--

GRANT ALL ON FUNCTION public.complete_visit_and_update_next(visit_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.complete_visit_and_update_next(visit_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.complete_visit_and_update_next(visit_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.copy_completion_requirements_to_assignment() TO authenticated;

GRANT ALL ON FUNCTION public.copy_completion_requirements_to_assignment() TO service_role;

GRANT ALL ON FUNCTION public.copy_completion_requirements_to_assignment() TO anon;

--

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference() TO authenticated;

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference() TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference() TO anon;

--

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint) TO authenticated;

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint) TO anon;

--

GRANT ALL ON FUNCTION public.count_bills_without_original() TO authenticated;

GRANT ALL ON FUNCTION public.count_bills_without_original() TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_original() TO anon;

--

GRANT ALL ON FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint) TO authenticated;

GRANT ALL ON FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint) TO anon;

--

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel() TO authenticated;

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel() TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel() TO anon;

--

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint) TO authenticated;

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint) TO anon;

--

GRANT ALL ON FUNCTION public.count_completed_receiving_tasks() TO authenticated;

GRANT ALL ON FUNCTION public.count_completed_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.count_completed_receiving_tasks() TO anon;

--

GRANT ALL ON FUNCTION public.count_finished_receiving_tasks() TO authenticated;

GRANT ALL ON FUNCTION public.count_finished_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.count_finished_receiving_tasks() TO anon;

--

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks() TO authenticated;

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks() TO anon;

--

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks_detailed() TO authenticated;

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks_detailed() TO service_role;

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks_detailed() TO anon;

--

GRANT ALL ON FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text) TO authenticated;

GRANT ALL ON FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text) TO service_role;

GRANT ALL ON FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text) TO anon;

--

GRANT ALL ON FUNCTION public.create_customer_registration(p_name text, p_whatsapp_number text, p_branch_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.create_customer_registration(p_name text, p_whatsapp_number text, p_branch_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id bigint, p_start_time time without time zone, p_end_time time without time zone) TO authenticated;

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id bigint, p_start_time time without time zone, p_end_time time without time zone) TO service_role;

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id bigint, p_start_time time without time zone, p_end_time time without time zone) TO anon;

--

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id uuid, p_start_time time without time zone, p_end_time time without time zone) TO authenticated;

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id uuid, p_start_time time without time zone, p_end_time time without time zone) TO service_role;

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id uuid, p_start_time time without time zone, p_end_time time without time zone) TO anon;

--

GRANT ALL ON FUNCTION public.create_default_interface_permissions() TO authenticated;

GRANT ALL ON FUNCTION public.create_default_interface_permissions() TO service_role;

GRANT ALL ON FUNCTION public.create_default_interface_permissions() TO anon;

--

GRANT ALL ON FUNCTION public.create_notification_recipients() TO authenticated;

GRANT ALL ON FUNCTION public.create_notification_recipients() TO service_role;

GRANT ALL ON FUNCTION public.create_notification_recipients() TO anon;

--

GRANT ALL ON FUNCTION public.create_notification_simple(title_param text, message_param text, created_by_param text, created_by_name_param text, target_user_id_param uuid, task_id_param uuid, assignment_id_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.create_notification_simple(title_param text, message_param text, created_by_param text, created_by_name_param text, target_user_id_param uuid, task_id_param uuid, assignment_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.create_notification_simple(title_param text, message_param text, created_by_param text, created_by_name_param text, target_user_id_param uuid, task_id_param uuid, assignment_id_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.create_quick_task_notification() TO authenticated;

GRANT ALL ON FUNCTION public.create_quick_task_notification() TO service_role;

GRANT ALL ON FUNCTION public.create_quick_task_notification() TO anon;

--

GRANT ALL ON FUNCTION public.create_quick_task_with_assignments(title_param character varying, description_param text, priority_param character varying, deadline_param timestamp with time zone, created_by_param uuid, assigned_user_ids uuid[], require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean) TO authenticated;

GRANT ALL ON FUNCTION public.create_quick_task_with_assignments(title_param character varying, description_param text, priority_param character varying, deadline_param timestamp with time zone, created_by_param uuid, assigned_user_ids uuid[], require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_quick_task_with_assignments(title_param character varying, description_param text, priority_param character varying, deadline_param timestamp with time zone, created_by_param uuid, assigned_user_ids uuid[], require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean) TO anon;

--

GRANT ALL ON FUNCTION public.create_recurring_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, recurrence_pattern character varying, start_date date, end_date date) TO authenticated;

GRANT ALL ON FUNCTION public.create_recurring_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, recurrence_pattern character varying, start_date date, end_date date) TO service_role;

GRANT ALL ON FUNCTION public.create_recurring_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, recurrence_pattern character varying, start_date date, end_date date) TO anon;

--

GRANT ALL ON FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean) TO authenticated;

GRANT ALL ON FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean) TO anon;

--

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id bigint, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO authenticated;

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id bigint, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id bigint, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO anon;

--

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id uuid, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO authenticated;

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id uuid, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id uuid, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO anon;

--

GRANT ALL ON FUNCTION public.create_scheduled_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, scheduled_for timestamp with time zone, priority character varying) TO authenticated;

GRANT ALL ON FUNCTION public.create_scheduled_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, scheduled_for timestamp with time zone, priority character varying) TO service_role;

GRANT ALL ON FUNCTION public.create_scheduled_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, scheduled_for timestamp with time zone, priority character varying) TO anon;

--

GRANT ALL ON FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean) TO authenticated;

GRANT ALL ON FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean) TO anon;

--

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_is_master_admin boolean, p_user_type public.user_type_enum) TO authenticated;

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_is_master_admin boolean, p_user_type public.user_type_enum) TO service_role;

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_is_master_admin boolean, p_user_type public.user_type_enum) TO anon;

--

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_role_type public.role_type_enum, p_user_type public.user_type_enum) TO authenticated;

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_role_type public.role_type_enum, p_user_type public.user_type_enum) TO service_role;

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_role_type public.role_type_enum, p_user_type public.user_type_enum) TO anon;

--

GRANT ALL ON FUNCTION public.create_task(title_param text, description_param text, created_by_param text, created_by_name_param text, created_by_role_param text, priority_param text, due_date_param date, due_time_param time without time zone, require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean, can_escalate_param boolean, can_reassign_param boolean) TO authenticated;

GRANT ALL ON FUNCTION public.create_task(title_param text, description_param text, created_by_param text, created_by_name_param text, created_by_role_param text, priority_param text, due_date_param date, due_time_param time without time zone, require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean, can_escalate_param boolean, can_reassign_param boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_task(title_param text, description_param text, created_by_param text, created_by_name_param text, created_by_role_param text, priority_param text, due_date_param date, due_time_param time without time zone, require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean, can_escalate_param boolean, can_reassign_param boolean) TO anon;

--

GRANT ALL ON FUNCTION public.create_user(p_username character varying, p_password character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_quick_access_code character varying) TO authenticated;

GRANT ALL ON FUNCTION public.create_user(p_username character varying, p_password character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_quick_access_code character varying) TO service_role;

GRANT ALL ON FUNCTION public.create_user(p_username character varying, p_password character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_quick_access_code character varying) TO anon;

--

GRANT ALL ON FUNCTION public.create_user_profile() TO authenticated;

GRANT ALL ON FUNCTION public.create_user_profile() TO service_role;

GRANT ALL ON FUNCTION public.create_user_profile() TO anon;

--

GRANT ALL ON FUNCTION public.create_variation_group(p_parent_barcode text, p_variation_barcodes text[], p_group_name_en text, p_group_name_ar text, p_image_override text, p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.create_variation_group(p_parent_barcode text, p_variation_barcodes text[], p_group_name_en text, p_group_name_ar text, p_image_override text, p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.create_variation_group(p_parent_barcode text, p_variation_barcodes text[], p_group_name_en text, p_group_name_ar text, p_image_override text, p_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.create_warning_history() TO authenticated;

GRANT ALL ON FUNCTION public.create_warning_history() TO service_role;

GRANT ALL ON FUNCTION public.create_warning_history() TO anon;

--

GRANT ALL ON FUNCTION public.current_user_is_admin() TO authenticated;

GRANT ALL ON FUNCTION public.current_user_is_admin() TO anon;

GRANT ALL ON FUNCTION public.current_user_is_admin() TO service_role;

--

GRANT ALL ON FUNCTION public.daily_erp_sync_maintenance() TO authenticated;

GRANT ALL ON FUNCTION public.daily_erp_sync_maintenance() TO service_role;

GRANT ALL ON FUNCTION public.daily_erp_sync_maintenance() TO anon;

--

GRANT ALL ON FUNCTION public.deactivate_expired_media() TO authenticated;

GRANT ALL ON FUNCTION public.deactivate_expired_media() TO service_role;

GRANT ALL ON FUNCTION public.deactivate_expired_media() TO anon;

--

GRANT ALL ON FUNCTION public.debug_get_dependency_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO authenticated;

GRANT ALL ON FUNCTION public.debug_get_dependency_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO service_role;

GRANT ALL ON FUNCTION public.debug_get_dependency_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO anon;

--

GRANT ALL ON FUNCTION public.debug_receiving_tasks_data() TO authenticated;

GRANT ALL ON FUNCTION public.debug_receiving_tasks_data() TO service_role;

GRANT ALL ON FUNCTION public.debug_receiving_tasks_data() TO anon;

--

GRANT ALL ON FUNCTION public.debug_users() TO authenticated;

GRANT ALL ON FUNCTION public.debug_users() TO service_role;

GRANT ALL ON FUNCTION public.debug_users() TO anon;

--

GRANT ALL ON FUNCTION public.decrement_voucher_stock(voucher_value numeric, decrement_amount integer) TO authenticated;

GRANT ALL ON FUNCTION public.decrement_voucher_stock(voucher_value numeric, decrement_amount integer) TO service_role;

GRANT ALL ON FUNCTION public.decrement_voucher_stock(voucher_value numeric, decrement_amount integer) TO anon;

--

GRANT ALL ON FUNCTION public.delete_app_icon(p_icon_key text) TO authenticated;

--

GRANT ALL ON FUNCTION public.delete_branch_sync_config(p_id bigint) TO authenticated;

GRANT ALL ON FUNCTION public.delete_branch_sync_config(p_id bigint) TO anon;

GRANT ALL ON FUNCTION public.delete_branch_sync_config(p_id bigint) TO service_role;

--

GRANT ALL ON FUNCTION public.delete_customer_account(p_customer_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.delete_customer_account(p_customer_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.delete_customer_account(p_customer_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.delete_incident_cascade(p_incident_id text) TO authenticated;

GRANT ALL ON FUNCTION public.delete_incident_cascade(p_incident_id text) TO anon;

--

GRANT ALL ON FUNCTION public.denomination_audit_trigger() TO authenticated;

GRANT ALL ON FUNCTION public.denomination_audit_trigger() TO service_role;

GRANT ALL ON FUNCTION public.denomination_audit_trigger() TO anon;

--

GRANT ALL ON FUNCTION public.duplicate_flyer_template(template_id uuid, new_name character varying, user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.duplicate_flyer_template(template_id uuid, new_name character varying, user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.duplicate_flyer_template(template_id uuid, new_name character varying, user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.end_break(p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.end_break(p_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.end_break(p_user_id uuid, p_security_code text) TO authenticated;

GRANT ALL ON FUNCTION public.end_break(p_user_id uuid, p_security_code text) TO anon;

--

GRANT ALL ON FUNCTION public.ensure_single_default_flyer_template() TO authenticated;

GRANT ALL ON FUNCTION public.ensure_single_default_flyer_template() TO service_role;

GRANT ALL ON FUNCTION public.ensure_single_default_flyer_template() TO anon;

--

GRANT ALL ON FUNCTION public.export_schema_ddl() TO authenticated;

GRANT ALL ON FUNCTION public.export_schema_ddl() TO service_role;

--

GRANT ALL ON FUNCTION public.export_table_for_sync(p_table_name text) TO authenticated;

GRANT ALL ON FUNCTION public.export_table_for_sync(p_table_name text) TO anon;

--

GRANT ALL ON FUNCTION public.format_file_size(size_bytes bigint) TO authenticated;

GRANT ALL ON FUNCTION public.format_file_size(size_bytes bigint) TO service_role;

GRANT ALL ON FUNCTION public.format_file_size(size_bytes bigint) TO anon;

--

GRANT ALL ON FUNCTION public.generate_branch_id() TO authenticated;

GRANT ALL ON FUNCTION public.generate_branch_id() TO service_role;

GRANT ALL ON FUNCTION public.generate_branch_id() TO anon;

--

GRANT ALL ON FUNCTION public.generate_campaign_code() TO authenticated;

GRANT ALL ON FUNCTION public.generate_campaign_code() TO service_role;

GRANT ALL ON FUNCTION public.generate_campaign_code() TO anon;

--

GRANT ALL ON FUNCTION public.generate_clearance_certificate_tasks(receiving_record_id_param uuid, clearance_certificate_url_param text, created_by_user_id text, created_by_name text, created_by_role text) TO authenticated;

GRANT ALL ON FUNCTION public.generate_clearance_certificate_tasks(receiving_record_id_param uuid, clearance_certificate_url_param text, created_by_user_id text, created_by_name text, created_by_role text) TO service_role;

GRANT ALL ON FUNCTION public.generate_clearance_certificate_tasks(receiving_record_id_param uuid, clearance_certificate_url_param text, created_by_user_id text, created_by_name text, created_by_role text) TO anon;

--

GRANT ALL ON FUNCTION public.generate_insurance_company_id() TO authenticated;

GRANT ALL ON FUNCTION public.generate_insurance_company_id() TO service_role;

GRANT ALL ON FUNCTION public.generate_insurance_company_id() TO anon;

--

GRANT ALL ON FUNCTION public.generate_new_customer_access_code(p_customer_id uuid, p_admin_user_id uuid, p_notes text) TO authenticated;

GRANT ALL ON FUNCTION public.generate_new_customer_access_code(p_customer_id uuid, p_admin_user_id uuid, p_notes text) TO anon;

--

GRANT ALL ON FUNCTION public.generate_order_number() TO authenticated;

GRANT ALL ON FUNCTION public.generate_order_number() TO service_role;

GRANT ALL ON FUNCTION public.generate_order_number() TO anon;

--

GRANT ALL ON FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) TO authenticated;

GRANT ALL ON FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) TO service_role;

GRANT ALL ON FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) TO anon;

--

GRANT ALL ON FUNCTION public.generate_salt() TO authenticated;

GRANT ALL ON FUNCTION public.generate_salt() TO service_role;

GRANT ALL ON FUNCTION public.generate_salt() TO anon;

--

GRANT ALL ON FUNCTION public.generate_unique_customer_access_code() TO authenticated;

GRANT ALL ON FUNCTION public.generate_unique_customer_access_code() TO service_role;

GRANT ALL ON FUNCTION public.generate_unique_customer_access_code() TO anon;

--

GRANT ALL ON FUNCTION public.generate_unique_quick_access_code() TO authenticated;

GRANT ALL ON FUNCTION public.generate_unique_quick_access_code() TO service_role;

GRANT ALL ON FUNCTION public.generate_unique_quick_access_code() TO anon;

--

GRANT ALL ON FUNCTION public.generate_warning_reference() TO authenticated;

GRANT ALL ON FUNCTION public.generate_warning_reference() TO service_role;

GRANT ALL ON FUNCTION public.generate_warning_reference() TO anon;

--

GRANT ALL ON FUNCTION public.get_active_break(p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_active_break(p_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_active_customer_media() TO authenticated;

GRANT ALL ON FUNCTION public.get_active_customer_media() TO service_role;

GRANT ALL ON FUNCTION public.get_active_customer_media() TO anon;

--

GRANT ALL ON FUNCTION public.get_active_employees_by_branch(branch_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_active_employees_by_branch(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_active_employees_by_branch(branch_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_active_flyer_templates() TO authenticated;

GRANT ALL ON FUNCTION public.get_active_flyer_templates() TO service_role;

GRANT ALL ON FUNCTION public.get_active_flyer_templates() TO anon;

--

GRANT ALL ON FUNCTION public.get_active_offers_for_customer(p_customer_id uuid, p_branch_id integer, p_service_type character varying) TO authenticated;

GRANT ALL ON FUNCTION public.get_active_offers_for_customer(p_customer_id uuid, p_branch_id integer, p_service_type character varying) TO service_role;

GRANT ALL ON FUNCTION public.get_active_offers_for_customer(p_customer_id uuid, p_branch_id integer, p_service_type character varying) TO anon;

--

GRANT ALL ON FUNCTION public.get_all_breaks(p_date_from date, p_date_to date, p_branch_id integer, p_status character varying) TO authenticated;

GRANT ALL ON FUNCTION public.get_all_breaks(p_date_from date, p_date_to date, p_branch_id integer, p_status character varying) TO anon;

--

GRANT ALL ON FUNCTION public.get_all_delivery_tiers() TO authenticated;

GRANT ALL ON FUNCTION public.get_all_delivery_tiers() TO service_role;

GRANT ALL ON FUNCTION public.get_all_delivery_tiers() TO anon;

--

GRANT ALL ON FUNCTION public.get_all_products_master() TO anon;

GRANT ALL ON FUNCTION public.get_all_products_master() TO authenticated;

GRANT ALL ON FUNCTION public.get_all_products_master() TO service_role;

--

GRANT ALL ON FUNCTION public.get_all_receiving_tasks() TO authenticated;

GRANT ALL ON FUNCTION public.get_all_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.get_all_receiving_tasks() TO anon;

--

GRANT ALL ON FUNCTION public.get_all_users() TO authenticated;

GRANT ALL ON FUNCTION public.get_all_users() TO service_role;

GRANT ALL ON FUNCTION public.get_all_users() TO anon;

--

GRANT ALL ON FUNCTION public.get_analytics_log_tables() TO service_role;

--

GRANT ALL ON FUNCTION public.get_app_icons() TO authenticated;

GRANT ALL ON FUNCTION public.get_app_icons() TO anon;

--

GRANT ALL ON FUNCTION public.get_approval_center_data(p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_approval_center_data(p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_approval_center_data(p_user_id uuid) TO service_role;

--

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(user_id uuid, days_ahead integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(user_id uuid, days_ahead integer) TO service_role;

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(user_id uuid, days_ahead integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer) TO service_role;

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) TO authenticated;

GRANT ALL ON FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) TO anon;

--

GRANT ALL ON FUNCTION public.get_branch_promissory_notes_summary(branch_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_branch_promissory_notes_summary(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_branch_promissory_notes_summary(branch_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_branch_service_availability(branch_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_branch_service_availability(branch_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_branch_service_availability(branch_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_branch_sync_configs() TO authenticated;

GRANT ALL ON FUNCTION public.get_branch_sync_configs() TO anon;

GRANT ALL ON FUNCTION public.get_branch_sync_configs() TO service_role;

--

GRANT ALL ON FUNCTION public.get_branch_visits_summary(branch_uuid uuid, start_date date, end_date date) TO authenticated;

GRANT ALL ON FUNCTION public.get_branch_visits_summary(branch_uuid uuid, start_date date, end_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_branch_visits_summary(branch_uuid uuid, start_date date, end_date date) TO anon;

--

GRANT ALL ON FUNCTION public.get_break_security_code() TO authenticated;

GRANT ALL ON FUNCTION public.get_break_security_code() TO anon;

--

GRANT ALL ON FUNCTION public.get_break_summary_all_employees(p_date_from date, p_date_to date, p_branch_id integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_break_summary_all_employees(p_date_from date, p_date_to date, p_branch_id integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_broadcast_summary(p_broadcast_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_broadcast_summary(p_broadcast_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_bt_assigned_ims(p_request_ids uuid[]) TO authenticated;

GRANT ALL ON FUNCTION public.get_bt_assigned_ims(p_request_ids uuid[]) TO anon;

--

GRANT ALL ON FUNCTION public.get_bt_requests_with_details() TO authenticated;

GRANT ALL ON FUNCTION public.get_bt_requests_with_details() TO anon;

--

GRANT ALL ON FUNCTION public.get_bucket_files(p_bucket_id text) TO authenticated;

GRANT ALL ON FUNCTION public.get_bucket_files(p_bucket_id text) TO anon;

--

GRANT ALL ON FUNCTION public.get_campaign_statistics(p_campaign_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_campaign_statistics(p_campaign_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_campaign_statistics(p_campaign_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_cart_tier_discount(p_offer_id integer, p_cart_amount numeric) TO authenticated;

GRANT ALL ON FUNCTION public.get_cart_tier_discount(p_offer_id integer, p_cart_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_cart_tier_discount(p_offer_id integer, p_cart_amount numeric) TO anon;

--

GRANT ALL ON FUNCTION public.get_close_purchase_voucher_data() TO authenticated;

GRANT ALL ON FUNCTION public.get_close_purchase_voucher_data() TO anon;

--

GRANT ALL ON FUNCTION public.get_completed_receiving_tasks() TO authenticated;

GRANT ALL ON FUNCTION public.get_completed_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.get_completed_receiving_tasks() TO anon;

--

GRANT ALL ON FUNCTION public.get_contact_broadcast_stats(phone_number text) TO authenticated;

GRANT ALL ON FUNCTION public.get_contact_broadcast_stats(phone_number text) TO anon;

--

GRANT ALL ON FUNCTION public.get_current_user_id() TO authenticated;

GRANT ALL ON FUNCTION public.get_current_user_id() TO anon;

GRANT ALL ON FUNCTION public.get_current_user_id() TO service_role;

--

GRANT ALL ON FUNCTION public.get_customer_products_with_offers(p_branch_id text, p_service_type text) TO authenticated;

GRANT ALL ON FUNCTION public.get_customer_products_with_offers(p_branch_id text, p_service_type text) TO service_role;

GRANT ALL ON FUNCTION public.get_customer_products_with_offers(p_branch_id text, p_service_type text) TO anon;

--

GRANT ALL ON FUNCTION public.get_customer_requests_with_details() TO authenticated;

GRANT ALL ON FUNCTION public.get_customer_requests_with_details() TO anon;

--

GRANT ALL ON FUNCTION public.get_database_functions() TO authenticated;

GRANT ALL ON FUNCTION public.get_database_functions() TO anon;

--

GRANT ALL ON FUNCTION public.get_database_schema() TO authenticated;

GRANT ALL ON FUNCTION public.get_database_schema() TO service_role;

GRANT ALL ON FUNCTION public.get_database_schema() TO anon;

--

GRANT ALL ON FUNCTION public.get_database_triggers() TO authenticated;

GRANT ALL ON FUNCTION public.get_database_triggers() TO service_role;

GRANT ALL ON FUNCTION public.get_database_triggers() TO anon;

--

GRANT ALL ON FUNCTION public.get_day_offs_with_details(p_date_from date, p_date_to date) TO authenticated;

GRANT ALL ON FUNCTION public.get_day_offs_with_details(p_date_from date, p_date_to date) TO anon;

--

GRANT ALL ON FUNCTION public.get_default_flyer_template() TO authenticated;

GRANT ALL ON FUNCTION public.get_default_flyer_template() TO service_role;

GRANT ALL ON FUNCTION public.get_default_flyer_template() TO anon;

--

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) TO authenticated;

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) TO anon;

--

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) TO authenticated;

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) TO anon;

--

GRANT ALL ON FUNCTION public.get_delivery_service_settings() TO authenticated;

GRANT ALL ON FUNCTION public.get_delivery_service_settings() TO service_role;

GRANT ALL ON FUNCTION public.get_delivery_service_settings() TO anon;

--

GRANT ALL ON FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) TO authenticated;

GRANT ALL ON FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) TO anon;

--

GRANT ALL ON FUNCTION public.get_dependency_completion_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO authenticated;

GRANT ALL ON FUNCTION public.get_dependency_completion_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO service_role;

GRANT ALL ON FUNCTION public.get_dependency_completion_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO anon;

--

GRANT ALL ON FUNCTION public.get_edge_function_logs(p_limit integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_edge_function_logs(p_limit integer) TO service_role;

--

GRANT ALL ON FUNCTION public.get_edge_functions() TO authenticated;

GRANT ALL ON FUNCTION public.get_edge_functions() TO anon;

--

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id bigint) TO authenticated;

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id bigint) TO anon;

--

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id uuid, p_date date) TO authenticated;

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id uuid, p_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id uuid, p_date date) TO anon;

--

GRANT ALL ON FUNCTION public.get_employee_document_category_stats(emp_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_employee_document_category_stats(emp_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_document_category_stats(emp_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id bigint, p_start_date date, p_end_date date) TO authenticated;

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id bigint, p_start_date date, p_end_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id bigint, p_start_date date, p_end_date date) TO anon;

--

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id uuid, p_start_date date, p_end_date date) TO authenticated;

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id uuid, p_start_date date, p_end_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id uuid, p_start_date date, p_end_date date) TO anon;

--

GRANT ALL ON FUNCTION public.get_expense_category_stats() TO authenticated;

GRANT ALL ON FUNCTION public.get_expense_category_stats() TO service_role;

GRANT ALL ON FUNCTION public.get_expense_category_stats() TO anon;

--

GRANT ALL ON FUNCTION public.get_file_extension(filename text) TO authenticated;

GRANT ALL ON FUNCTION public.get_file_extension(filename text) TO service_role;

GRANT ALL ON FUNCTION public.get_file_extension(filename text) TO anon;

--

GRANT ALL ON FUNCTION public.get_flyer_generator_data(p_offer_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_flyer_generator_data(p_offer_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_flyer_generator_data(p_offer_id uuid) TO service_role;

--

GRANT ALL ON FUNCTION public.get_incident_manager_data() TO authenticated;

GRANT ALL ON FUNCTION public.get_incident_manager_data() TO service_role;

GRANT ALL ON FUNCTION public.get_incident_manager_data() TO anon;

--

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks() TO authenticated;

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks() TO anon;

--

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks_breakdown() TO authenticated;

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks_breakdown() TO service_role;

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks_breakdown() TO anon;

--

GRANT ALL ON FUNCTION public.get_issue_pv_vouchers(p_pv_id text, p_serial_number bigint) TO authenticated;

GRANT ALL ON FUNCTION public.get_issue_pv_vouchers(p_pv_id text, p_serial_number bigint) TO anon;

--

GRANT ALL ON FUNCTION public.get_latest_frontend_build() TO authenticated;

GRANT ALL ON FUNCTION public.get_latest_frontend_build() TO anon;

GRANT ALL ON FUNCTION public.get_latest_frontend_build() TO service_role;

--

GRANT ALL ON FUNCTION public.get_lease_rent_properties_with_spaces() TO authenticated;

GRANT ALL ON FUNCTION public.get_lease_rent_properties_with_spaces() TO service_role;

GRANT ALL ON FUNCTION public.get_lease_rent_properties_with_spaces() TO anon;

--

GRANT ALL ON FUNCTION public.get_lease_rent_tab_data(p_party_type text) TO authenticated;

GRANT ALL ON FUNCTION public.get_lease_rent_tab_data(p_party_type text) TO service_role;

GRANT ALL ON FUNCTION public.get_lease_rent_tab_data(p_party_type text) TO anon;

--

GRANT ALL ON FUNCTION public.get_mobile_dashboard_data(p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_mobile_dashboard_data(p_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_next_delivery_tier(current_amount numeric) TO authenticated;

GRANT ALL ON FUNCTION public.get_next_delivery_tier(current_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_next_delivery_tier(current_amount numeric) TO anon;

--

GRANT ALL ON FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) TO authenticated;

GRANT ALL ON FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) TO anon;

--

GRANT ALL ON FUNCTION public.get_next_product_serial() TO authenticated;

GRANT ALL ON FUNCTION public.get_next_product_serial() TO service_role;

GRANT ALL ON FUNCTION public.get_next_product_serial() TO anon;

--

GRANT ALL ON FUNCTION public.get_offer_products_data(p_exclude_offer_id integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_offer_products_data(p_exclude_offer_id integer) TO service_role;

GRANT ALL ON FUNCTION public.get_offer_products_data(p_exclude_offer_id integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_offer_variation_summary(p_offer_id integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_offer_variation_summary(p_offer_id integer) TO service_role;

GRANT ALL ON FUNCTION public.get_offer_variation_summary(p_offer_id integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_ongoing_quick_assignment_count(p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_ongoing_quick_assignment_count(p_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_or_create_app_function(p_function_code text, p_function_name text, p_description text, p_category text) TO authenticated;

GRANT ALL ON FUNCTION public.get_or_create_app_function(p_function_code text, p_function_name text, p_description text, p_category text) TO service_role;

GRANT ALL ON FUNCTION public.get_or_create_app_function(p_function_code text, p_function_name text, p_description text, p_category text) TO anon;

--

GRANT ALL ON FUNCTION public.get_overdue_tasks_without_reminders() TO authenticated;

GRANT ALL ON FUNCTION public.get_overdue_tasks_without_reminders() TO service_role;

GRANT ALL ON FUNCTION public.get_overdue_tasks_without_reminders() TO anon;

--

GRANT ALL ON FUNCTION public.get_paid_expense_payments(p_date_from date, p_date_to date) TO authenticated;

GRANT ALL ON FUNCTION public.get_paid_expense_payments(p_date_from date, p_date_to date) TO anon;

--

GRANT ALL ON FUNCTION public.get_paid_vendor_payments(p_date_from date, p_date_to date) TO authenticated;

GRANT ALL ON FUNCTION public.get_paid_vendor_payments(p_date_from date, p_date_to date) TO anon;

--

GRANT ALL ON FUNCTION public.get_party_payment_data(p_party_type text, p_party_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_party_payment_data(p_party_type text, p_party_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_party_payment_data(p_party_type text, p_party_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_po_requests_with_details() TO authenticated;

GRANT ALL ON FUNCTION public.get_po_requests_with_details() TO anon;

--

GRANT ALL ON FUNCTION public.get_pos_report(p_date_from timestamp with time zone, p_date_to timestamp with time zone) TO authenticated;

GRANT ALL ON FUNCTION public.get_pos_report(p_date_from timestamp with time zone, p_date_to timestamp with time zone) TO anon;

--

GRANT ALL ON FUNCTION public.get_product_master_init_data() TO anon;

GRANT ALL ON FUNCTION public.get_product_master_init_data() TO authenticated;

GRANT ALL ON FUNCTION public.get_product_master_init_data() TO service_role;

--

GRANT ALL ON FUNCTION public.get_product_offers(p_product_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_product_offers(p_product_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_product_offers(p_product_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_product_variations(p_barcode text) TO authenticated;

GRANT ALL ON FUNCTION public.get_product_variations(p_barcode text) TO service_role;

GRANT ALL ON FUNCTION public.get_product_variations(p_barcode text) TO anon;

--

GRANT ALL ON FUNCTION public.get_products_in_active_offers() TO authenticated;

GRANT ALL ON FUNCTION public.get_products_in_active_offers() TO service_role;

GRANT ALL ON FUNCTION public.get_products_in_active_offers() TO anon;

--

GRANT ALL ON FUNCTION public.get_purchase_voucher_manager_data() TO authenticated;

GRANT ALL ON FUNCTION public.get_purchase_voucher_manager_data() TO anon;

--

GRANT ALL ON FUNCTION public.get_pv_stock_manager_data() TO authenticated;

GRANT ALL ON FUNCTION public.get_pv_stock_manager_data() TO anon;

--

GRANT ALL ON FUNCTION public.get_pv_stock_voucher_items() TO authenticated;

GRANT ALL ON FUNCTION public.get_pv_stock_voucher_items() TO anon;

--

GRANT ALL ON FUNCTION public.get_quick_access_stats() TO authenticated;

GRANT ALL ON FUNCTION public.get_quick_access_stats() TO service_role;

GRANT ALL ON FUNCTION public.get_quick_access_stats() TO anon;

--

GRANT ALL ON FUNCTION public.get_quick_task_completion_stats() TO authenticated;

GRANT ALL ON FUNCTION public.get_quick_task_completion_stats() TO service_role;

GRANT ALL ON FUNCTION public.get_quick_task_completion_stats() TO anon;

--

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from date, date_to date) TO authenticated;

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from date, date_to date) TO service_role;

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from date, date_to date) TO anon;

--

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from timestamp with time zone, date_to timestamp with time zone) TO authenticated;

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from timestamp with time zone, date_to timestamp with time zone) TO service_role;

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from timestamp with time zone, date_to timestamp with time zone) TO anon;

--

GRANT ALL ON FUNCTION public.get_reminder_statistics(p_user_id uuid, p_days integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_reminder_statistics(p_user_id uuid, p_days integer) TO service_role;

GRANT ALL ON FUNCTION public.get_reminder_statistics(p_user_id uuid, p_days integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_report_data(p_party_type text, p_party_ids uuid[]) TO authenticated;

GRANT ALL ON FUNCTION public.get_report_data(p_party_type text, p_party_ids uuid[]) TO service_role;

GRANT ALL ON FUNCTION public.get_report_data(p_party_type text, p_party_ids uuid[]) TO anon;

--

GRANT ALL ON FUNCTION public.get_report_party_paid_totals(p_party_type text) TO authenticated;

GRANT ALL ON FUNCTION public.get_report_party_paid_totals(p_party_type text) TO service_role;

GRANT ALL ON FUNCTION public.get_report_party_paid_totals(p_party_type text) TO anon;

--

GRANT ALL ON FUNCTION public.get_server_disk_usage() TO authenticated;

GRANT ALL ON FUNCTION public.get_server_disk_usage() TO anon;

--

GRANT ALL ON FUNCTION public.get_stock_requests_with_details() TO authenticated;

GRANT ALL ON FUNCTION public.get_stock_requests_with_details() TO anon;

--

GRANT ALL ON FUNCTION public.get_storage_buckets_info() TO authenticated;

GRANT ALL ON FUNCTION public.get_storage_buckets_info() TO anon;

--

GRANT ALL ON FUNCTION public.get_storage_stats() TO authenticated;

GRANT ALL ON FUNCTION public.get_storage_stats() TO anon;

GRANT ALL ON FUNCTION public.get_storage_stats() TO service_role;

--

GRANT ALL ON FUNCTION public.get_system_expiry_dates(barcode_list text[], branch_id_param integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_system_expiry_dates(barcode_list text[], branch_id_param integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_table_schemas() TO authenticated;

GRANT ALL ON FUNCTION public.get_table_schemas() TO anon;

--

GRANT ALL ON FUNCTION public.get_task_dashboard(user_id_param text, branch_id_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_task_dashboard(user_id_param text, branch_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_task_dashboard(user_id_param text, branch_id_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_task_statistics(user_id_param text) TO authenticated;

GRANT ALL ON FUNCTION public.get_task_statistics(user_id_param text) TO service_role;

GRANT ALL ON FUNCTION public.get_task_statistics(user_id_param text) TO anon;

--

GRANT ALL ON FUNCTION public.get_task_statistics(user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_task_statistics(user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_task_statistics(user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_tasks_for_receiving_record(receiving_record_id_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_tasks_for_receiving_record(receiving_record_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_tasks_for_receiving_record(receiving_record_id_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(target_date date) TO authenticated;

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(target_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(target_date date) TO anon;

--

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(branch_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(branch_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_todays_vendor_visits(branch_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_todays_vendor_visits(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_todays_vendor_visits(branch_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_todays_visits(branch_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_todays_visits(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_todays_visits(branch_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_upcoming_visits(branch_uuid uuid, days_ahead integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_upcoming_visits(branch_uuid uuid, days_ahead integer) TO service_role;

GRANT ALL ON FUNCTION public.get_upcoming_visits(branch_uuid uuid, days_ahead integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_user_assigned_tasks(user_id_param text, branch_id_param uuid, status_filter text, limit_param integer, offset_param integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_user_assigned_tasks(user_id_param text, branch_id_param uuid, status_filter text, limit_param integer, offset_param integer) TO service_role;

GRANT ALL ON FUNCTION public.get_user_assigned_tasks(user_id_param text, branch_id_param uuid, status_filter text, limit_param integer, offset_param integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_user_interface_permissions(p_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_user_interface_permissions(p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_user_interface_permissions(p_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_user_receiving_tasks_dashboard(user_id_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_user_receiving_tasks_dashboard(user_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_user_receiving_tasks_dashboard(user_id_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_users_with_employee_details() TO authenticated;

GRANT ALL ON FUNCTION public.get_users_with_employee_details() TO service_role;

GRANT ALL ON FUNCTION public.get_users_with_employee_details() TO anon;

--

GRANT ALL ON FUNCTION public.get_variation_group_info(p_barcode text) TO authenticated;

GRANT ALL ON FUNCTION public.get_variation_group_info(p_barcode text) TO service_role;

GRANT ALL ON FUNCTION public.get_variation_group_info(p_barcode text) TO anon;

--

GRANT ALL ON FUNCTION public.get_vendor_count_by_branch() TO authenticated;

GRANT ALL ON FUNCTION public.get_vendor_count_by_branch() TO service_role;

GRANT ALL ON FUNCTION public.get_vendor_count_by_branch() TO anon;

--

GRANT ALL ON FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) TO authenticated;

GRANT ALL ON FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) TO anon;

--

GRANT ALL ON FUNCTION public.get_vendor_pending_summary() TO authenticated;

GRANT ALL ON FUNCTION public.get_vendor_pending_summary() TO anon;

--

GRANT ALL ON FUNCTION public.get_vendor_promissory_notes_summary(vendor_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_vendor_promissory_notes_summary(vendor_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_vendor_promissory_notes_summary(vendor_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_vendor_visits_summary(vendor_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_vendor_visits_summary(vendor_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_vendor_visits_summary(vendor_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_vendors_by_branch(branch_id_param bigint) TO authenticated;

GRANT ALL ON FUNCTION public.get_vendors_by_branch(branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_vendors_by_branch(branch_id_param bigint) TO anon;

--

GRANT ALL ON FUNCTION public.get_visit_history(start_date_param date, end_date_param date, branch_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_visit_history(start_date_param date, end_date_param date, branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_visit_history(start_date_param date, end_date_param date, branch_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date date, end_date date) TO authenticated;

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date date, end_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date date, end_date date) TO anon;

--

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date_param date, end_date_param date, branch_uuid uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date_param date, end_date_param date, branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date_param date, end_date_param date, branch_uuid uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_wa_catalog_stats(p_account_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_wa_catalog_stats(p_account_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.get_wa_priority_conversations(p_account_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_wa_priority_conversations(p_account_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_wa_priority_conversations(p_account_id uuid) TO service_role;

--

GRANT ALL ON FUNCTION public.handle_document_deactivation() TO authenticated;

GRANT ALL ON FUNCTION public.handle_document_deactivation() TO service_role;

GRANT ALL ON FUNCTION public.handle_document_deactivation() TO anon;

--

GRANT ALL ON FUNCTION public.handle_order_task_completion() TO authenticated;

GRANT ALL ON FUNCTION public.handle_order_task_completion() TO anon;

--

GRANT ALL ON FUNCTION public.has_order_management_access(user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.has_order_management_access(user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.has_order_management_access(user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.hash_password(password text, salt text) TO authenticated;

GRANT ALL ON FUNCTION public.hash_password(password text, salt text) TO service_role;

GRANT ALL ON FUNCTION public.hash_password(password text, salt text) TO anon;

--

GRANT ALL ON FUNCTION public.import_sync_batch(p_table_name text, p_data jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.import_sync_batch(p_table_name text, p_data jsonb) TO anon;

GRANT ALL ON FUNCTION public.import_sync_batch(p_table_name text, p_data jsonb) TO service_role;

--

GRANT ALL ON FUNCTION public.increment_ai_token_usage(config_id uuid, p_tokens integer, p_prompt integer, p_completion integer) TO service_role;

GRANT ALL ON FUNCTION public.increment_ai_token_usage(config_id uuid, p_tokens integer, p_prompt integer, p_completion integer) TO anon;

GRANT ALL ON FUNCTION public.increment_ai_token_usage(config_id uuid, p_tokens integer, p_prompt integer, p_completion integer) TO authenticated;

--

GRANT ALL ON FUNCTION public.increment_flyer_template_usage() TO authenticated;

GRANT ALL ON FUNCTION public.increment_flyer_template_usage() TO service_role;

GRANT ALL ON FUNCTION public.increment_flyer_template_usage() TO anon;

--

GRANT ALL ON FUNCTION public.increment_page_visit_count(offer_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.increment_page_visit_count(offer_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.increment_page_visit_count(offer_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.increment_social_link_click(_branch_id bigint, _platform text) TO anon;

GRANT ALL ON FUNCTION public.increment_social_link_click(_branch_id bigint, _platform text) TO authenticated;

GRANT ALL ON FUNCTION public.increment_social_link_click(_branch_id bigint, _platform text) TO service_role;

--

GRANT ALL ON FUNCTION public.increment_view_button_count(offer_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.increment_view_button_count(offer_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.increment_view_button_count(offer_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.insert_order_items(p_order_items jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.insert_order_items(p_order_items jsonb) TO service_role;

GRANT ALL ON FUNCTION public.insert_order_items(p_order_items jsonb) TO anon;

--

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name character varying, p_vat_number character varying) TO authenticated;

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name character varying, p_vat_number character varying) TO service_role;

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name character varying, p_vat_number character varying) TO anon;

--

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name_english character varying, p_vendor_name_arabic character varying, p_vat_number character varying) TO authenticated;

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name_english character varying, p_vendor_name_arabic character varying, p_vat_number character varying) TO service_role;

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name_english character varying, p_vendor_name_arabic character varying, p_vat_number character varying) TO anon;

--

GRANT ALL ON FUNCTION public.is_delivery_staff(user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.is_delivery_staff(user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.is_delivery_staff(user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.is_overnight_shift(start_time time without time zone, end_time time without time zone) TO authenticated;

GRANT ALL ON FUNCTION public.is_overnight_shift(start_time time without time zone, end_time time without time zone) TO service_role;

GRANT ALL ON FUNCTION public.is_overnight_shift(start_time time without time zone, end_time time without time zone) TO anon;

--

GRANT ALL ON FUNCTION public.is_product_in_active_bundle(p_product_id uuid, p_exclude_offer_id integer) TO authenticated;

GRANT ALL ON FUNCTION public.is_product_in_active_bundle(p_product_id uuid, p_exclude_offer_id integer) TO service_role;

GRANT ALL ON FUNCTION public.is_product_in_active_bundle(p_product_id uuid, p_exclude_offer_id integer) TO anon;

--

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code text) TO authenticated;

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code text) TO service_role;

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code text) TO anon;

--

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code character varying) TO authenticated;

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code character varying) TO anon;

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code character varying) TO service_role;

--

GRANT ALL ON FUNCTION public.is_user_admin(check_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.is_user_admin(check_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.is_user_admin(check_user_id uuid) TO service_role;

--

GRANT ALL ON FUNCTION public.is_user_master_admin(check_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.is_user_master_admin(check_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.is_user_master_admin(check_user_id uuid) TO service_role;

--

GRANT ALL ON FUNCTION public.link_finger_transaction_to_employee(p_employee_code character varying, p_branch_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.link_finger_transaction_to_employee(p_employee_code character varying, p_branch_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.link_finger_transaction_to_employee(p_employee_code character varying, p_branch_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.log_offer_usage(p_offer_id integer, p_customer_id uuid, p_order_id integer, p_discount_applied numeric, p_original_amount numeric, p_final_amount numeric, p_cart_items jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.log_offer_usage(p_offer_id integer, p_customer_id uuid, p_order_id integer, p_discount_applied numeric, p_original_amount numeric, p_final_amount numeric, p_cart_items jsonb) TO service_role;

GRANT ALL ON FUNCTION public.log_offer_usage(p_offer_id integer, p_customer_id uuid, p_order_id integer, p_discount_applied numeric, p_original_amount numeric, p_final_amount numeric, p_cart_items jsonb) TO anon;

--

GRANT ALL ON FUNCTION public.log_user_action() TO authenticated;

GRANT ALL ON FUNCTION public.log_user_action() TO service_role;

GRANT ALL ON FUNCTION public.log_user_action() TO anon;

--

GRANT ALL ON FUNCTION public.mark_overdue_quick_tasks() TO authenticated;

GRANT ALL ON FUNCTION public.mark_overdue_quick_tasks() TO service_role;

GRANT ALL ON FUNCTION public.mark_overdue_quick_tasks() TO anon;

--

GRANT ALL ON FUNCTION public.notify_branches_change() TO authenticated;

GRANT ALL ON FUNCTION public.notify_branches_change() TO service_role;

GRANT ALL ON FUNCTION public.notify_branches_change() TO anon;

--

GRANT ALL ON FUNCTION public.notify_customer_order_status_change() TO authenticated;

GRANT ALL ON FUNCTION public.notify_customer_order_status_change() TO anon;

GRANT ALL ON FUNCTION public.notify_customer_order_status_change() TO service_role;

--

GRANT ALL ON FUNCTION public.notify_erp_daily_sales_change() TO authenticated;

GRANT ALL ON FUNCTION public.notify_erp_daily_sales_change() TO service_role;

GRANT ALL ON FUNCTION public.notify_erp_daily_sales_change() TO anon;

--

GRANT ALL ON FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text, generated_by_role text) TO authenticated;

GRANT ALL ON FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text, generated_by_role text) TO service_role;

GRANT ALL ON FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text, generated_by_role text) TO anon;

--

GRANT ALL ON FUNCTION public.process_customer_recovery(p_request_id uuid, p_admin_user_id uuid, p_action text, p_notes text) TO authenticated;

GRANT ALL ON FUNCTION public.process_customer_recovery(p_request_id uuid, p_admin_user_id uuid, p_action text, p_notes text) TO service_role;

GRANT ALL ON FUNCTION public.process_customer_recovery(p_request_id uuid, p_admin_user_id uuid, p_action text, p_notes text) TO anon;

--

GRANT ALL ON FUNCTION public.process_finger_transaction_linking() TO authenticated;

GRANT ALL ON FUNCTION public.process_finger_transaction_linking() TO service_role;

GRANT ALL ON FUNCTION public.process_finger_transaction_linking() TO anon;

--

GRANT ALL ON FUNCTION public.queue_push_notification(p_notification_id uuid, p_target_type text, p_target_users jsonb, p_target_roles text[], p_target_branches uuid[]) TO authenticated;

GRANT ALL ON FUNCTION public.queue_push_notification(p_notification_id uuid, p_target_type text, p_target_users jsonb, p_target_roles text[], p_target_branches uuid[]) TO service_role;

GRANT ALL ON FUNCTION public.queue_push_notification(p_notification_id uuid, p_target_type text, p_target_users jsonb, p_target_roles text[], p_target_branches uuid[]) TO anon;

--

GRANT ALL ON FUNCTION public.queue_quick_task_push_notifications() TO authenticated;

GRANT ALL ON FUNCTION public.queue_quick_task_push_notifications() TO service_role;

GRANT ALL ON FUNCTION public.queue_quick_task_push_notifications() TO anon;

--

GRANT ALL ON FUNCTION public.reassign_receiving_task(receiving_task_id_param uuid, new_assigned_user_id uuid, reassigned_by_user_id text, reassignment_reason text) TO authenticated;

GRANT ALL ON FUNCTION public.reassign_receiving_task(receiving_task_id_param uuid, new_assigned_user_id uuid, reassigned_by_user_id text, reassignment_reason text) TO service_role;

GRANT ALL ON FUNCTION public.reassign_receiving_task(receiving_task_id_param uuid, new_assigned_user_id uuid, reassigned_by_user_id text, reassignment_reason text) TO anon;

--

GRANT ALL ON FUNCTION public.reassign_task(assignment_id uuid, new_assignee uuid, reassigned_by uuid, reason text) TO authenticated;

GRANT ALL ON FUNCTION public.reassign_task(assignment_id uuid, new_assignee uuid, reassigned_by uuid, reason text) TO service_role;

GRANT ALL ON FUNCTION public.reassign_task(assignment_id uuid, new_assignee uuid, reassigned_by uuid, reason text) TO anon;

--

GRANT ALL ON FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean) TO authenticated;

GRANT ALL ON FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean) TO service_role;

GRANT ALL ON FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean) TO anon;

--

GRANT ALL ON FUNCTION public.record_fine_payment(warning_id_param uuid, payment_amount_param numeric, payment_method_param character varying, payment_reference_param character varying, processed_by_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.record_fine_payment(warning_id_param uuid, payment_amount_param numeric, payment_method_param character varying, payment_reference_param character varying, processed_by_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.record_fine_payment(warning_id_param uuid, payment_amount_param numeric, payment_method_param character varying, payment_reference_param character varying, processed_by_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.refresh_broadcast_status(p_broadcast_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.refresh_broadcast_status(p_broadcast_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.refresh_edge_functions_cache(p_functions jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.refresh_edge_functions_cache(p_functions jsonb) TO anon;

--

GRANT ALL ON FUNCTION public.refresh_user_roles_from_positions() TO authenticated;

GRANT ALL ON FUNCTION public.refresh_user_roles_from_positions() TO service_role;

GRANT ALL ON FUNCTION public.refresh_user_roles_from_positions() TO anon;

--

GRANT ALL ON FUNCTION public.register_app_function(p_function_name text, p_function_code text, p_description text, p_category text, p_enabled boolean) TO authenticated;

GRANT ALL ON FUNCTION public.register_app_function(p_function_name text, p_function_code text, p_description text, p_category text, p_enabled boolean) TO service_role;

GRANT ALL ON FUNCTION public.register_app_function(p_function_name text, p_function_code text, p_description text, p_category text, p_enabled boolean) TO anon;

--

GRANT ALL ON FUNCTION public.register_push_subscription(p_user_id uuid, p_device_id character varying, p_endpoint text, p_p256dh text, p_auth text, p_device_type character varying, p_browser_name character varying, p_user_agent text) TO authenticated;

GRANT ALL ON FUNCTION public.register_push_subscription(p_user_id uuid, p_device_id character varying, p_endpoint text, p_p256dh text, p_auth text, p_device_type character varying, p_browser_name character varying, p_user_agent text) TO service_role;

GRANT ALL ON FUNCTION public.register_push_subscription(p_user_id uuid, p_device_id character varying, p_endpoint text, p_p256dh text, p_auth text, p_device_type character varying, p_browser_name character varying, p_user_agent text) TO anon;

--

GRANT ALL ON FUNCTION public.register_system_role(p_role_name text, p_role_code text, p_description text) TO authenticated;

GRANT ALL ON FUNCTION public.register_system_role(p_role_name text, p_role_code text, p_description text) TO service_role;

GRANT ALL ON FUNCTION public.register_system_role(p_role_name text, p_role_code text, p_description text) TO anon;

--

GRANT ALL ON FUNCTION public.request_access_code_change(p_email character varying, p_whatsapp character varying) TO authenticated;

GRANT ALL ON FUNCTION public.request_access_code_change(p_email character varying, p_whatsapp character varying) TO anon;

GRANT ALL ON FUNCTION public.request_access_code_change(p_email character varying, p_whatsapp character varying) TO service_role;

--

GRANT ALL ON FUNCTION public.request_access_code_resend(p_whatsapp_number text) TO authenticated;

GRANT ALL ON FUNCTION public.request_access_code_resend(p_whatsapp_number text) TO anon;

--

GRANT ALL ON FUNCTION public.request_new_access_code(p_whatsapp_number text) TO authenticated;

GRANT ALL ON FUNCTION public.request_new_access_code(p_whatsapp_number text) TO service_role;

GRANT ALL ON FUNCTION public.request_new_access_code(p_whatsapp_number text) TO anon;

--

GRANT ALL ON FUNCTION public.request_server_restart() TO authenticated;

GRANT ALL ON FUNCTION public.request_server_restart() TO service_role;

--

GRANT ALL ON FUNCTION public.reschedule_visit(visit_id uuid, new_date date) TO authenticated;

GRANT ALL ON FUNCTION public.reschedule_visit(visit_id uuid, new_date date) TO service_role;

GRANT ALL ON FUNCTION public.reschedule_visit(visit_id uuid, new_date date) TO anon;

--

GRANT ALL ON FUNCTION public.search_tasks(search_query text, user_id_param text, limit_param integer, offset_param integer) TO authenticated;

GRANT ALL ON FUNCTION public.search_tasks(search_query text, user_id_param text, limit_param integer, offset_param integer) TO service_role;

GRANT ALL ON FUNCTION public.search_tasks(search_query text, user_id_param text, limit_param integer, offset_param integer) TO anon;

--

GRANT ALL ON FUNCTION public.search_tasks(search_term text, task_status text, assigned_user_id uuid, created_by_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.search_tasks(search_term text, task_status text, assigned_user_id uuid, created_by_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.search_tasks(search_term text, task_status text, assigned_user_id uuid, created_by_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.select_random_product(p_campaign_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.select_random_product(p_campaign_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.select_random_product(p_campaign_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.send_order_notification(p_order_id uuid, p_title text, p_message text, p_type text, p_priority text, p_performed_by uuid, p_target_user_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.send_order_notification(p_order_id uuid, p_title text, p_message text, p_type text, p_priority text, p_performed_by uuid, p_target_user_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.set_user_context(user_id uuid, is_master_admin boolean, is_admin boolean) TO authenticated;

GRANT ALL ON FUNCTION public.set_user_context(user_id uuid, is_master_admin boolean, is_admin boolean) TO anon;

GRANT ALL ON FUNCTION public.set_user_context(user_id uuid, is_master_admin boolean, is_admin boolean) TO service_role;

--

GRANT ALL ON FUNCTION public.setup_role_permissions(p_role_code text, p_permissions jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.setup_role_permissions(p_role_code text, p_permissions jsonb) TO service_role;

GRANT ALL ON FUNCTION public.setup_role_permissions(p_role_code text, p_permissions jsonb) TO anon;

--

GRANT ALL ON FUNCTION public.skip_visit(visit_id uuid, skip_reason text) TO authenticated;

GRANT ALL ON FUNCTION public.skip_visit(visit_id uuid, skip_reason text) TO service_role;

GRANT ALL ON FUNCTION public.skip_visit(visit_id uuid, skip_reason text) TO anon;

--

GRANT ALL ON FUNCTION public.soft_delete_flyer_template(template_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.soft_delete_flyer_template(template_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.soft_delete_flyer_template(template_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.start_break(p_user_id uuid, p_reason_id integer, p_reason_note text) TO authenticated;

GRANT ALL ON FUNCTION public.start_break(p_user_id uuid, p_reason_id integer, p_reason_note text) TO anon;

--

GRANT ALL ON FUNCTION public.submit_quick_task_completion(p_assignment_id uuid, p_user_id uuid, p_completion_notes text, p_photos text[], p_erp_reference text) TO authenticated;

GRANT ALL ON FUNCTION public.submit_quick_task_completion(p_assignment_id uuid, p_user_id uuid, p_completion_notes text, p_photos text[], p_erp_reference text) TO service_role;

GRANT ALL ON FUNCTION public.submit_quick_task_completion(p_assignment_id uuid, p_user_id uuid, p_completion_notes text, p_photos text[], p_erp_reference text) TO anon;

--

GRANT ALL ON FUNCTION public.sync_all_missing_erp_references() TO authenticated;

GRANT ALL ON FUNCTION public.sync_all_missing_erp_references() TO service_role;

GRANT ALL ON FUNCTION public.sync_all_missing_erp_references() TO anon;

--

GRANT ALL ON FUNCTION public.sync_all_pending_erp_references() TO authenticated;

GRANT ALL ON FUNCTION public.sync_all_pending_erp_references() TO service_role;

GRANT ALL ON FUNCTION public.sync_all_pending_erp_references() TO anon;

--

GRANT ALL ON FUNCTION public.sync_app_functions_from_components(component_metadata jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.sync_app_functions_from_components(component_metadata jsonb) TO service_role;

GRANT ALL ON FUNCTION public.sync_app_functions_from_components(component_metadata jsonb) TO anon;

--

GRANT ALL ON FUNCTION public.sync_employee_with_hr(p_employee_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.sync_employee_with_hr(p_employee_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.sync_employee_with_hr(p_employee_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.sync_erp_references_from_task_completions() TO authenticated;

GRANT ALL ON FUNCTION public.sync_erp_references_from_task_completions() TO service_role;

GRANT ALL ON FUNCTION public.sync_erp_references_from_task_completions() TO anon;

--

GRANT ALL ON FUNCTION public.sync_requisition_balance() TO authenticated;

GRANT ALL ON FUNCTION public.sync_requisition_balance() TO service_role;

GRANT ALL ON FUNCTION public.sync_requisition_balance() TO anon;

--

GRANT ALL ON FUNCTION public.sync_user_roles_from_positions() TO authenticated;

GRANT ALL ON FUNCTION public.sync_user_roles_from_positions() TO service_role;

GRANT ALL ON FUNCTION public.sync_user_roles_from_positions() TO anon;

--

GRANT ALL ON FUNCTION public.track_media_activation() TO authenticated;

GRANT ALL ON FUNCTION public.track_media_activation() TO service_role;

GRANT ALL ON FUNCTION public.track_media_activation() TO anon;

--

GRANT ALL ON FUNCTION public.trigger_cleanup_assignment_notifications() TO authenticated;

GRANT ALL ON FUNCTION public.trigger_cleanup_assignment_notifications() TO service_role;

GRANT ALL ON FUNCTION public.trigger_cleanup_assignment_notifications() TO anon;

--

GRANT ALL ON FUNCTION public.trigger_cleanup_task_notifications() TO authenticated;

GRANT ALL ON FUNCTION public.trigger_cleanup_task_notifications() TO service_role;

GRANT ALL ON FUNCTION public.trigger_cleanup_task_notifications() TO anon;

--

GRANT ALL ON FUNCTION public.trigger_log_order_offer_usage() TO authenticated;

GRANT ALL ON FUNCTION public.trigger_log_order_offer_usage() TO service_role;

GRANT ALL ON FUNCTION public.trigger_log_order_offer_usage() TO anon;

--

GRANT ALL ON FUNCTION public.trigger_notify_new_order() TO authenticated;

GRANT ALL ON FUNCTION public.trigger_notify_new_order() TO service_role;

GRANT ALL ON FUNCTION public.trigger_notify_new_order() TO anon;

--

GRANT ALL ON FUNCTION public.trigger_order_status_audit() TO authenticated;

GRANT ALL ON FUNCTION public.trigger_order_status_audit() TO service_role;

GRANT ALL ON FUNCTION public.trigger_order_status_audit() TO anon;

--

GRANT ALL ON FUNCTION public.trigger_sync_erp_reference_on_task_completion() TO authenticated;

GRANT ALL ON FUNCTION public.trigger_sync_erp_reference_on_task_completion() TO service_role;

GRANT ALL ON FUNCTION public.trigger_sync_erp_reference_on_task_completion() TO anon;

--

GRANT ALL ON FUNCTION public.trigger_update_order_totals() TO authenticated;

GRANT ALL ON FUNCTION public.trigger_update_order_totals() TO service_role;

GRANT ALL ON FUNCTION public.trigger_update_order_totals() TO anon;

--

GRANT ALL ON FUNCTION public.update_approval_permissions_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_approval_permissions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_approval_permissions_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_attendance_hours() TO authenticated;

GRANT ALL ON FUNCTION public.update_attendance_hours() TO service_role;

GRANT ALL ON FUNCTION public.update_attendance_hours() TO anon;

--

GRANT ALL ON FUNCTION public.update_bogo_offer_rules_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_bogo_offer_rules_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_bogo_offer_rules_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_box_operations_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_box_operations_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_box_operations_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_branch_sync_status(p_branch_id bigint, p_status text, p_details jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.update_branch_sync_status(p_branch_id bigint, p_status text, p_details jsonb) TO anon;

GRANT ALL ON FUNCTION public.update_branch_sync_status(p_branch_id bigint, p_status text, p_details jsonb) TO service_role;

--

GRANT ALL ON FUNCTION public.update_branches_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_branches_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_branches_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_coupon_campaigns_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_coupon_campaigns_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_coupon_campaigns_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_coupon_products_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_coupon_products_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_coupon_products_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_customer_app_media_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_customer_app_media_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_customer_app_media_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_customer_recovery_requests_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_customer_recovery_requests_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_customer_recovery_requests_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_customers_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_customers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_customers_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_day_off_reasons_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_day_off_reasons_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_day_off_reasons_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_day_off_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_day_off_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_day_off_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_day_off_weekday_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_day_off_weekday_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_day_off_weekday_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_deadline_datetime() TO authenticated;

GRANT ALL ON FUNCTION public.update_deadline_datetime() TO service_role;

GRANT ALL ON FUNCTION public.update_deadline_datetime() TO anon;

--

GRANT ALL ON FUNCTION public.update_delivery_tiers_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_delivery_tiers_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_delivery_tiers_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_denomination_transactions_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_denomination_transactions_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_denomination_transactions_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_denomination_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_denomination_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_denomination_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_departments_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_departments_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_departments_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_duty_schedule_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_duty_schedule_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_duty_schedule_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_early_leave_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_early_leave_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_early_leave_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_employee_positions_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_employee_positions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_employee_positions_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_erp_connections_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_erp_connections_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_erp_connections_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_erp_daily_sales_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_erp_daily_sales_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_erp_daily_sales_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_expense_categories_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_expense_categories_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_expense_categories_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_expense_parent_categories_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_expense_parent_categories_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_expense_parent_categories_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_expense_scheduler_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_expense_scheduler_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_expense_scheduler_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_final_bill_amount_on_adjustment() TO authenticated;

GRANT ALL ON FUNCTION public.update_final_bill_amount_on_adjustment() TO service_role;

GRANT ALL ON FUNCTION public.update_final_bill_amount_on_adjustment() TO anon;

--

GRANT ALL ON FUNCTION public.update_flyer_templates_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_flyer_templates_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_flyer_templates_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_hr_employee_master_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_hr_employee_master_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_hr_employee_master_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_interface_permissions_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_interface_permissions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_interface_permissions_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_issue_types_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_issue_types_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_issue_types_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_levels_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_levels_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_levels_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_main_document_columns() TO authenticated;

GRANT ALL ON FUNCTION public.update_main_document_columns() TO service_role;

GRANT ALL ON FUNCTION public.update_main_document_columns() TO anon;

--

GRANT ALL ON FUNCTION public.update_next_visit_date(visit_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.update_next_visit_date(visit_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.update_next_visit_date(visit_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.update_non_approved_scheduler_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_non_approved_scheduler_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_non_approved_scheduler_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_notification_attachments_flag() TO authenticated;

GRANT ALL ON FUNCTION public.update_notification_attachments_flag() TO service_role;

GRANT ALL ON FUNCTION public.update_notification_attachments_flag() TO anon;

--

GRANT ALL ON FUNCTION public.update_notification_delivery_status() TO authenticated;

GRANT ALL ON FUNCTION public.update_notification_delivery_status() TO service_role;

GRANT ALL ON FUNCTION public.update_notification_delivery_status() TO anon;

--

GRANT ALL ON FUNCTION public.update_notification_queue_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_notification_queue_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_notification_queue_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_notification_read_count() TO authenticated;

GRANT ALL ON FUNCTION public.update_notification_read_count() TO service_role;

GRANT ALL ON FUNCTION public.update_notification_read_count() TO anon;

--

GRANT ALL ON FUNCTION public.update_offer_cart_tiers_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_offer_cart_tiers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_offer_cart_tiers_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_offers_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_offers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_offers_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text) TO authenticated;

GRANT ALL ON FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text) TO service_role;

GRANT ALL ON FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text) TO anon;

--

GRANT ALL ON FUNCTION public.update_payment_transactions_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_payment_transactions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_payment_transactions_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_pos_deduction_transfers_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_pos_deduction_transfers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_pos_deduction_transfers_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_positions_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_positions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_positions_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_product_categories_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_product_categories_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_product_categories_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_product_units_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_product_units_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_product_units_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_products_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_products_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_products_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_purchase_voucher_items_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_purchase_voucher_items_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_purchase_voucher_items_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_purchase_vouchers_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_purchase_vouchers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_purchase_vouchers_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_push_subscriptions_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_push_subscriptions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_push_subscriptions_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_quick_task_completions_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_quick_task_completions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_quick_task_completions_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_quick_task_status() TO authenticated;

GRANT ALL ON FUNCTION public.update_quick_task_status() TO service_role;

GRANT ALL ON FUNCTION public.update_quick_task_status() TO anon;

--

GRANT ALL ON FUNCTION public.update_receiving_records_pr_excel_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_receiving_records_pr_excel_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_records_pr_excel_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_receiving_records_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_receiving_records_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_records_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_receiving_task_completion(receiving_task_id_param uuid, erp_reference_param character varying, original_bill_uploaded_param boolean, original_bill_file_path_param text) TO authenticated;

GRANT ALL ON FUNCTION public.update_receiving_task_completion(receiving_task_id_param uuid, erp_reference_param character varying, original_bill_uploaded_param boolean, original_bill_file_path_param text) TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_task_completion(receiving_task_id_param uuid, erp_reference_param character varying, original_bill_uploaded_param boolean, original_bill_file_path_param text) TO anon;

--

GRANT ALL ON FUNCTION public.update_receiving_task_templates_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_receiving_task_templates_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_task_templates_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_receiving_tasks_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_receiving_tasks_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_tasks_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_regular_shift_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_regular_shift_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_regular_shift_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_requisition_balance() TO authenticated;

GRANT ALL ON FUNCTION public.update_requisition_balance() TO service_role;

GRANT ALL ON FUNCTION public.update_requisition_balance() TO anon;

--

GRANT ALL ON FUNCTION public.update_requisition_balance_old() TO authenticated;

GRANT ALL ON FUNCTION public.update_requisition_balance_old() TO service_role;

GRANT ALL ON FUNCTION public.update_requisition_balance_old() TO anon;

--

GRANT ALL ON FUNCTION public.update_social_links_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_social_links_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_social_links_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_special_shift_date_wise_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_special_shift_date_wise_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_special_shift_date_wise_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_special_shift_weekday_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_special_shift_weekday_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_special_shift_weekday_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_stock_request_status(p_request_id uuid, p_new_status character varying) TO authenticated;

GRANT ALL ON FUNCTION public.update_stock_request_status(p_request_id uuid, p_new_status character varying) TO anon;

--

GRANT ALL ON FUNCTION public.update_tax_categories_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_tax_categories_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_tax_categories_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;

GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;

--

GRANT ALL ON FUNCTION public.update_user(p_user_id uuid, p_username character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_status character varying, p_avatar text) TO authenticated;

GRANT ALL ON FUNCTION public.update_user(p_user_id uuid, p_username character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_status character varying, p_avatar text) TO anon;

GRANT ALL ON FUNCTION public.update_user(p_user_id uuid, p_username character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_status character varying, p_avatar text) TO service_role;

--

GRANT ALL ON FUNCTION public.update_user_device_sessions_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_user_device_sessions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_user_device_sessions_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_vendor_payment_with_exact_calculation(payment_id uuid, new_discount_amount numeric, new_grr_amount numeric, new_pri_amount numeric, discount_notes_val text, grr_reference_val text, grr_notes_val text, pri_reference_val text, pri_notes_val text, history_val jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.update_vendor_payment_with_exact_calculation(payment_id uuid, new_discount_amount numeric, new_grr_amount numeric, new_pri_amount numeric, discount_notes_val text, grr_reference_val text, grr_notes_val text, pri_reference_val text, pri_notes_val text, history_val jsonb) TO service_role;

GRANT ALL ON FUNCTION public.update_vendor_payment_with_exact_calculation(payment_id uuid, new_discount_amount numeric, new_grr_amount numeric, new_pri_amount numeric, discount_notes_val text, grr_reference_val text, grr_notes_val text, pri_reference_val text, pri_notes_val text, history_val jsonb) TO anon;

--

GRANT ALL ON FUNCTION public.update_warning_main_category_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_warning_main_category_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_warning_main_category_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_warning_sub_category_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_warning_sub_category_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_warning_sub_category_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.update_warning_updated_at() TO authenticated;

GRANT ALL ON FUNCTION public.update_warning_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_warning_updated_at() TO anon;

--

GRANT ALL ON FUNCTION public.update_warning_violation_timestamp() TO authenticated;

GRANT ALL ON FUNCTION public.update_warning_violation_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_warning_violation_timestamp() TO anon;

--

GRANT ALL ON FUNCTION public.upsert_app_icon(p_icon_key text, p_name text, p_category text, p_storage_path text, p_mime_type text, p_file_size bigint, p_description text) TO authenticated;

--

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text) TO anon;

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text) TO authenticated;

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text) TO service_role;

--

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text, p_ssh_user text) TO authenticated;

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text, p_ssh_user text) TO anon;

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text, p_ssh_user text) TO service_role;

--

GRANT ALL ON FUNCTION public.upsert_social_links(_branch_id bigint, _facebook text, _whatsapp text, _instagram text, _tiktok text, _snapchat text, _website text, _location_link text) TO anon;

GRANT ALL ON FUNCTION public.upsert_social_links(_branch_id bigint, _facebook text, _whatsapp text, _instagram text, _tiktok text, _snapchat text, _website text, _location_link text) TO authenticated;

GRANT ALL ON FUNCTION public.upsert_social_links(_branch_id bigint, _facebook text, _whatsapp text, _instagram text, _tiktok text, _snapchat text, _website text, _location_link text) TO service_role;

--

GRANT ALL ON FUNCTION public.validate_break_code(p_code text) TO authenticated;

GRANT ALL ON FUNCTION public.validate_break_code(p_code text) TO anon;

--

GRANT ALL ON FUNCTION public.validate_bundle_offer_type() TO authenticated;

GRANT ALL ON FUNCTION public.validate_bundle_offer_type() TO service_role;

GRANT ALL ON FUNCTION public.validate_bundle_offer_type() TO anon;

--

GRANT ALL ON FUNCTION public.validate_coupon_eligibility(p_campaign_code character varying, p_mobile_number character varying) TO authenticated;

GRANT ALL ON FUNCTION public.validate_coupon_eligibility(p_campaign_code character varying, p_mobile_number character varying) TO service_role;

GRANT ALL ON FUNCTION public.validate_coupon_eligibility(p_campaign_code character varying, p_mobile_number character varying) TO anon;

--

GRANT ALL ON FUNCTION public.validate_flyer_template_configuration(config jsonb) TO authenticated;

GRANT ALL ON FUNCTION public.validate_flyer_template_configuration(config jsonb) TO service_role;

GRANT ALL ON FUNCTION public.validate_flyer_template_configuration(config jsonb) TO anon;

--

GRANT ALL ON FUNCTION public.validate_payment_methods(payment_methods text) TO authenticated;

GRANT ALL ON FUNCTION public.validate_payment_methods(payment_methods text) TO service_role;

GRANT ALL ON FUNCTION public.validate_payment_methods(payment_methods text) TO anon;

--

GRANT ALL ON FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) TO authenticated;

GRANT ALL ON FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) TO service_role;

GRANT ALL ON FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) TO anon;

--

GRANT ALL ON FUNCTION public.validate_task_completion_requirements(receiving_task_id_param uuid, user_id_param uuid) TO authenticated;

GRANT ALL ON FUNCTION public.validate_task_completion_requirements(receiving_task_id_param uuid, user_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.validate_task_completion_requirements(receiving_task_id_param uuid, user_id_param uuid) TO anon;

--

GRANT ALL ON FUNCTION public.validate_variation_prices(p_offer_id integer, p_group_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.validate_variation_prices(p_offer_id integer, p_group_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.validate_variation_prices(p_offer_id integer, p_group_id uuid) TO anon;

--

GRANT ALL ON FUNCTION public.validate_vendor_branch_match() TO authenticated;

GRANT ALL ON FUNCTION public.validate_vendor_branch_match() TO service_role;

GRANT ALL ON FUNCTION public.validate_vendor_branch_match() TO anon;

--

GRANT ALL ON FUNCTION public.verify_otp_and_change_access_code(p_email character varying, p_whatsapp character varying, p_otp character varying, p_new_code character varying) TO authenticated;

GRANT ALL ON FUNCTION public.verify_otp_and_change_access_code(p_email character varying, p_whatsapp character varying, p_otp character varying, p_new_code character varying) TO anon;

GRANT ALL ON FUNCTION public.verify_otp_and_change_access_code(p_email character varying, p_whatsapp character varying, p_otp character varying, p_new_code character varying) TO service_role;

--

GRANT ALL ON FUNCTION public.verify_password(password text, hash text) TO authenticated;

GRANT ALL ON FUNCTION public.verify_password(password text, hash text) TO service_role;

GRANT ALL ON FUNCTION public.verify_password(password text, hash text) TO anon;

--

GRANT ALL ON FUNCTION public.verify_password(input_username character varying, input_password character varying) TO authenticated;

GRANT ALL ON FUNCTION public.verify_password(input_username character varying, input_password character varying) TO service_role;

GRANT ALL ON FUNCTION public.verify_password(input_username character varying, input_password character varying) TO anon;

--

GRANT ALL ON FUNCTION public.verify_quick_access_code(p_code character varying) TO authenticated;

GRANT ALL ON FUNCTION public.verify_quick_access_code(p_code character varying) TO anon;

GRANT ALL ON FUNCTION public.verify_quick_access_code(p_code character varying) TO service_role;

--

GRANT ALL ON FUNCTION public.verify_quick_task_completion(completion_id_param uuid, verified_by_user_id_param uuid, verification_notes_param text, is_approved boolean) TO authenticated;

GRANT ALL ON FUNCTION public.verify_quick_task_completion(completion_id_param uuid, verified_by_user_id_param uuid, verification_notes_param text, is_approved boolean) TO service_role;

GRANT ALL ON FUNCTION public.verify_quick_task_completion(completion_id_param uuid, verified_by_user_id_param uuid, verification_notes_param text, is_approved boolean) TO anon;

--

GRANT SELECT ON TABLE public.access_code_otp TO anon;

GRANT SELECT ON TABLE public.access_code_otp TO authenticated;

GRANT ALL ON TABLE public.access_code_otp TO service_role;

GRANT SELECT ON TABLE public.access_code_otp TO replication_user;

--

GRANT ALL ON TABLE public.ai_chat_guide TO anon;

GRANT ALL ON TABLE public.ai_chat_guide TO authenticated;

GRANT ALL ON TABLE public.ai_chat_guide TO service_role;

GRANT SELECT ON TABLE public.ai_chat_guide TO replication_user;

--

GRANT ALL ON SEQUENCE public.ai_chat_guide_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.ai_chat_guide_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.ai_chat_guide_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.ai_chat_guide_id_seq TO replication_user;

--

GRANT SELECT ON TABLE public.app_icons TO anon;

GRANT SELECT ON TABLE public.app_icons TO authenticated;

GRANT ALL ON TABLE public.app_icons TO service_role;

GRANT SELECT ON TABLE public.app_icons TO replication_user;

--

GRANT ALL ON TABLE public.approval_permissions TO anon;

GRANT ALL ON TABLE public.approval_permissions TO authenticated;

GRANT ALL ON TABLE public.approval_permissions TO service_role;

GRANT SELECT ON TABLE public.approval_permissions TO replication_user;

--

GRANT ALL ON SEQUENCE public.approval_permissions_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.approval_permissions_id_seq TO anon;

GRANT ALL ON SEQUENCE public.approval_permissions_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.approval_permissions_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.approver_branch_access TO anon;

GRANT ALL ON TABLE public.approver_branch_access TO authenticated;

GRANT ALL ON TABLE public.approver_branch_access TO service_role;

GRANT SELECT ON TABLE public.approver_branch_access TO replication_user;

--

GRANT ALL ON SEQUENCE public.approver_branch_access_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.approver_branch_access_id_seq TO anon;

GRANT ALL ON SEQUENCE public.approver_branch_access_id_seq TO authenticated;

--

GRANT ALL ON TABLE public.approver_visibility_config TO anon;

GRANT ALL ON TABLE public.approver_visibility_config TO authenticated;

GRANT ALL ON TABLE public.approver_visibility_config TO service_role;

GRANT SELECT ON TABLE public.approver_visibility_config TO replication_user;

--

GRANT ALL ON SEQUENCE public.approver_visibility_config_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.approver_visibility_config_id_seq TO anon;

GRANT ALL ON SEQUENCE public.approver_visibility_config_id_seq TO authenticated;

--

GRANT ALL ON TABLE public.asset_main_categories TO anon;

GRANT ALL ON TABLE public.asset_main_categories TO authenticated;

GRANT ALL ON TABLE public.asset_main_categories TO service_role;

GRANT SELECT ON TABLE public.asset_main_categories TO replication_user;

--

GRANT ALL ON SEQUENCE public.asset_main_categories_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.asset_main_categories_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.asset_main_categories_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.asset_main_categories_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.asset_sub_categories TO anon;

GRANT ALL ON TABLE public.asset_sub_categories TO authenticated;

GRANT ALL ON TABLE public.asset_sub_categories TO service_role;

GRANT SELECT ON TABLE public.asset_sub_categories TO replication_user;

--

GRANT ALL ON SEQUENCE public.asset_sub_categories_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.asset_sub_categories_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.asset_sub_categories_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.asset_sub_categories_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.assets TO anon;

GRANT ALL ON TABLE public.assets TO authenticated;

GRANT ALL ON TABLE public.assets TO service_role;

GRANT SELECT ON TABLE public.assets TO replication_user;

--

GRANT ALL ON SEQUENCE public.assets_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.assets_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.assets_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.assets_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.bank_reconciliations TO anon;

GRANT ALL ON TABLE public.bank_reconciliations TO authenticated;

GRANT ALL ON TABLE public.bank_reconciliations TO service_role;

GRANT SELECT ON TABLE public.bank_reconciliations TO replication_user;

--

GRANT ALL ON SEQUENCE public.bank_reconciliations_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.bank_reconciliations_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.bank_reconciliations_id_seq TO anon;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.biometric_connections TO anon;

GRANT SELECT ON TABLE public.biometric_connections TO authenticated;

GRANT ALL ON TABLE public.biometric_connections TO service_role;

GRANT SELECT ON TABLE public.biometric_connections TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.bogo_offer_rules TO anon;

GRANT SELECT ON TABLE public.bogo_offer_rules TO authenticated;

GRANT ALL ON TABLE public.bogo_offer_rules TO service_role;

GRANT SELECT ON TABLE public.bogo_offer_rules TO replication_user;

--

GRANT ALL ON SEQUENCE public.bogo_offer_rules_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.bogo_offer_rules_id_seq TO anon;

GRANT ALL ON SEQUENCE public.bogo_offer_rules_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.bogo_offer_rules_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.box_operations TO anon;

GRANT ALL ON TABLE public.box_operations TO authenticated;

GRANT ALL ON TABLE public.box_operations TO service_role;

GRANT SELECT ON TABLE public.box_operations TO replication_user;

--

GRANT ALL ON TABLE public.branch_default_delivery_receivers TO anon;

GRANT ALL ON TABLE public.branch_default_delivery_receivers TO authenticated;

GRANT ALL ON TABLE public.branch_default_delivery_receivers TO service_role;

GRANT SELECT ON TABLE public.branch_default_delivery_receivers TO replication_user;

--

GRANT ALL ON TABLE public.branch_default_positions TO anon;

GRANT ALL ON TABLE public.branch_default_positions TO authenticated;

GRANT ALL ON TABLE public.branch_default_positions TO service_role;

GRANT SELECT ON TABLE public.branch_default_positions TO replication_user;

--

GRANT SELECT ON TABLE public.branch_sync_config TO anon;

GRANT SELECT ON TABLE public.branch_sync_config TO authenticated;

GRANT ALL ON TABLE public.branch_sync_config TO service_role;

GRANT SELECT ON TABLE public.branch_sync_config TO replication_user;

--

GRANT ALL ON SEQUENCE public.branch_sync_config_id_seq TO service_role;

GRANT SELECT ON SEQUENCE public.branch_sync_config_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.branches TO anon;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.branches TO authenticated;

GRANT ALL ON TABLE public.branches TO service_role;

GRANT SELECT ON TABLE public.branches TO replication_user;

--

GRANT ALL ON SEQUENCE public.branches_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.branches_id_seq TO anon;

GRANT ALL ON SEQUENCE public.branches_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.branches_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.break_reasons TO anon;

GRANT ALL ON TABLE public.break_reasons TO authenticated;

GRANT ALL ON TABLE public.break_reasons TO service_role;

GRANT SELECT ON TABLE public.break_reasons TO replication_user;

--

GRANT ALL ON SEQUENCE public.break_reasons_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.break_reasons_id_seq TO authenticated;

--

GRANT ALL ON TABLE public.break_register TO anon;

GRANT ALL ON TABLE public.break_register TO authenticated;

GRANT ALL ON TABLE public.break_register TO service_role;

GRANT SELECT ON TABLE public.break_register TO replication_user;

--

GRANT SELECT ON TABLE public.break_security_seed TO anon;

GRANT SELECT ON TABLE public.break_security_seed TO authenticated;

GRANT ALL ON TABLE public.break_security_seed TO service_role;

GRANT SELECT ON TABLE public.break_security_seed TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.button_main_sections TO anon;

GRANT SELECT ON TABLE public.button_main_sections TO authenticated;

GRANT ALL ON TABLE public.button_main_sections TO service_role;

GRANT SELECT ON TABLE public.button_main_sections TO replication_user;

--

GRANT ALL ON SEQUENCE public.button_main_sections_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.button_main_sections_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.button_main_sections_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.button_main_sections_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.button_permissions TO anon;

GRANT SELECT ON TABLE public.button_permissions TO authenticated;

GRANT ALL ON TABLE public.button_permissions TO service_role;

GRANT SELECT ON TABLE public.button_permissions TO replication_user;

--

GRANT ALL ON SEQUENCE public.button_permissions_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.button_permissions_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.button_permissions_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.button_permissions_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.button_sub_sections TO anon;

GRANT SELECT ON TABLE public.button_sub_sections TO authenticated;

GRANT ALL ON TABLE public.button_sub_sections TO service_role;

GRANT SELECT ON TABLE public.button_sub_sections TO replication_user;

--

GRANT ALL ON SEQUENCE public.button_sub_sections_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.button_sub_sections_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.button_sub_sections_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.button_sub_sections_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.coupon_campaigns TO anon;

GRANT SELECT ON TABLE public.coupon_campaigns TO authenticated;

GRANT ALL ON TABLE public.coupon_campaigns TO service_role;

GRANT SELECT ON TABLE public.coupon_campaigns TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.coupon_claims TO anon;

GRANT SELECT ON TABLE public.coupon_claims TO authenticated;

GRANT ALL ON TABLE public.coupon_claims TO service_role;

GRANT SELECT ON TABLE public.coupon_claims TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.coupon_eligible_customers TO anon;

GRANT SELECT ON TABLE public.coupon_eligible_customers TO authenticated;

GRANT ALL ON TABLE public.coupon_eligible_customers TO service_role;

GRANT SELECT ON TABLE public.coupon_eligible_customers TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.coupon_products TO anon;

GRANT SELECT ON TABLE public.coupon_products TO authenticated;

GRANT ALL ON TABLE public.coupon_products TO service_role;

GRANT SELECT ON TABLE public.coupon_products TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer_access_code_history TO anon;

GRANT SELECT ON TABLE public.customer_access_code_history TO authenticated;

GRANT ALL ON TABLE public.customer_access_code_history TO service_role;

GRANT SELECT ON TABLE public.customer_access_code_history TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer_app_media TO anon;

GRANT SELECT ON TABLE public.customer_app_media TO authenticated;

GRANT ALL ON TABLE public.customer_app_media TO service_role;

GRANT SELECT ON TABLE public.customer_app_media TO replication_user;

--

GRANT ALL ON TABLE public.customer_product_requests TO anon;

GRANT ALL ON TABLE public.customer_product_requests TO authenticated;

GRANT ALL ON TABLE public.customer_product_requests TO service_role;

GRANT SELECT ON TABLE public.customer_product_requests TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer_recovery_requests TO anon;

GRANT SELECT ON TABLE public.customer_recovery_requests TO authenticated;

GRANT ALL ON TABLE public.customer_recovery_requests TO service_role;

GRANT SELECT ON TABLE public.customer_recovery_requests TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customers TO anon;

GRANT SELECT ON TABLE public.customers TO authenticated;

GRANT ALL ON TABLE public.customers TO service_role;

GRANT SELECT ON TABLE public.customers TO replication_user;

--

GRANT ALL ON TABLE public.day_off TO anon;

GRANT ALL ON TABLE public.day_off TO authenticated;

GRANT ALL ON TABLE public.day_off TO service_role;

GRANT SELECT ON TABLE public.day_off TO replication_user;

--

GRANT ALL ON TABLE public.day_off_reasons TO anon;

GRANT ALL ON TABLE public.day_off_reasons TO authenticated;

GRANT ALL ON TABLE public.day_off_reasons TO service_role;

GRANT SELECT ON TABLE public.day_off_reasons TO replication_user;

--

GRANT ALL ON TABLE public.day_off_weekday TO anon;

GRANT ALL ON TABLE public.day_off_weekday TO authenticated;

GRANT ALL ON TABLE public.day_off_weekday TO service_role;

GRANT SELECT ON TABLE public.day_off_weekday TO replication_user;

--

GRANT ALL ON TABLE public.default_incident_users TO anon;

GRANT ALL ON TABLE public.default_incident_users TO authenticated;

GRANT ALL ON TABLE public.default_incident_users TO service_role;

GRANT SELECT ON TABLE public.default_incident_users TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.deleted_bundle_offers TO anon;

GRANT SELECT ON TABLE public.deleted_bundle_offers TO authenticated;

GRANT ALL ON TABLE public.deleted_bundle_offers TO service_role;

GRANT SELECT ON TABLE public.deleted_bundle_offers TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.delivery_fee_tiers TO anon;

GRANT SELECT ON TABLE public.delivery_fee_tiers TO authenticated;

GRANT ALL ON TABLE public.delivery_fee_tiers TO service_role;

GRANT SELECT ON TABLE public.delivery_fee_tiers TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.delivery_service_settings TO anon;

GRANT SELECT ON TABLE public.delivery_service_settings TO authenticated;

GRANT ALL ON TABLE public.delivery_service_settings TO service_role;

GRANT SELECT ON TABLE public.delivery_service_settings TO replication_user;

--

GRANT ALL ON TABLE public.denomination_audit_log TO anon;

GRANT ALL ON TABLE public.denomination_audit_log TO authenticated;

GRANT ALL ON TABLE public.denomination_audit_log TO service_role;

GRANT SELECT ON TABLE public.denomination_audit_log TO replication_user;

--

GRANT ALL ON TABLE public.denomination_records TO anon;

GRANT ALL ON TABLE public.denomination_records TO authenticated;

GRANT ALL ON TABLE public.denomination_records TO service_role;

GRANT SELECT ON TABLE public.denomination_records TO replication_user;

--

GRANT ALL ON TABLE public.denomination_transactions TO anon;

GRANT ALL ON TABLE public.denomination_transactions TO authenticated;

GRANT ALL ON TABLE public.denomination_transactions TO service_role;

GRANT SELECT ON TABLE public.denomination_transactions TO replication_user;

--

GRANT ALL ON TABLE public.denomination_types TO anon;

GRANT ALL ON TABLE public.denomination_types TO authenticated;

GRANT ALL ON TABLE public.denomination_types TO service_role;

GRANT SELECT ON TABLE public.denomination_types TO replication_user;

--

GRANT ALL ON SEQUENCE public.denomination_types_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.denomination_types_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.denomination_types_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.denomination_types_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.denomination_user_preferences TO anon;

GRANT ALL ON TABLE public.denomination_user_preferences TO authenticated;

GRANT ALL ON TABLE public.denomination_user_preferences TO service_role;

GRANT SELECT ON TABLE public.denomination_user_preferences TO replication_user;

--

GRANT ALL ON TABLE public.desktop_themes TO anon;

GRANT ALL ON TABLE public.desktop_themes TO authenticated;

GRANT ALL ON TABLE public.desktop_themes TO service_role;

GRANT SELECT ON TABLE public.desktop_themes TO replication_user;

--

GRANT ALL ON SEQUENCE public.desktop_themes_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.desktop_themes_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.desktop_themes_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.desktop_themes_id_seq TO replication_user;

--

GRANT SELECT ON TABLE public.edge_functions_cache TO anon;

GRANT SELECT ON TABLE public.edge_functions_cache TO authenticated;

GRANT ALL ON TABLE public.edge_functions_cache TO service_role;

GRANT SELECT ON TABLE public.edge_functions_cache TO replication_user;

--

GRANT ALL ON TABLE public.employee_checklist_assignments TO anon;

GRANT ALL ON TABLE public.employee_checklist_assignments TO authenticated;

GRANT ALL ON TABLE public.employee_checklist_assignments TO service_role;

GRANT SELECT ON TABLE public.employee_checklist_assignments TO replication_user;

--

GRANT ALL ON SEQUENCE public.employee_checklist_assignments_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.employee_checklist_assignments_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.employee_checklist_assignments_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.employee_fine_payments TO anon;

GRANT SELECT ON TABLE public.employee_fine_payments TO authenticated;

GRANT ALL ON TABLE public.employee_fine_payments TO service_role;

GRANT SELECT ON TABLE public.employee_fine_payments TO replication_user;

--

GRANT ALL ON TABLE public.employee_official_holidays TO anon;

GRANT ALL ON TABLE public.employee_official_holidays TO authenticated;

GRANT ALL ON TABLE public.employee_official_holidays TO service_role;

GRANT SELECT ON TABLE public.employee_official_holidays TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.erp_connections TO anon;

GRANT SELECT ON TABLE public.erp_connections TO authenticated;

GRANT ALL ON TABLE public.erp_connections TO service_role;

GRANT SELECT ON TABLE public.erp_connections TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.erp_daily_sales TO anon;

GRANT SELECT ON TABLE public.erp_daily_sales TO authenticated;

GRANT ALL ON TABLE public.erp_daily_sales TO service_role;

GRANT SELECT ON TABLE public.erp_daily_sales TO replication_user;

--

GRANT SELECT ON TABLE public.erp_sync_logs TO anon;

GRANT SELECT ON TABLE public.erp_sync_logs TO authenticated;

GRANT ALL ON TABLE public.erp_sync_logs TO service_role;

GRANT SELECT ON TABLE public.erp_sync_logs TO replication_user;

--

GRANT ALL ON SEQUENCE public.erp_sync_logs_id_seq TO service_role;

GRANT SELECT ON SEQUENCE public.erp_sync_logs_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.erp_synced_products TO anon;

GRANT ALL ON TABLE public.erp_synced_products TO authenticated;

GRANT ALL ON TABLE public.erp_synced_products TO service_role;

GRANT SELECT ON TABLE public.erp_synced_products TO replication_user;

--

GRANT ALL ON SEQUENCE public.erp_synced_products_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.erp_synced_products_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.erp_synced_products_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.erp_synced_products_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.expense_parent_categories TO anon;

GRANT SELECT ON TABLE public.expense_parent_categories TO authenticated;

GRANT ALL ON TABLE public.expense_parent_categories TO service_role;

GRANT SELECT ON TABLE public.expense_parent_categories TO replication_user;

--

GRANT ALL ON SEQUENCE public.expense_parent_categories_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.expense_parent_categories_id_seq TO anon;

GRANT ALL ON SEQUENCE public.expense_parent_categories_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.expense_parent_categories_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.expense_requisitions TO anon;

GRANT SELECT ON TABLE public.expense_requisitions TO authenticated;

GRANT ALL ON TABLE public.expense_requisitions TO service_role;

GRANT SELECT ON TABLE public.expense_requisitions TO replication_user;

--

GRANT ALL ON SEQUENCE public.expense_requisitions_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.expense_requisitions_id_seq TO anon;

GRANT ALL ON SEQUENCE public.expense_requisitions_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.expense_requisitions_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.expense_scheduler TO anon;

GRANT SELECT ON TABLE public.expense_scheduler TO authenticated;

GRANT ALL ON TABLE public.expense_scheduler TO service_role;

GRANT SELECT ON TABLE public.expense_scheduler TO replication_user;

--

GRANT ALL ON SEQUENCE public.expense_scheduler_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.expense_scheduler_id_seq TO anon;

GRANT ALL ON SEQUENCE public.expense_scheduler_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.expense_scheduler_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.expense_sub_categories TO anon;

GRANT SELECT ON TABLE public.expense_sub_categories TO authenticated;

GRANT ALL ON TABLE public.expense_sub_categories TO service_role;

GRANT SELECT ON TABLE public.expense_sub_categories TO replication_user;

--

GRANT ALL ON SEQUENCE public.expense_sub_categories_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.expense_sub_categories_id_seq TO anon;

GRANT ALL ON SEQUENCE public.expense_sub_categories_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.expense_sub_categories_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.flyer_offer_products TO anon;

GRANT SELECT ON TABLE public.flyer_offer_products TO authenticated;

GRANT ALL ON TABLE public.flyer_offer_products TO service_role;

GRANT SELECT ON TABLE public.flyer_offer_products TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.flyer_offers TO anon;

GRANT SELECT ON TABLE public.flyer_offers TO authenticated;

GRANT ALL ON TABLE public.flyer_offers TO service_role;

GRANT SELECT ON TABLE public.flyer_offers TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.flyer_templates TO anon;

GRANT SELECT ON TABLE public.flyer_templates TO authenticated;

GRANT ALL ON TABLE public.flyer_templates TO service_role;

GRANT SELECT ON TABLE public.flyer_templates TO replication_user;

--

GRANT SELECT ON TABLE public.frontend_builds TO anon;

GRANT SELECT,INSERT ON TABLE public.frontend_builds TO authenticated;

GRANT ALL ON TABLE public.frontend_builds TO service_role;

GRANT SELECT ON TABLE public.frontend_builds TO replication_user;

--

GRANT ALL ON SEQUENCE public.frontend_builds_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.frontend_builds_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.frontend_builds_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.hr_analysed_attendance_data TO anon;

GRANT ALL ON TABLE public.hr_analysed_attendance_data TO authenticated;

GRANT ALL ON TABLE public.hr_analysed_attendance_data TO service_role;

GRANT SELECT ON TABLE public.hr_analysed_attendance_data TO replication_user;

--

GRANT ALL ON SEQUENCE public.hr_analysed_attendance_data_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.hr_analysed_attendance_data_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.hr_analysed_attendance_data_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.hr_analysed_attendance_data_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.hr_basic_salary TO anon;

GRANT ALL ON TABLE public.hr_basic_salary TO authenticated;

GRANT ALL ON TABLE public.hr_basic_salary TO service_role;

GRANT SELECT ON TABLE public.hr_basic_salary TO replication_user;

--

GRANT ALL ON SEQUENCE public.hr_checklist_operations_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklist_operations_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklist_operations_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.hr_checklist_operations_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.hr_checklist_operations TO anon;

GRANT ALL ON TABLE public.hr_checklist_operations TO authenticated;

GRANT ALL ON TABLE public.hr_checklist_operations TO service_role;

GRANT SELECT ON TABLE public.hr_checklist_operations TO replication_user;

--

GRANT ALL ON SEQUENCE public.hr_checklist_questions_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklist_questions_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklist_questions_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.hr_checklist_questions_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.hr_checklist_questions TO anon;

GRANT ALL ON TABLE public.hr_checklist_questions TO authenticated;

GRANT ALL ON TABLE public.hr_checklist_questions TO service_role;

GRANT SELECT ON TABLE public.hr_checklist_questions TO replication_user;

--

GRANT ALL ON SEQUENCE public.hr_checklists_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklists_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklists_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.hr_checklists_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.hr_checklists TO anon;

GRANT ALL ON TABLE public.hr_checklists TO authenticated;

GRANT ALL ON TABLE public.hr_checklists TO service_role;

GRANT SELECT ON TABLE public.hr_checklists TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_departments TO anon;

GRANT SELECT ON TABLE public.hr_departments TO authenticated;

GRANT ALL ON TABLE public.hr_departments TO service_role;

GRANT SELECT ON TABLE public.hr_departments TO replication_user;

--

GRANT ALL ON TABLE public.hr_employee_master TO anon;

GRANT ALL ON TABLE public.hr_employee_master TO authenticated;

GRANT ALL ON TABLE public.hr_employee_master TO service_role;

GRANT SELECT ON TABLE public.hr_employee_master TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_employees TO anon;

GRANT SELECT ON TABLE public.hr_employees TO authenticated;

GRANT ALL ON TABLE public.hr_employees TO service_role;

GRANT SELECT ON TABLE public.hr_employees TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_fingerprint_transactions TO anon;

GRANT SELECT ON TABLE public.hr_fingerprint_transactions TO authenticated;

GRANT ALL ON TABLE public.hr_fingerprint_transactions TO service_role;

GRANT SELECT ON TABLE public.hr_fingerprint_transactions TO replication_user;

--

GRANT ALL ON TABLE public.hr_insurance_companies TO anon;

GRANT ALL ON TABLE public.hr_insurance_companies TO authenticated;

GRANT ALL ON TABLE public.hr_insurance_companies TO service_role;

GRANT SELECT ON TABLE public.hr_insurance_companies TO replication_user;

--

GRANT ALL ON SEQUENCE public.hr_insurance_company_id_seq TO service_role;

GRANT SELECT ON SEQUENCE public.hr_insurance_company_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_levels TO anon;

GRANT SELECT ON TABLE public.hr_levels TO authenticated;

GRANT ALL ON TABLE public.hr_levels TO service_role;

GRANT SELECT ON TABLE public.hr_levels TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_position_assignments TO anon;

GRANT SELECT ON TABLE public.hr_position_assignments TO authenticated;

GRANT ALL ON TABLE public.hr_position_assignments TO service_role;

GRANT SELECT ON TABLE public.hr_position_assignments TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_position_reporting_template TO anon;

GRANT SELECT ON TABLE public.hr_position_reporting_template TO authenticated;

GRANT ALL ON TABLE public.hr_position_reporting_template TO service_role;

GRANT SELECT ON TABLE public.hr_position_reporting_template TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.hr_positions TO anon;

GRANT SELECT ON TABLE public.hr_positions TO authenticated;

GRANT ALL ON TABLE public.hr_positions TO service_role;

GRANT SELECT ON TABLE public.hr_positions TO replication_user;

--

GRANT ALL ON SEQUENCE public.incident_actions_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.incident_actions_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.incident_actions_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.incident_actions_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.incident_actions TO anon;

GRANT ALL ON TABLE public.incident_actions TO authenticated;

GRANT ALL ON TABLE public.incident_actions TO service_role;

GRANT SELECT ON TABLE public.incident_actions TO replication_user;

--

GRANT ALL ON TABLE public.incident_types TO anon;

GRANT ALL ON TABLE public.incident_types TO authenticated;

GRANT ALL ON TABLE public.incident_types TO service_role;

GRANT SELECT ON TABLE public.incident_types TO replication_user;

--

GRANT ALL ON TABLE public.incidents TO anon;

GRANT ALL ON TABLE public.incidents TO authenticated;

GRANT ALL ON TABLE public.incidents TO service_role;

GRANT SELECT ON TABLE public.incidents TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.interface_permissions TO anon;

GRANT SELECT ON TABLE public.interface_permissions TO authenticated;

GRANT ALL ON TABLE public.interface_permissions TO service_role;

GRANT SELECT ON TABLE public.interface_permissions TO replication_user;

--

GRANT ALL ON TABLE public.lease_rent_lease_parties TO anon;

GRANT ALL ON TABLE public.lease_rent_lease_parties TO authenticated;

GRANT ALL ON TABLE public.lease_rent_lease_parties TO service_role;

GRANT SELECT ON TABLE public.lease_rent_lease_parties TO replication_user;

--

GRANT ALL ON TABLE public.lease_rent_payment_entries TO anon;

GRANT ALL ON TABLE public.lease_rent_payment_entries TO authenticated;

GRANT ALL ON TABLE public.lease_rent_payment_entries TO service_role;

GRANT SELECT ON TABLE public.lease_rent_payment_entries TO replication_user;

--

GRANT ALL ON TABLE public.lease_rent_payments TO anon;

GRANT ALL ON TABLE public.lease_rent_payments TO authenticated;

GRANT ALL ON TABLE public.lease_rent_payments TO service_role;

GRANT SELECT ON TABLE public.lease_rent_payments TO replication_user;

--

GRANT ALL ON TABLE public.lease_rent_properties TO anon;

GRANT ALL ON TABLE public.lease_rent_properties TO authenticated;

GRANT ALL ON TABLE public.lease_rent_properties TO service_role;

GRANT SELECT ON TABLE public.lease_rent_properties TO replication_user;

--

GRANT ALL ON TABLE public.lease_rent_property_spaces TO anon;

GRANT ALL ON TABLE public.lease_rent_property_spaces TO authenticated;

GRANT ALL ON TABLE public.lease_rent_property_spaces TO service_role;

GRANT SELECT ON TABLE public.lease_rent_property_spaces TO replication_user;

--

GRANT ALL ON TABLE public.lease_rent_rent_parties TO anon;

GRANT ALL ON TABLE public.lease_rent_rent_parties TO authenticated;

GRANT ALL ON TABLE public.lease_rent_rent_parties TO service_role;

GRANT SELECT ON TABLE public.lease_rent_rent_parties TO replication_user;

--

GRANT ALL ON TABLE public.lease_rent_special_changes TO anon;

GRANT ALL ON TABLE public.lease_rent_special_changes TO authenticated;

GRANT ALL ON TABLE public.lease_rent_special_changes TO service_role;

GRANT SELECT ON TABLE public.lease_rent_special_changes TO replication_user;

--

GRANT ALL ON TABLE public.mobile_themes TO anon;

GRANT ALL ON TABLE public.mobile_themes TO authenticated;

GRANT ALL ON TABLE public.mobile_themes TO service_role;

GRANT SELECT ON TABLE public.mobile_themes TO replication_user;

--

GRANT ALL ON SEQUENCE public.mobile_themes_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.mobile_themes_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.mobile_themes_id_seq TO anon;

--

GRANT ALL ON TABLE public.multi_shift_date_wise TO anon;

GRANT ALL ON TABLE public.multi_shift_date_wise TO authenticated;

GRANT ALL ON TABLE public.multi_shift_date_wise TO service_role;

GRANT SELECT ON TABLE public.multi_shift_date_wise TO replication_user;

--

GRANT ALL ON SEQUENCE public.multi_shift_date_wise_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_date_wise_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_date_wise_id_seq TO anon;

--

GRANT ALL ON TABLE public.multi_shift_regular TO anon;

GRANT ALL ON TABLE public.multi_shift_regular TO authenticated;

GRANT ALL ON TABLE public.multi_shift_regular TO service_role;

GRANT SELECT ON TABLE public.multi_shift_regular TO replication_user;

--

GRANT ALL ON SEQUENCE public.multi_shift_regular_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_regular_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_regular_id_seq TO anon;

--

GRANT ALL ON TABLE public.multi_shift_weekday TO anon;

GRANT ALL ON TABLE public.multi_shift_weekday TO authenticated;

GRANT ALL ON TABLE public.multi_shift_weekday TO service_role;

GRANT SELECT ON TABLE public.multi_shift_weekday TO replication_user;

--

GRANT ALL ON SEQUENCE public.multi_shift_weekday_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_weekday_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_weekday_id_seq TO anon;

--

GRANT SELECT ON TABLE public.mv_expiry_products TO anon;

GRANT SELECT ON TABLE public.mv_expiry_products TO authenticated;

GRANT ALL ON TABLE public.mv_expiry_products TO service_role;

GRANT SELECT ON TABLE public.mv_expiry_products TO replication_user;

--

GRANT ALL ON TABLE public.nationalities TO anon;

GRANT ALL ON TABLE public.nationalities TO authenticated;

GRANT ALL ON TABLE public.nationalities TO service_role;

GRANT SELECT ON TABLE public.nationalities TO replication_user;

--

GRANT ALL ON TABLE public.near_expiry_reports TO anon;

GRANT ALL ON TABLE public.near_expiry_reports TO authenticated;

GRANT ALL ON TABLE public.near_expiry_reports TO service_role;

GRANT SELECT ON TABLE public.near_expiry_reports TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.non_approved_payment_scheduler TO anon;

GRANT SELECT ON TABLE public.non_approved_payment_scheduler TO authenticated;

GRANT ALL ON TABLE public.non_approved_payment_scheduler TO service_role;

GRANT SELECT ON TABLE public.non_approved_payment_scheduler TO replication_user;

--

GRANT ALL ON SEQUENCE public.non_approved_payment_scheduler_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.non_approved_payment_scheduler_id_seq TO anon;

GRANT ALL ON SEQUENCE public.non_approved_payment_scheduler_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.non_approved_payment_scheduler_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.notification_attachments TO anon;

GRANT SELECT ON TABLE public.notification_attachments TO authenticated;

GRANT ALL ON TABLE public.notification_attachments TO service_role;

GRANT SELECT ON TABLE public.notification_attachments TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.notification_read_states TO anon;

GRANT SELECT ON TABLE public.notification_read_states TO authenticated;

GRANT ALL ON TABLE public.notification_read_states TO service_role;

GRANT SELECT ON TABLE public.notification_read_states TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.notification_recipients TO anon;

GRANT SELECT ON TABLE public.notification_recipients TO authenticated;

GRANT ALL ON TABLE public.notification_recipients TO service_role;

GRANT SELECT ON TABLE public.notification_recipients TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.notifications TO anon;

GRANT SELECT ON TABLE public.notifications TO authenticated;

GRANT ALL ON TABLE public.notifications TO service_role;

GRANT SELECT ON TABLE public.notifications TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.offer_bundles TO anon;

GRANT SELECT ON TABLE public.offer_bundles TO authenticated;

GRANT ALL ON TABLE public.offer_bundles TO service_role;

GRANT SELECT ON TABLE public.offer_bundles TO replication_user;

--

GRANT ALL ON SEQUENCE public.offer_bundles_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.offer_bundles_id_seq TO anon;

GRANT ALL ON SEQUENCE public.offer_bundles_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.offer_bundles_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.offer_cart_tiers TO anon;

GRANT SELECT ON TABLE public.offer_cart_tiers TO authenticated;

GRANT ALL ON TABLE public.offer_cart_tiers TO service_role;

GRANT SELECT ON TABLE public.offer_cart_tiers TO replication_user;

--

GRANT ALL ON SEQUENCE public.offer_cart_tiers_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.offer_cart_tiers_id_seq TO anon;

GRANT ALL ON SEQUENCE public.offer_cart_tiers_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.offer_cart_tiers_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.offer_names TO anon;

GRANT ALL ON TABLE public.offer_names TO authenticated;

GRANT ALL ON TABLE public.offer_names TO service_role;

GRANT SELECT ON TABLE public.offer_names TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.offer_products TO anon;

GRANT SELECT ON TABLE public.offer_products TO authenticated;

GRANT ALL ON TABLE public.offer_products TO service_role;

GRANT SELECT ON TABLE public.offer_products TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.offer_usage_logs TO anon;

GRANT SELECT ON TABLE public.offer_usage_logs TO authenticated;

GRANT ALL ON TABLE public.offer_usage_logs TO service_role;

GRANT SELECT ON TABLE public.offer_usage_logs TO replication_user;

--

GRANT ALL ON SEQUENCE public.offer_usage_logs_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.offer_usage_logs_id_seq TO anon;

GRANT ALL ON SEQUENCE public.offer_usage_logs_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.offer_usage_logs_id_seq TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.offers TO anon;

GRANT SELECT ON TABLE public.offers TO authenticated;

GRANT ALL ON TABLE public.offers TO service_role;

GRANT SELECT ON TABLE public.offers TO replication_user;

--

GRANT ALL ON SEQUENCE public.offers_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.offers_id_seq TO anon;

GRANT ALL ON SEQUENCE public.offers_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.offers_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.official_holidays TO anon;

GRANT ALL ON TABLE public.official_holidays TO authenticated;

GRANT ALL ON TABLE public.official_holidays TO service_role;

GRANT SELECT ON TABLE public.official_holidays TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.order_audit_logs TO anon;

GRANT SELECT ON TABLE public.order_audit_logs TO authenticated;

GRANT ALL ON TABLE public.order_audit_logs TO service_role;

GRANT SELECT ON TABLE public.order_audit_logs TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.order_items TO anon;

GRANT SELECT ON TABLE public.order_items TO authenticated;

GRANT ALL ON TABLE public.order_items TO service_role;

GRANT SELECT ON TABLE public.order_items TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.orders TO anon;

GRANT SELECT ON TABLE public.orders TO authenticated;

GRANT ALL ON TABLE public.orders TO service_role;

GRANT SELECT ON TABLE public.orders TO replication_user;

--

GRANT SELECT ON TABLE public.overtime_registrations TO anon;

GRANT SELECT ON TABLE public.overtime_registrations TO authenticated;

GRANT ALL ON TABLE public.overtime_registrations TO service_role;

GRANT SELECT ON TABLE public.overtime_registrations TO replication_user;

--

GRANT ALL ON TABLE public.pos_deduction_transfers TO anon;

GRANT ALL ON TABLE public.pos_deduction_transfers TO authenticated;

GRANT ALL ON TABLE public.pos_deduction_transfers TO service_role;

GRANT SELECT ON TABLE public.pos_deduction_transfers TO replication_user;

--

GRANT SELECT ON TABLE public.privilege_cards_branch TO anon;

GRANT SELECT ON TABLE public.privilege_cards_branch TO authenticated;

GRANT ALL ON TABLE public.privilege_cards_branch TO service_role;

GRANT SELECT ON TABLE public.privilege_cards_branch TO replication_user;

--

GRANT SELECT ON TABLE public.privilege_cards_master TO anon;

GRANT SELECT ON TABLE public.privilege_cards_master TO authenticated;

GRANT ALL ON TABLE public.privilege_cards_master TO service_role;

GRANT SELECT ON TABLE public.privilege_cards_master TO replication_user;

--

GRANT ALL ON TABLE public.processed_fingerprint_transactions TO anon;

GRANT ALL ON TABLE public.processed_fingerprint_transactions TO authenticated;

GRANT ALL ON TABLE public.processed_fingerprint_transactions TO service_role;

GRANT SELECT ON TABLE public.processed_fingerprint_transactions TO replication_user;

--

GRANT ALL ON SEQUENCE public.processed_fingerprint_transactions_seq TO service_role;

GRANT SELECT ON SEQUENCE public.processed_fingerprint_transactions_seq TO replication_user;

--

GRANT ALL ON TABLE public.product_categories TO anon;

GRANT ALL ON TABLE public.product_categories TO authenticated;

GRANT ALL ON TABLE public.product_categories TO service_role;

GRANT SELECT ON TABLE public.product_categories TO replication_user;

--

GRANT ALL ON TABLE public.product_request_bt TO anon;

GRANT ALL ON TABLE public.product_request_bt TO authenticated;

GRANT ALL ON TABLE public.product_request_bt TO service_role;

GRANT SELECT ON TABLE public.product_request_bt TO replication_user;

--

GRANT ALL ON TABLE public.product_request_po TO anon;

GRANT ALL ON TABLE public.product_request_po TO authenticated;

GRANT ALL ON TABLE public.product_request_po TO service_role;

GRANT SELECT ON TABLE public.product_request_po TO replication_user;

--

GRANT ALL ON TABLE public.product_request_st TO anon;

GRANT ALL ON TABLE public.product_request_st TO authenticated;

GRANT ALL ON TABLE public.product_request_st TO service_role;

GRANT SELECT ON TABLE public.product_request_st TO replication_user;

--

GRANT ALL ON TABLE public.product_units TO anon;

GRANT ALL ON TABLE public.product_units TO authenticated;

GRANT ALL ON TABLE public.product_units TO service_role;

GRANT SELECT ON TABLE public.product_units TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.products TO anon;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.products TO authenticated;

GRANT ALL ON TABLE public.products TO service_role;

GRANT SELECT ON TABLE public.products TO replication_user;

--

GRANT ALL ON TABLE public.purchase_voucher_issue_types TO anon;

GRANT ALL ON TABLE public.purchase_voucher_issue_types TO authenticated;

GRANT ALL ON TABLE public.purchase_voucher_issue_types TO service_role;

GRANT SELECT ON TABLE public.purchase_voucher_issue_types TO replication_user;

--

GRANT ALL ON TABLE public.purchase_voucher_items TO anon;

GRANT ALL ON TABLE public.purchase_voucher_items TO authenticated;

GRANT ALL ON TABLE public.purchase_voucher_items TO service_role;

GRANT SELECT ON TABLE public.purchase_voucher_items TO replication_user;

--

GRANT ALL ON TABLE public.purchase_vouchers TO anon;

GRANT ALL ON TABLE public.purchase_vouchers TO authenticated;

GRANT ALL ON TABLE public.purchase_vouchers TO service_role;

GRANT SELECT ON TABLE public.purchase_vouchers TO replication_user;

--

GRANT ALL ON SEQUENCE public.purchase_vouchers_book_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.purchase_vouchers_book_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.purchase_vouchers_book_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.purchase_vouchers_book_seq TO replication_user;

--

GRANT ALL ON TABLE public.push_subscriptions TO anon;

GRANT ALL ON TABLE public.push_subscriptions TO authenticated;

GRANT ALL ON TABLE public.push_subscriptions TO service_role;

GRANT SELECT ON TABLE public.push_subscriptions TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_assignments TO anon;

GRANT SELECT ON TABLE public.quick_task_assignments TO authenticated;

GRANT ALL ON TABLE public.quick_task_assignments TO service_role;

GRANT SELECT ON TABLE public.quick_task_assignments TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_comments TO anon;

GRANT SELECT ON TABLE public.quick_task_comments TO authenticated;

GRANT ALL ON TABLE public.quick_task_comments TO service_role;

GRANT SELECT ON TABLE public.quick_task_comments TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_completions TO anon;

GRANT SELECT ON TABLE public.quick_task_completions TO authenticated;

GRANT ALL ON TABLE public.quick_task_completions TO service_role;

GRANT SELECT ON TABLE public.quick_task_completions TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_tasks TO anon;

GRANT SELECT ON TABLE public.quick_tasks TO authenticated;

GRANT ALL ON TABLE public.quick_tasks TO service_role;

GRANT SELECT ON TABLE public.quick_tasks TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO anon;

GRANT SELECT ON TABLE public.users TO authenticated;

GRANT ALL ON TABLE public.users TO service_role;

GRANT SELECT ON TABLE public.users TO replication_user;

--

GRANT SELECT ON TABLE public.quick_task_completion_details TO anon;

GRANT SELECT ON TABLE public.quick_task_completion_details TO authenticated;

GRANT ALL ON TABLE public.quick_task_completion_details TO service_role;

GRANT SELECT ON TABLE public.quick_task_completion_details TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_files TO anon;

GRANT SELECT ON TABLE public.quick_task_files TO authenticated;

GRANT ALL ON TABLE public.quick_task_files TO service_role;

GRANT SELECT ON TABLE public.quick_task_files TO replication_user;

--

GRANT SELECT ON TABLE public.quick_task_files_with_details TO anon;

GRANT SELECT ON TABLE public.quick_task_files_with_details TO authenticated;

GRANT ALL ON TABLE public.quick_task_files_with_details TO service_role;

GRANT SELECT ON TABLE public.quick_task_files_with_details TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.quick_task_user_preferences TO anon;

GRANT SELECT ON TABLE public.quick_task_user_preferences TO authenticated;

GRANT ALL ON TABLE public.quick_task_user_preferences TO service_role;

GRANT SELECT ON TABLE public.quick_task_user_preferences TO replication_user;

--

GRANT SELECT ON TABLE public.quick_tasks_with_details TO anon;

GRANT SELECT ON TABLE public.quick_tasks_with_details TO authenticated;

GRANT ALL ON TABLE public.quick_tasks_with_details TO service_role;

GRANT SELECT ON TABLE public.quick_tasks_with_details TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.receiving_records TO anon;

GRANT SELECT ON TABLE public.receiving_records TO authenticated;

GRANT ALL ON TABLE public.receiving_records TO service_role;

GRANT SELECT ON TABLE public.receiving_records TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.vendors TO anon;

GRANT SELECT ON TABLE public.vendors TO authenticated;

GRANT ALL ON TABLE public.vendors TO service_role;

GRANT SELECT ON TABLE public.vendors TO replication_user;

--

GRANT SELECT ON TABLE public.receiving_records_pr_excel_status TO anon;

GRANT SELECT ON TABLE public.receiving_records_pr_excel_status TO authenticated;

GRANT ALL ON TABLE public.receiving_records_pr_excel_status TO service_role;

GRANT SELECT ON TABLE public.receiving_records_pr_excel_status TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.receiving_task_templates TO anon;

GRANT SELECT ON TABLE public.receiving_task_templates TO authenticated;

GRANT ALL ON TABLE public.receiving_task_templates TO service_role;

GRANT SELECT ON TABLE public.receiving_task_templates TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.receiving_tasks TO anon;

GRANT SELECT ON TABLE public.receiving_tasks TO authenticated;

GRANT ALL ON TABLE public.receiving_tasks TO service_role;

GRANT SELECT ON TABLE public.receiving_tasks TO replication_user;

--

GRANT ALL ON TABLE public.receiving_user_defaults TO anon;

GRANT ALL ON TABLE public.receiving_user_defaults TO authenticated;

GRANT ALL ON TABLE public.receiving_user_defaults TO service_role;

GRANT SELECT ON TABLE public.receiving_user_defaults TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.recurring_assignment_schedules TO anon;

GRANT SELECT ON TABLE public.recurring_assignment_schedules TO authenticated;

GRANT ALL ON TABLE public.recurring_assignment_schedules TO service_role;

GRANT SELECT ON TABLE public.recurring_assignment_schedules TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.recurring_schedule_check_log TO anon;

GRANT SELECT ON TABLE public.recurring_schedule_check_log TO authenticated;

GRANT ALL ON TABLE public.recurring_schedule_check_log TO service_role;

GRANT SELECT ON TABLE public.recurring_schedule_check_log TO replication_user;

--

GRANT ALL ON SEQUENCE public.recurring_schedule_check_log_id_seq TO service_role;

GRANT ALL ON SEQUENCE public.recurring_schedule_check_log_id_seq TO anon;

GRANT ALL ON SEQUENCE public.recurring_schedule_check_log_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.recurring_schedule_check_log_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.regular_shift TO anon;

GRANT ALL ON TABLE public.regular_shift TO authenticated;

GRANT ALL ON TABLE public.regular_shift TO service_role;

GRANT SELECT ON TABLE public.regular_shift TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.requesters TO anon;

GRANT SELECT ON TABLE public.requesters TO authenticated;

GRANT ALL ON TABLE public.requesters TO service_role;

GRANT SELECT ON TABLE public.requesters TO replication_user;

--

GRANT SELECT ON TABLE public.security_code_scroll_texts TO anon;

GRANT ALL ON TABLE public.security_code_scroll_texts TO authenticated;

GRANT ALL ON TABLE public.security_code_scroll_texts TO service_role;

GRANT SELECT ON TABLE public.security_code_scroll_texts TO replication_user;

--

GRANT ALL ON SEQUENCE public.shelf_paper_fonts_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.shelf_paper_fonts_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.shelf_paper_fonts_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.shelf_paper_fonts_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.shelf_paper_fonts TO anon;

GRANT ALL ON TABLE public.shelf_paper_fonts TO authenticated;

GRANT ALL ON TABLE public.shelf_paper_fonts TO service_role;

GRANT SELECT ON TABLE public.shelf_paper_fonts TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.shelf_paper_templates TO anon;

GRANT SELECT ON TABLE public.shelf_paper_templates TO authenticated;

GRANT ALL ON TABLE public.shelf_paper_templates TO service_role;

GRANT SELECT ON TABLE public.shelf_paper_templates TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sidebar_buttons TO anon;

GRANT SELECT ON TABLE public.sidebar_buttons TO authenticated;

GRANT ALL ON TABLE public.sidebar_buttons TO service_role;

GRANT SELECT ON TABLE public.sidebar_buttons TO replication_user;

--

GRANT ALL ON SEQUENCE public.sidebar_buttons_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.sidebar_buttons_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.sidebar_buttons_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.sidebar_buttons_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.social_links TO anon;

GRANT ALL ON TABLE public.social_links TO authenticated;

GRANT ALL ON TABLE public.social_links TO service_role;

GRANT SELECT ON TABLE public.social_links TO replication_user;

--

GRANT ALL ON TABLE public.special_shift_date_wise TO anon;

GRANT ALL ON TABLE public.special_shift_date_wise TO authenticated;

GRANT ALL ON TABLE public.special_shift_date_wise TO service_role;

GRANT SELECT ON TABLE public.special_shift_date_wise TO replication_user;

--

GRANT ALL ON TABLE public.special_shift_weekday TO anon;

GRANT ALL ON TABLE public.special_shift_weekday TO authenticated;

GRANT ALL ON TABLE public.special_shift_weekday TO service_role;

GRANT SELECT ON TABLE public.special_shift_weekday TO replication_user;

--

GRANT ALL ON TABLE public.system_api_keys TO anon;

GRANT ALL ON TABLE public.system_api_keys TO authenticated;

GRANT ALL ON TABLE public.system_api_keys TO service_role;

GRANT SELECT ON TABLE public.system_api_keys TO replication_user;

--

GRANT ALL ON SEQUENCE public.system_api_keys_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.system_api_keys_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.system_api_keys_id_seq TO anon;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.task_assignments TO anon;

GRANT SELECT ON TABLE public.task_assignments TO authenticated;

GRANT ALL ON TABLE public.task_assignments TO service_role;

GRANT SELECT ON TABLE public.task_assignments TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.task_images TO anon;

GRANT SELECT ON TABLE public.task_images TO authenticated;

GRANT ALL ON TABLE public.task_images TO service_role;

GRANT SELECT ON TABLE public.task_images TO replication_user;

--

GRANT SELECT ON TABLE public.task_attachments TO anon;

GRANT SELECT ON TABLE public.task_attachments TO authenticated;

GRANT ALL ON TABLE public.task_attachments TO service_role;

GRANT SELECT ON TABLE public.task_attachments TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.task_completions TO anon;

GRANT SELECT ON TABLE public.task_completions TO authenticated;

GRANT ALL ON TABLE public.task_completions TO service_role;

GRANT SELECT ON TABLE public.task_completions TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.tasks TO anon;

GRANT SELECT ON TABLE public.tasks TO authenticated;

GRANT ALL ON TABLE public.tasks TO service_role;

GRANT SELECT ON TABLE public.tasks TO replication_user;

--

GRANT SELECT ON TABLE public.task_completion_summary TO anon;

GRANT SELECT ON TABLE public.task_completion_summary TO authenticated;

GRANT ALL ON TABLE public.task_completion_summary TO service_role;

GRANT SELECT ON TABLE public.task_completion_summary TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.task_reminder_logs TO anon;

GRANT SELECT ON TABLE public.task_reminder_logs TO authenticated;

GRANT ALL ON TABLE public.task_reminder_logs TO service_role;

GRANT SELECT ON TABLE public.task_reminder_logs TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.user_audit_logs TO anon;

GRANT SELECT ON TABLE public.user_audit_logs TO authenticated;

GRANT ALL ON TABLE public.user_audit_logs TO service_role;

GRANT SELECT ON TABLE public.user_audit_logs TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.user_device_sessions TO anon;

GRANT SELECT ON TABLE public.user_device_sessions TO authenticated;

GRANT ALL ON TABLE public.user_device_sessions TO service_role;

GRANT SELECT ON TABLE public.user_device_sessions TO replication_user;

--

GRANT ALL ON TABLE public.user_favorite_buttons TO anon;

GRANT ALL ON TABLE public.user_favorite_buttons TO authenticated;

GRANT ALL ON TABLE public.user_favorite_buttons TO service_role;

GRANT SELECT ON TABLE public.user_favorite_buttons TO replication_user;

--

GRANT SELECT ON TABLE public.user_management_view TO anon;

GRANT SELECT ON TABLE public.user_management_view TO authenticated;

GRANT ALL ON TABLE public.user_management_view TO service_role;

GRANT SELECT ON TABLE public.user_management_view TO replication_user;

--

GRANT ALL ON TABLE public.user_mobile_theme_assignments TO anon;

GRANT ALL ON TABLE public.user_mobile_theme_assignments TO authenticated;

GRANT ALL ON TABLE public.user_mobile_theme_assignments TO service_role;

GRANT SELECT ON TABLE public.user_mobile_theme_assignments TO replication_user;

--

GRANT ALL ON SEQUENCE public.user_mobile_theme_assignments_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.user_mobile_theme_assignments_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.user_mobile_theme_assignments_id_seq TO anon;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.user_password_history TO anon;

GRANT SELECT ON TABLE public.user_password_history TO authenticated;

GRANT ALL ON TABLE public.user_password_history TO service_role;

GRANT SELECT ON TABLE public.user_password_history TO replication_user;

--

GRANT SELECT ON TABLE public.user_permissions_view TO anon;

GRANT SELECT ON TABLE public.user_permissions_view TO authenticated;

GRANT ALL ON TABLE public.user_permissions_view TO service_role;

GRANT SELECT ON TABLE public.user_permissions_view TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.user_sessions TO anon;

GRANT SELECT ON TABLE public.user_sessions TO authenticated;

GRANT ALL ON TABLE public.user_sessions TO service_role;

GRANT SELECT ON TABLE public.user_sessions TO replication_user;

--

GRANT ALL ON TABLE public.user_theme_assignments TO anon;

GRANT ALL ON TABLE public.user_theme_assignments TO authenticated;

GRANT ALL ON TABLE public.user_theme_assignments TO service_role;

GRANT SELECT ON TABLE public.user_theme_assignments TO replication_user;

--

GRANT ALL ON SEQUENCE public.user_theme_assignments_id_seq TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.user_theme_assignments_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.user_theme_assignments_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.user_theme_assignments_id_seq TO replication_user;

--

GRANT ALL ON TABLE public.user_voice_preferences TO anon;

GRANT ALL ON TABLE public.user_voice_preferences TO authenticated;

GRANT ALL ON TABLE public.user_voice_preferences TO service_role;

GRANT SELECT ON TABLE public.user_voice_preferences TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.variation_audit_log TO anon;

GRANT SELECT ON TABLE public.variation_audit_log TO authenticated;

GRANT ALL ON TABLE public.variation_audit_log TO service_role;

GRANT SELECT ON TABLE public.variation_audit_log TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.vendor_payment_schedule TO anon;

GRANT SELECT ON TABLE public.vendor_payment_schedule TO authenticated;

GRANT ALL ON TABLE public.vendor_payment_schedule TO service_role;

GRANT SELECT ON TABLE public.vendor_payment_schedule TO replication_user;

--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.view_offer TO anon;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.view_offer TO authenticated;

GRANT ALL ON TABLE public.view_offer TO service_role;

GRANT SELECT ON TABLE public.view_offer TO replication_user;

--

GRANT ALL ON TABLE public.wa_accounts TO anon;

GRANT ALL ON TABLE public.wa_accounts TO authenticated;

GRANT ALL ON TABLE public.wa_accounts TO service_role;

GRANT SELECT ON TABLE public.wa_accounts TO replication_user;

--

GRANT ALL ON TABLE public.wa_ai_bot_config TO anon;

GRANT ALL ON TABLE public.wa_ai_bot_config TO authenticated;

GRANT ALL ON TABLE public.wa_ai_bot_config TO service_role;

GRANT SELECT ON TABLE public.wa_ai_bot_config TO replication_user;

--

GRANT ALL ON TABLE public.wa_auto_reply_triggers TO anon;

GRANT ALL ON TABLE public.wa_auto_reply_triggers TO authenticated;

GRANT ALL ON TABLE public.wa_auto_reply_triggers TO service_role;

GRANT SELECT ON TABLE public.wa_auto_reply_triggers TO replication_user;

--

GRANT ALL ON TABLE public.wa_bot_flows TO anon;

GRANT ALL ON TABLE public.wa_bot_flows TO authenticated;

GRANT ALL ON TABLE public.wa_bot_flows TO service_role;

GRANT SELECT ON TABLE public.wa_bot_flows TO replication_user;

--

GRANT ALL ON TABLE public.wa_broadcast_recipients TO anon;

GRANT ALL ON TABLE public.wa_broadcast_recipients TO authenticated;

GRANT ALL ON TABLE public.wa_broadcast_recipients TO service_role;

GRANT SELECT ON TABLE public.wa_broadcast_recipients TO replication_user;

--

GRANT ALL ON TABLE public.wa_broadcasts TO anon;

GRANT ALL ON TABLE public.wa_broadcasts TO authenticated;

GRANT ALL ON TABLE public.wa_broadcasts TO service_role;

GRANT SELECT ON TABLE public.wa_broadcasts TO replication_user;

--

GRANT ALL ON TABLE public.wa_catalog_orders TO anon;

GRANT ALL ON TABLE public.wa_catalog_orders TO authenticated;

GRANT ALL ON TABLE public.wa_catalog_orders TO service_role;

GRANT SELECT ON TABLE public.wa_catalog_orders TO replication_user;

--

GRANT ALL ON TABLE public.wa_catalog_products TO anon;

GRANT ALL ON TABLE public.wa_catalog_products TO authenticated;

GRANT ALL ON TABLE public.wa_catalog_products TO service_role;

GRANT SELECT ON TABLE public.wa_catalog_products TO replication_user;

--

GRANT ALL ON TABLE public.wa_catalogs TO anon;

GRANT ALL ON TABLE public.wa_catalogs TO authenticated;

GRANT ALL ON TABLE public.wa_catalogs TO service_role;

GRANT SELECT ON TABLE public.wa_catalogs TO replication_user;

--

GRANT ALL ON TABLE public.wa_contact_group_members TO anon;

GRANT ALL ON TABLE public.wa_contact_group_members TO authenticated;

GRANT ALL ON TABLE public.wa_contact_group_members TO service_role;

GRANT SELECT ON TABLE public.wa_contact_group_members TO replication_user;

--

GRANT ALL ON TABLE public.wa_contact_groups TO anon;

GRANT ALL ON TABLE public.wa_contact_groups TO authenticated;

GRANT ALL ON TABLE public.wa_contact_groups TO service_role;

GRANT SELECT ON TABLE public.wa_contact_groups TO replication_user;

--

GRANT ALL ON TABLE public.wa_conversations TO anon;

GRANT ALL ON TABLE public.wa_conversations TO authenticated;

GRANT ALL ON TABLE public.wa_conversations TO service_role;

GRANT SELECT ON TABLE public.wa_conversations TO replication_user;

--

GRANT ALL ON TABLE public.wa_messages TO anon;

GRANT ALL ON TABLE public.wa_messages TO authenticated;

GRANT ALL ON TABLE public.wa_messages TO service_role;

GRANT SELECT ON TABLE public.wa_messages TO replication_user;

--

GRANT ALL ON TABLE public.wa_settings TO anon;

GRANT ALL ON TABLE public.wa_settings TO authenticated;

GRANT ALL ON TABLE public.wa_settings TO service_role;

GRANT SELECT ON TABLE public.wa_settings TO replication_user;

--

GRANT ALL ON TABLE public.wa_templates TO anon;

GRANT ALL ON TABLE public.wa_templates TO authenticated;

GRANT ALL ON TABLE public.wa_templates TO service_role;

GRANT SELECT ON TABLE public.wa_templates TO replication_user;

--

GRANT ALL ON TABLE public.warning_main_category TO anon;

GRANT ALL ON TABLE public.warning_main_category TO authenticated;

GRANT ALL ON TABLE public.warning_main_category TO service_role;

GRANT SELECT ON TABLE public.warning_main_category TO replication_user;

--

GRANT ALL ON SEQUENCE public.warning_ref_seq TO service_role;

GRANT ALL ON SEQUENCE public.warning_ref_seq TO anon;

GRANT ALL ON SEQUENCE public.warning_ref_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.warning_ref_seq TO replication_user;

--

GRANT ALL ON TABLE public.warning_sub_category TO anon;

GRANT ALL ON TABLE public.warning_sub_category TO authenticated;

GRANT ALL ON TABLE public.warning_sub_category TO service_role;

GRANT SELECT ON TABLE public.warning_sub_category TO replication_user;

--

GRANT ALL ON TABLE public.warning_violation TO anon;

GRANT ALL ON TABLE public.warning_violation TO authenticated;

GRANT ALL ON TABLE public.warning_violation TO service_role;

GRANT SELECT ON TABLE public.warning_violation TO replication_user;

--

GRANT SELECT ON TABLE public.whatsapp_message_log TO anon;

GRANT SELECT ON TABLE public.whatsapp_message_log TO authenticated;

GRANT ALL ON TABLE public.whatsapp_message_log TO service_role;

GRANT SELECT ON TABLE public.whatsapp_message_log TO replication_user;

--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;

--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT ON TABLES  TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT ON TABLES  TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT ON TABLES  TO replication_user;