--

CREATE FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_status VARCHAR(50);

--

CREATE FUNCTION public.adjust_product_stock_on_order_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_quantity INTEGER;

--

CREATE FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text DEFAULT ''::text, p_approved_by uuid DEFAULT NULL::uuid) RETURNS TABLE(success boolean, message text, customer_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_current_status TEXT;

--

CREATE FUNCTION public.approve_customer_registration(p_customer_id uuid, p_approved_by uuid, p_notes text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_access_code text;

--

CREATE FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_delivery_name VARCHAR(255);

--

CREATE FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_picker_name VARCHAR(255);

--

CREATE FUNCTION public.assign_task_simple(task_id_param uuid, assigned_to_user_id_param uuid, assigned_by_param text, assigned_by_name_param text, deadline_datetime_param timestamp with time zone, priority_param text, notes_param text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;

--

CREATE FUNCTION public.auto_create_payment_schedule() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    schedule_date TIMESTAMPTZ;

--

CREATE FUNCTION public.bulk_import_customers(p_phone_numbers text[]) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_phone text;

--

CREATE FUNCTION public.calculate_category_days() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Auto-calculate days for leave categories
    IF NEW.document_category IN ('sick_leave', 'special_leave', 'annual_leave') 
       AND NEW.category_start_date IS NOT NULL 
       AND NEW.category_end_date IS NOT NULL THEN
        NEW.category_days := NEW.category_end_date - NEW.category_start_date + 1;

--

CREATE FUNCTION public.calculate_flyer_product_profit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Calculate profit amount
  NEW.profit := NEW.sale_price - NEW.cost;

--

CREATE FUNCTION public.calculate_next_visit_date(visit_type text, weekday_name text DEFAULT NULL::text, fresh_type text DEFAULT NULL::text, day_number integer DEFAULT NULL::integer, skip_days integer DEFAULT NULL::integer, start_date date DEFAULT NULL::date, current_next_date date DEFAULT NULL::date) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
    next_date DATE;

--

CREATE FUNCTION public.calculate_profit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate profit
    NEW.profit = NEW.sale_price - NEW.cost;

--

CREATE FUNCTION public.calculate_receiving_amounts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate total_return_amount
    NEW.total_return_amount := 
        COALESCE(NEW.expired_return_amount, 0) +
        COALESCE(NEW.near_expiry_return_amount, 0) +
        COALESCE(NEW.over_stock_return_amount, 0) +
        COALESCE(NEW.damage_return_amount, 0);

--

CREATE FUNCTION public.calculate_return_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Calculate total return amount
  NEW.total_return_amount = COALESCE(NEW.expired_return_amount, 0) + 
                           COALESCE(NEW.near_expiry_return_amount, 0) + 
                           COALESCE(NEW.over_stock_return_amount, 0) + 
                           COALESCE(NEW.damage_return_amount, 0);

--

CREATE FUNCTION public.calculate_schedule_details() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Auto-detect overnight shift if not explicitly set
    IF NEW.is_overnight IS NULL THEN
        NEW.is_overnight := is_overnight_shift(NEW.scheduled_start_time, NEW.scheduled_end_time);

--

CREATE FUNCTION public.calculate_working_hours() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  start_minutes INTEGER;

--

CREATE FUNCTION public.calculate_working_hours(check_in timestamp with time zone, check_out timestamp with time zone) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF check_in IS NULL OR check_out IS NULL THEN
        RETURN 0.00;

--

CREATE FUNCTION public.calculate_working_hours(start_time time without time zone, end_time time without time zone, is_overnight_shift boolean DEFAULT false) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    IF is_overnight_shift THEN
        -- For overnight shifts: (24:00 - start_time) + end_time
        RETURN ROUND(
            (EXTRACT(EPOCH FROM (TIME '24:00:00' - start_time)) + 
             EXTRACT(EPOCH FROM end_time)) / 3600.0, 2
        );

--

CREATE FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_status VARCHAR(50);

--

CREATE FUNCTION public.check_accountant_dependency(receiving_record_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_receiving_record RECORD;

--

CREATE FUNCTION public.check_and_notify_recurring_schedules() RETURNS TABLE(schedule_id integer, notification_sent boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec RECORD;

--

CREATE FUNCTION public.check_and_notify_recurring_schedules_with_logging() RETURNS TABLE(schedules_checked integer, notifications_sent integer, execution_date date, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    checked_count INTEGER := 0;

--

CREATE FUNCTION public.check_erp_sync_status() RETURNS TABLE(total_inventory_completions bigint, synced_records bigint, unsynced_records bigint, sync_percentage numeric, status text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_completions,
        COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NOT NULL THEN 1 END) as synced,
        COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NULL THEN 1 END) as unsynced,
        ROUND(
            (COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NOT NULL THEN 1 END)::NUMERIC / 
             COUNT(*)::NUMERIC) * 100, 2
        ) as percentage,
        CASE 
            WHEN COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NULL THEN 1 END) = 0 
            THEN '✅ ALL SYNCED'
            ELSE '⚠️ SOME UNSYNCED'
        END as sync_status
    FROM task_completions tc
    JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
    JOIN receiving_records rr ON rt.receiving_record_id = rr.id
    WHERE tc.erp_reference_completed = true 
      AND tc.erp_reference_number IS NOT NULL 
      AND tc.erp_reference_number != ''
      AND rt.role_type = 'inventory_manager';

--

CREATE FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    status_record RECORD;

--

CREATE FUNCTION public.check_offer_eligibility(p_offer_id integer, p_customer_id uuid, p_cart_total numeric DEFAULT 0, p_cart_quantity integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_offer RECORD;

--

CREATE FUNCTION public.check_orphaned_variations() RETURNS TABLE(barcode text, product_name_en text, product_name_ar text, parent_product_barcode text, reason text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    p.parent_product_barcode,
    CASE 
      WHEN p.parent_product_barcode IS NOT NULL 
           AND NOT EXISTS (
             SELECT 1 FROM products parent 
             WHERE parent.barcode = p.parent_product_barcode
           ) THEN 'Parent product does not exist'
      WHEN p.parent_product_barcode = p.barcode THEN 'Self-referencing parent'
      ELSE 'Unknown issue'
    END as reason
  FROM products p
  WHERE p.is_variation = true
    AND (
      (p.parent_product_barcode IS NOT NULL 
       AND NOT EXISTS (
         SELECT 1 FROM products parent 
         WHERE parent.barcode = p.parent_product_barcode
       ))
      OR p.parent_product_barcode = p.barcode
    )
  ORDER BY p.product_name_en;

--

CREATE FUNCTION public.check_receiving_task_dependencies(receiving_record_id_param uuid, role_type_param text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  template_record RECORD;

--

CREATE FUNCTION public.check_task_completion_criteria(task_uuid uuid, task_finished_val boolean, photo_uploaded_val boolean, erp_reference_val boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    task_record record;

--

CREATE FUNCTION public.check_user_permission(p_function_code text, p_permission text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Old role system removed - this function is deprecated
  -- Return false since we now use button_permissions system
  -- TODO: Remove calls to this function from application code
  RETURN false;

--

CREATE FUNCTION public.check_visit_conflicts(branch_uuid uuid, visit_date_param date, visit_time_param time without time zone, duration_minutes integer DEFAULT 60, exclude_visit_id uuid DEFAULT NULL::uuid) RETURNS TABLE(conflict_count integer, conflicting_visits text[])
    LANGUAGE plpgsql
    AS $$
DECLARE
    start_time TIME;

--

CREATE FUNCTION public.claim_coupon(p_campaign_id uuid, p_mobile_number character varying, p_product_id uuid, p_branch_id bigint, p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_claim_id UUID;

--

CREATE FUNCTION public.clear_analytics_logs() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  tbl record;

--

CREATE FUNCTION public.clear_main_document_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clear the dedicated columns based on document type
    IF OLD.document_type = 'health_card' THEN
        OLD.health_card_number := NULL;

--

CREATE FUNCTION public.complete_receiving_task(receiving_task_id_param uuid, user_id_param uuid, erp_reference_param character varying DEFAULT NULL::character varying, original_bill_file_path_param text DEFAULT NULL::text, has_erp_purchase_invoice boolean DEFAULT false, has_pr_excel_file boolean DEFAULT false, has_original_bill boolean DEFAULT false, completion_photo_url_param text DEFAULT NULL::text, completion_notes_param text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_task RECORD;

--

CREATE FUNCTION public.complete_receiving_task_fixed(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text DEFAULT NULL::text, completion_notes_param text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_task RECORD;

--

CREATE FUNCTION public.complete_receiving_task_simple(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text DEFAULT NULL::text, completion_notes_param text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_task RECORD;

--

CREATE FUNCTION public.complete_visit_and_update_next(visit_id uuid) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
    visit_record vendor_visits%ROWTYPE;

--

CREATE FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_count INTEGER;

--

CREATE FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_count INTEGER;

--

CREATE FUNCTION public.count_bills_without_pr_excel() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM receiving_records
        WHERE pr_excel_file_url IS NULL 
           OR pr_excel_file_url = ''
    );

--

CREATE FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_count INTEGER;

--

CREATE FUNCTION public.count_finished_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    finished_count INTEGER;

--

CREATE FUNCTION public.count_incomplete_receiving_tasks_detailed() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    incomplete_count INTEGER;

--

CREATE FUNCTION public.create_default_auto_schedule_config(p_branch_id bigint, p_start_time time without time zone DEFAULT '09:00:00'::time without time zone, p_end_time time without time zone DEFAULT '17:00:00'::time without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO auto_schedule_config (
        branch_id,
        default_start_time,
        default_end_time,
        default_hours
    ) VALUES (
        p_branch_id,
        p_start_time,
        p_end_time,
        calculate_working_hours(p_start_time, p_end_time, FALSE)
    ) ON CONFLICT (branch_id) DO NOTHING;

--

CREATE FUNCTION public.create_default_auto_schedule_config(p_branch_id uuid, p_start_time time without time zone DEFAULT '09:00:00'::time without time zone, p_end_time time without time zone DEFAULT '17:00:00'::time without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO auto_schedule_config (
        branch_id,
        default_start_time,
        default_end_time,
        default_hours,
        basic_hours
    ) VALUES (
        p_branch_id,
        p_start_time,
        p_end_time,
        calculate_working_hours(p_start_time, p_end_time, FALSE),
        calculate_working_hours(p_start_time, p_end_time, FALSE)
    ) ON CONFLICT (branch_id) DO NOTHING;

--

CREATE FUNCTION public.create_default_interface_permissions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public.interface_permissions (user_id, updated_by)
    VALUES (NEW.id, NEW.id)
    ON CONFLICT (user_id) DO NOTHING;

--

CREATE FUNCTION public.create_notification_recipients() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_user_id uuid;

--

CREATE FUNCTION public.create_notification_simple(title_param text, message_param text, created_by_param text, created_by_name_param text, target_user_id_param uuid, task_id_param uuid, assignment_id_param uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    notification_id UUID;

--

CREATE FUNCTION public.create_quick_task_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    assigned_by_name TEXT;

--

CREATE FUNCTION public.create_quick_task_with_assignments(title_param character varying, description_param text, priority_param character varying DEFAULT 'medium'::character varying, deadline_param timestamp with time zone DEFAULT NULL::timestamp with time zone, created_by_param uuid DEFAULT NULL::uuid, assigned_user_ids uuid[] DEFAULT NULL::uuid[], require_task_finished_param boolean DEFAULT true, require_photo_upload_param boolean DEFAULT false, require_erp_reference_param boolean DEFAULT false) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    task_id UUID;

--

CREATE FUNCTION public.create_recurring_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, recurrence_pattern character varying, start_date date, end_date date DEFAULT NULL::date) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    schedule_id UUID;

--

CREATE FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text DEFAULT NULL::text, p_assigned_to_branch_id uuid DEFAULT NULL::uuid, p_assigned_by_name text DEFAULT NULL::text, p_repeat_interval integer DEFAULT 1, p_repeat_on_days integer[] DEFAULT NULL::integer[], p_execute_time time without time zone DEFAULT '09:00:00'::time without time zone, p_start_date date DEFAULT CURRENT_DATE, p_end_date date DEFAULT NULL::date, p_max_occurrences integer DEFAULT NULL::integer, p_notes text DEFAULT NULL::text, p_is_reassignable boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;

--

CREATE FUNCTION public.create_schedule_template(p_branch_id bigint, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean DEFAULT true) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    template_id BIGINT;

--

CREATE FUNCTION public.create_schedule_template(p_branch_id uuid, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    template_id UUID;

--

CREATE FUNCTION public.create_scheduled_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, scheduled_for timestamp with time zone, priority character varying DEFAULT 'medium'::character varying) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    assignment_id UUID;

--

CREATE FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text DEFAULT NULL::text, p_assigned_to_branch_id uuid DEFAULT NULL::uuid, p_assigned_by_name text DEFAULT NULL::text, p_schedule_date date DEFAULT NULL::date, p_schedule_time time without time zone DEFAULT NULL::time without time zone, p_deadline_date date DEFAULT NULL::date, p_deadline_time time without time zone DEFAULT NULL::time without time zone, p_is_reassignable boolean DEFAULT true, p_notes text DEFAULT NULL::text, p_priority_override text DEFAULT NULL::text, p_require_task_finished boolean DEFAULT true, p_require_photo_upload boolean DEFAULT false, p_require_erp_reference boolean DEFAULT false) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;

--

CREATE FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text DEFAULT NULL::text, p_is_master_admin boolean DEFAULT true, p_user_type public.user_type_enum DEFAULT 'global'::public.user_type_enum) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    password_salt TEXT;

--

CREATE FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text DEFAULT NULL::text, p_role_type public.role_type_enum DEFAULT 'Master Admin'::public.role_type_enum, p_user_type public.user_type_enum DEFAULT 'global'::public.user_type_enum) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    password_salt TEXT;

--

CREATE FUNCTION public.create_task(title_param text, description_param text, created_by_param text, created_by_name_param text, created_by_role_param text, priority_param text, due_date_param date, due_time_param time without time zone, require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean, can_escalate_param boolean, can_reassign_param boolean) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    task_id UUID;

--

CREATE FUNCTION public.create_user_profile() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO user_profiles (user_id)
    VALUES (NEW.id);

--

CREATE FUNCTION public.create_variation_group(p_parent_barcode text, p_variation_barcodes text[], p_group_name_en text, p_group_name_ar text, p_image_override text DEFAULT NULL::text, p_user_id uuid DEFAULT NULL::uuid) RETURNS TABLE(success boolean, message text, affected_count integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_affected_count INTEGER := 0;

--

CREATE FUNCTION public.create_warning_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Handle different trigger operations
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employee_warning_history (
            warning_id,
            action_type,
            new_values,
            changed_by,
            changed_by_username,
            change_reason
        ) VALUES (
            NEW.id,
            'created',
            row_to_json(NEW),
            NEW.issued_by,
            NEW.issued_by_username,
            'Warning created'
        );

--

CREATE FUNCTION public.current_user_is_admin() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN current_setting('app.is_master_admin', true)::BOOLEAN 
         OR current_setting('app.is_admin', true)::BOOLEAN;

--

CREATE FUNCTION public.daily_erp_sync_maintenance() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_result RECORD;

--

CREATE FUNCTION public.debug_get_dependency_photos(receiving_record_id_param uuid, dependency_role_types text[]) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  result_photos JSONB := '{}'::JSONB;

--

CREATE FUNCTION public.debug_receiving_tasks_data() RETURNS TABLE(total_receiving_tasks integer, total_task_completions integer, receiving_task_ids text, task_completion_task_ids text, matching_completed_tasks integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*)::INTEGER FROM receiving_tasks) as total_receiving_tasks,
        (SELECT COUNT(*)::INTEGER FROM task_completions) as total_task_completions,
        (SELECT string_agg(rt.task_id::TEXT, ', ') FROM receiving_tasks rt LIMIT 10) as receiving_task_ids,
        (SELECT string_agg(tc.task_id::TEXT, ', ') FROM task_completions tc WHERE tc.task_finished_completed = true LIMIT 10) as task_completion_task_ids,
        (SELECT COUNT(DISTINCT rt.id)::INTEGER 
         FROM receiving_tasks rt 
         WHERE EXISTS (
             SELECT 1 FROM task_completions tc 
             WHERE tc.task_id = rt.task_id 
             AND tc.task_finished_completed = true
         )) as matching_completed_tasks;

--

CREATE FUNCTION public.debug_users() RETURNS TABLE(user_id uuid, username character varying, status character varying, employee_id uuid, branch_id bigint, position_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id as user_id,
        u.username,
        u.status::VARCHAR,
        u.employee_id,
        u.branch_id,
        u.position_id
    FROM users u
    ORDER BY u.created_at DESC;

--

CREATE FUNCTION public.delete_customer_account(p_customer_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_customer record;

--

CREATE FUNCTION public.denomination_audit_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO denomination_audit_log (
            record_id, branch_id, user_id, action, record_type, box_number,
            old_counts, new_counts,
            old_erp_balance, new_erp_balance,
            old_grand_total, new_grand_total,
            old_difference, new_difference
        ) VALUES (
            NEW.id, NEW.branch_id, NEW.user_id, 'INSERT', NEW.record_type, NEW.box_number,
            NULL, NEW.counts,
            NULL, NEW.erp_balance,
            NULL, NEW.grand_total,
            NULL, NEW.difference
        );

--

CREATE FUNCTION public.duplicate_flyer_template(template_id uuid, new_name character varying, user_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  new_template_id UUID;

--

CREATE FUNCTION public.end_break(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_break RECORD;

--

CREATE FUNCTION public.format_file_size(size_bytes bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    size_kb numeric := size_bytes / 1024.0;

--

CREATE FUNCTION public.generate_branch_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    prefix VARCHAR(2);

--

CREATE FUNCTION public.generate_campaign_code() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
  new_code VARCHAR(8);

--

CREATE FUNCTION public.generate_clearance_certificate_tasks(receiving_record_id_param uuid, clearance_certificate_url_param text, created_by_user_id text, created_by_name text DEFAULT NULL::text, created_by_role text DEFAULT NULL::text) RETURNS TABLE(task_count integer, notification_count integer, task_ids uuid[], assignment_ids uuid[])
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_record RECORD;

--

CREATE FUNCTION public.generate_insurance_company_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  max_id INTEGER;

--

CREATE FUNCTION public.generate_order_number() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_order_number VARCHAR(50);

--

CREATE FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) RETURNS TABLE(occurrence_count integer, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec RECORD;

--

CREATE FUNCTION public.generate_salt() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN gen_salt('bf', 8);

--

CREATE FUNCTION public.generate_unique_customer_access_code() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_access_code text;

--

CREATE FUNCTION public.generate_warning_reference() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.warning_reference IS NULL OR NEW.warning_reference = '' THEN
        NEW.warning_reference = 'WRN-' || TO_CHAR(NEW.created_at, 'YYYYMMDD') || '-' || LPAD(nextval('warning_ref_seq')::text, 4, '0');

--

CREATE FUNCTION public.get_active_break(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_break RECORD;

--

CREATE FUNCTION public.get_active_customer_media() RETURNS TABLE(id uuid, media_type character varying, slot_number integer, title_en character varying, title_ar character varying, file_url text, duration integer, display_order integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cam.id,
        cam.media_type,
        cam.slot_number,
        cam.title_en,
        cam.title_ar,
        cam.file_url,
        cam.duration,
        cam.display_order
    FROM customer_app_media cam
    WHERE cam.is_active = true
      AND (
          cam.is_infinite = true 
          OR cam.expiry_date > NOW()
      )
    ORDER BY cam.display_order ASC, cam.created_at DESC;

--

CREATE FUNCTION public.get_active_employees_by_branch(branch_uuid uuid) RETURNS TABLE(id uuid, employee_id character varying, first_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.employee_id,
        e.first_name
    FROM employees e
    WHERE e.branch_id = branch_uuid 
    AND e.status = 'active'
    ORDER BY e.first_name;

--

CREATE FUNCTION public.get_active_flyer_templates() RETURNS TABLE(id uuid, name character varying, description text, first_page_image_url text, sub_page_image_urls text[], first_page_configuration jsonb, sub_page_configurations jsonb, metadata jsonb, is_default boolean, category character varying, tags text[], usage_count integer, last_used_at timestamp with time zone, created_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.id,
    t.name,
    t.description,
    t.first_page_image_url,
    t.sub_page_image_urls,
    t.first_page_configuration,
    t.sub_page_configurations,
    t.metadata,
    t.is_default,
    t.category,
    t.tags,
    t.usage_count,
    t.last_used_at,
    t.created_at
  FROM flyer_templates t
  WHERE t.is_active = true 
    AND t.deleted_at IS NULL
  ORDER BY 
    t.is_default DESC,
    t.usage_count DESC,
    t.created_at DESC;

--

CREATE FUNCTION public.get_active_offers_for_customer(p_customer_id uuid, p_branch_id integer DEFAULT NULL::integer, p_service_type character varying DEFAULT 'both'::character varying) RETURNS TABLE(offer_id integer, offer_type character varying, name_ar character varying, name_en character varying, discount_type character varying, discount_value numeric, start_date timestamp with time zone, end_date timestamp with time zone, service_type character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.type,
        o.name_ar,
        o.name_en,
        o.discount_type,
        o.discount_value,
        o.start_date,
        o.end_date,
        o.service_type
    FROM offers o
    WHERE o.is_active = true
        AND NOW() BETWEEN o.start_date AND o.end_date
        AND (o.branch_id IS NULL OR o.branch_id = p_branch_id)
        AND (o.service_type = 'both' OR o.service_type = p_service_type)
        AND (
            -- General offers (not customer-specific)
            o.type != 'customer'
            OR
            -- Customer-specific offers assigned to this customer
            EXISTS (
                SELECT 1 FROM customer_offers co
                WHERE co.offer_id = o.id
                    AND co.customer_id = p_customer_id
                    AND co.is_used = false
            )
        )
        AND (
            -- Check max total uses not exceeded
            o.max_total_uses IS NULL OR o.current_total_uses < o.max_total_uses
        )
    ORDER BY o.priority DESC, o.created_at DESC;

--

CREATE FUNCTION public.get_all_branches_delivery_settings() RETURNS TABLE(branch_id bigint, branch_name_en text, branch_name_ar text, minimum_order_amount numeric, delivery_service_enabled boolean, delivery_is_24_hours boolean, delivery_start_time time without time zone, delivery_end_time time without time zone, pickup_service_enabled boolean, pickup_is_24_hours boolean, pickup_start_time time without time zone, pickup_end_time time without time zone, delivery_message_ar text, delivery_message_en text, location_url text, latitude double precision, longitude double precision)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.id,
        b.name_en::text,
        b.name_ar::text,
        COALESCE(b.minimum_order_amount, 15.00)::numeric,
        COALESCE(b.delivery_service_enabled, true)::boolean,
        COALESCE(b.delivery_is_24_hours, true)::boolean,
        b.delivery_start_time,
        b.delivery_end_time,
        COALESCE(b.pickup_service_enabled, true)::boolean,
        COALESCE(b.pickup_is_24_hours, true)::boolean,
        b.pickup_start_time,
        b.pickup_end_time,
        COALESCE(b.delivery_message_ar, 'التوصيل متاح على مدار الساعة')::text,
        COALESCE(b.delivery_message_en, 'Delivery available 24/7')::text,
        b.location_url,
        b.latitude,
        b.longitude
    FROM public.branches b
    ORDER BY b.name_en;

--

CREATE FUNCTION public.get_all_breaks(p_date_from date DEFAULT NULL::date, p_date_to date DEFAULT NULL::date, p_branch_id integer DEFAULT NULL::integer, p_status character varying DEFAULT NULL::character varying) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result JSONB;

--

CREATE FUNCTION public.get_all_delivery_tiers() RETURNS TABLE(id uuid, min_order_amount numeric, max_order_amount numeric, delivery_fee numeric, tier_order integer, is_active boolean, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id,
        t.min_order_amount,
        t.max_order_amount,
        t.delivery_fee,
        t.tier_order,
        t.is_active,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
    ORDER BY t.tier_order ASC;

--

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

--

CREATE FUNCTION public.get_all_products_master() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result jsonb;

--

CREATE FUNCTION public.get_all_receiving_tasks() RETURNS TABLE(id uuid, receiving_record_id uuid, template_id uuid, role_type character varying, title text, description text, priority character varying, task_status character varying, task_completed boolean, due_date timestamp with time zone, assigned_user_id uuid, completed_at timestamp with time zone, completed_by_user_id uuid, clearance_certificate_url text, created_at timestamp with time zone, bill_number character varying, bill_amount numeric, vendor_name text, branch_name text, assigned_user_name text, completed_by_user_name text, is_overdue boolean, days_until_due integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    rt.id,
    rt.receiving_record_id,
    rt.template_id,
    rt.role_type,
    rt.title,
    rt.description,
    rt.priority,
    rt.task_status,
    rt.task_completed,
    rt.due_date,
    rt.assigned_user_id,
    rt.completed_at,
    rt.completed_by_user_id,
    rt.clearance_certificate_url,
    rt.created_at,
    -- Receiving record details
    rr.bill_number,
    rr.bill_amount,
    v.vendor_name,
    b.name_en as branch_name,
    -- User details
    u1.username as assigned_user_name,
    u2.username as completed_by_user_name,
    -- Calculated fields
    (rt.due_date < NOW() AND rt.task_status != 'completed') as is_overdue,
    EXTRACT(DAY FROM (rt.due_date - NOW()))::INTEGER as days_until_due
  FROM receiving_tasks rt
  LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  LEFT JOIN users u1 ON u1.id = rt.assigned_user_id
  LEFT JOIN users u2 ON u2.id = rt.completed_by_user_id
  ORDER BY rt.created_at DESC, rt.priority DESC;

--

CREATE FUNCTION public.get_all_users() RETURNS TABLE(id uuid, username character varying, email character varying, role_type character varying, status character varying, employee_id uuid, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.username,
        u.email,
        -- Use admin flags instead of role_type column
        CASE 
            WHEN u.is_master_admin THEN 'Master Admin'::VARCHAR
            WHEN u.is_admin THEN 'Admin'::VARCHAR
            ELSE 'User'::VARCHAR
        END as role_type,
        'active'::VARCHAR as status,
        u.employee_id,
        u.created_at,
        u.updated_at
    FROM users u
    WHERE u.deleted_at IS NULL
    ORDER BY u.created_at DESC;

--

CREATE FUNCTION public.get_analytics_log_tables() RETURNS TABLE(table_name text, total_size text, raw_size bigint, row_estimate bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    r.tablename AS table_name,
    r.total_size,
    r.raw_size,
    r.row_estimate
  FROM dblink(
    'dbname=_supabase user=supabase_admin',
    'SELECT
      t.tablename::text,
      pg_size_pretty(pg_total_relation_size(quote_ident(t.schemaname) || ''.'' || quote_ident(t.tablename)))::text AS total_size,
      pg_total_relation_size(quote_ident(t.schemaname) || ''.'' || quote_ident(t.tablename)) AS raw_size,
      COALESCE(c.reltuples, 0)::bigint AS row_estimate
    FROM pg_tables t
    LEFT JOIN pg_class c ON c.relname = t.tablename AND c.relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = t.schemaname)
    WHERE t.schemaname = ''_analytics'' AND t.tablename LIKE ''log_events_%''
    ORDER BY pg_total_relation_size(quote_ident(t.schemaname) || ''.'' || quote_ident(t.tablename)) DESC'
  ) AS r(tablename text, total_size text, raw_size bigint, row_estimate bigint);

--

CREATE FUNCTION public.get_approval_center_data(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_permissions JSONB;

--

CREATE FUNCTION public.get_assignments_with_deadlines(user_id uuid DEFAULT NULL::uuid, days_ahead integer DEFAULT 7) RETURNS TABLE(id uuid, task_id uuid, task_title character varying, assigned_to uuid, assignee_name character varying, due_date date, priority character varying, status character varying, days_until_due integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ta.id,
        t.id as task_id,
        t.title as task_title,
        ta.assigned_to,
        u.username as assignee_name,
        t.due_date,
        ta.priority,
        ta.status,
        (t.due_date - CURRENT_DATE)::INTEGER as days_until_due
    FROM task_assignments ta
    JOIN tasks t ON ta.task_id = t.id
    LEFT JOIN users u ON ta.assigned_to = u.id
    WHERE (user_id IS NULL OR ta.assigned_to = user_id)
      AND t.due_date IS NOT NULL
      AND t.due_date <= CURRENT_DATE + INTERVAL '1 day' * days_ahead
      AND ta.status != 'completed'
      AND t.deleted_at IS NULL
    ORDER BY t.due_date ASC;

--

CREATE FUNCTION public.get_assignments_with_deadlines(p_user_id text DEFAULT NULL::text, p_branch_id uuid DEFAULT NULL::uuid, p_include_overdue boolean DEFAULT true, p_days_ahead integer DEFAULT 7) RETURNS TABLE(assignment_id uuid, task_id uuid, task_title text, task_description text, task_priority text, assignment_status text, assigned_to_user_id text, assigned_to_branch_id uuid, deadline_datetime timestamp with time zone, schedule_date date, schedule_time time without time zone, is_overdue boolean, hours_until_deadline numeric, is_reassignable boolean, notes text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ta.id as assignment_id,
        t.id as task_id,
        t.title as task_title,
        t.description as task_description,
        COALESCE(ta.priority_override, t.priority) as task_priority,
        ta.status as assignment_status,
        ta.assigned_to_user_id,
        ta.assigned_to_branch_id,
        ta.deadline_datetime,
        ta.schedule_date,
        ta.schedule_time,
        CASE 
            WHEN ta.deadline_datetime IS NOT NULL AND ta.deadline_datetime < now() 
                AND ta.status NOT IN ('completed', 'cancelled') 
            THEN true 
            ELSE false 
        END as is_overdue,
        CASE 
            WHEN ta.deadline_datetime IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (ta.deadline_datetime - now()))/3600 
            ELSE NULL 
        END as hours_until_deadline,
        ta.is_reassignable,
        ta.notes,
        ta.require_task_finished,
        ta.require_photo_upload,
        ta.require_erp_reference
    FROM public.task_assignments ta
    JOIN public.tasks t ON ta.task_id = t.id
    WHERE 
        (p_user_id IS NULL OR ta.assigned_to_user_id = p_user_id) AND
        (p_branch_id IS NULL OR ta.assigned_to_branch_id = p_branch_id) AND
        ta.status NOT IN ('cancelled', 'reassigned') AND
        (
            p_include_overdue = true OR 
            ta.deadline_datetime IS NULL OR 
            ta.deadline_datetime >= now()
        ) AND
        (
            ta.deadline_datetime IS NULL OR 
            ta.deadline_datetime <= now() + (p_days_ahead || ' days')::interval
        )
    ORDER BY 
        CASE WHEN ta.deadline_datetime IS NOT NULL AND ta.deadline_datetime < now() THEN 1 ELSE 2 END,
        ta.deadline_datetime ASC NULLS LAST,
        ta.assigned_at DESC;

--

CREATE FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) RETURNS TABLE(branch_id bigint, branch_name_en text, branch_name_ar text, minimum_order_amount numeric, delivery_service_enabled boolean, delivery_is_24_hours boolean, delivery_start_time time without time zone, delivery_end_time time without time zone, pickup_service_enabled boolean, pickup_is_24_hours boolean, pickup_start_time time without time zone, pickup_end_time time without time zone, delivery_message_ar text, delivery_message_en text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.id,
        b.name_en::text,
        b.name_ar::text,
        COALESCE(b.minimum_order_amount, 15.00)::numeric,
        COALESCE(b.delivery_service_enabled, true)::boolean,
        COALESCE(b.delivery_is_24_hours, true)::boolean,
        b.delivery_start_time,
        b.delivery_end_time,
        COALESCE(b.pickup_service_enabled, true)::boolean,
        COALESCE(b.pickup_is_24_hours, true)::boolean,
        b.pickup_start_time,
        b.pickup_end_time,
        COALESCE(b.delivery_message_ar, 'التوصيل متاح على مدار الساعة')::text,
        COALESCE(b.delivery_message_en, 'Delivery available 24/7')::text
    FROM public.branches b
    WHERE b.id = p_branch_id
    LIMIT 1;

--

CREATE FUNCTION public.get_branch_performance_dashboard(p_days_back integer DEFAULT 30, p_specific_date date DEFAULT NULL::date) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_from timestamp;

--

CREATE FUNCTION public.get_branch_promissory_notes_summary(branch_uuid uuid) RETURNS TABLE(total_notes integer, total_active_amount numeric, total_collected_amount numeric, active_notes_count integer, collected_notes_count integer, cancelled_notes_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_notes,
        COALESCE(SUM(CASE WHEN status = 'active' THEN amount ELSE 0 END), 0) as total_active_amount,
        COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END), 0) as total_collected_amount,
        COUNT(CASE WHEN status = 'active' THEN 1 END)::INTEGER as active_notes_count,
        COUNT(CASE WHEN status = 'collected' THEN 1 END)::INTEGER as collected_notes_count,
        COUNT(CASE WHEN status = 'cancelled' THEN 1 END)::INTEGER as cancelled_notes_count
    FROM promissory_notes 
    WHERE branch_id = branch_uuid;

--

CREATE FUNCTION public.get_branch_service_availability(branch_id uuid) RETURNS TABLE(delivery_enabled boolean, pickup_enabled boolean, branch_name_en text, branch_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.delivery_service_enabled,
        b.pickup_service_enabled,
        b.name_en,
        b.name_ar
    FROM public.branches b
    WHERE b.id = branch_id
    LIMIT 1;

--

CREATE FUNCTION public.get_branch_visits_summary(branch_uuid uuid, start_date date DEFAULT CURRENT_DATE, end_date date DEFAULT (CURRENT_DATE + '30 days'::interval)) RETURNS TABLE(total_visits integer, scheduled_visits integer, confirmed_visits integer, completed_visits integer, high_priority_visits integer, visits_requiring_followup integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_visits,
        COUNT(CASE WHEN status = 'scheduled' THEN 1 END)::INTEGER as scheduled_visits,
        COUNT(CASE WHEN status = 'confirmed' THEN 1 END)::INTEGER as confirmed_visits,
        COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER as completed_visits,
        COUNT(CASE WHEN priority IN ('high', 'urgent') THEN 1 END)::INTEGER as high_priority_visits,
        COUNT(CASE WHEN follow_up_required = true THEN 1 END)::INTEGER as visits_requiring_followup
    FROM vendor_visits 
    WHERE branch_id = branch_uuid 
    AND visit_date BETWEEN start_date AND end_date;

--

CREATE FUNCTION public.get_break_summary_all_employees(p_date_from date DEFAULT NULL::date, p_date_to date DEFAULT NULL::date, p_branch_id integer DEFAULT NULL::integer) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_date_from DATE;

--

CREATE FUNCTION public.get_bt_assigned_ims(p_request_ids uuid[]) RETURNS TABLE(product_request_id uuid, assigned_to_user_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        qt.product_request_id,
        qta.assigned_to_user_id
    FROM quick_tasks qt
    INNER JOIN quick_task_assignments qta ON qta.quick_task_id = qt.id
    WHERE qt.product_request_type = 'BT'
    AND qt.product_request_id = ANY(p_request_ids);

--

CREATE FUNCTION public.get_bt_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, from_branch_id integer, to_branch_id integer, target_user_id uuid, status character varying, items jsonb, document_url text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, from_branch_name_en text, from_branch_name_ar text, from_branch_location_en text, from_branch_location_ar text, to_branch_name_en text, to_branch_name_ar text, to_branch_location_en text, to_branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.from_branch_id,
        r.to_branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.document_url,
        r.created_at,
        r.updated_at,
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        COALESCE(fb.name_en, '')::TEXT AS from_branch_name_en,
        COALESCE(fb.name_ar, fb.name_en, '')::TEXT AS from_branch_name_ar,
        COALESCE(fb.location_en, '')::TEXT AS from_branch_location_en,
        COALESCE(fb.location_ar, fb.location_en, '')::TEXT AS from_branch_location_ar,
        COALESCE(tb.name_en, '')::TEXT AS to_branch_name_en,
        COALESCE(tb.name_ar, tb.name_en, '')::TEXT AS to_branch_name_ar,
        COALESCE(tb.location_en, '')::TEXT AS to_branch_location_en,
        COALESCE(tb.location_ar, tb.location_en, '')::TEXT AS to_branch_location_ar
    FROM product_request_bt r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches fb ON fb.id = r.from_branch_id
    LEFT JOIN branches tb ON tb.id = r.to_branch_id
    ORDER BY r.created_at DESC;

--

CREATE FUNCTION public.get_campaign_statistics(p_campaign_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_stats JSONB;

--

CREATE FUNCTION public.get_cart_tier_discount(p_offer_id integer, p_cart_amount numeric) RETURNS TABLE(tier_number integer, discount_type character varying, discount_value numeric, min_amount numeric, max_amount numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.tier_number,
        t.discount_type,
        t.discount_value,
        t.min_amount,
        t.max_amount
    FROM offer_cart_tiers t
    WHERE t.offer_id = p_offer_id
      AND p_cart_amount >= t.min_amount
      AND (t.max_amount IS NULL OR p_cart_amount <= t.max_amount)
    ORDER BY t.tier_number DESC
    LIMIT 1;

--

CREATE FUNCTION public.get_completed_receiving_tasks() RETURNS TABLE(id uuid, receiving_record_id uuid, template_id uuid, role_type character varying, title text, description text, priority character varying, task_status character varying, task_completed boolean, due_date timestamp with time zone, assigned_user_id uuid, completed_at timestamp with time zone, completed_by_user_id uuid, clearance_certificate_url text, created_at timestamp with time zone, bill_number character varying, bill_amount numeric, vendor_name text, branch_name text, assigned_user_name text, completed_by_user_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    rt.id,
    rt.receiving_record_id,
    rt.template_id,
    rt.role_type,
    rt.title,
    rt.description,
    rt.priority,
    rt.task_status,
    rt.task_completed,
    rt.due_date,
    rt.assigned_user_id,
    rt.completed_at,
    rt.completed_by_user_id,
    rt.clearance_certificate_url,
    rt.created_at,
    rr.bill_number,
    rr.bill_amount,
    v.vendor_name,
    b.name_en as branch_name,
    u1.username as assigned_user_name,
    u2.username as completed_by_user_name
  FROM receiving_tasks rt
  LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  LEFT JOIN users u1 ON u1.id = rt.assigned_user_id
  LEFT JOIN users u2 ON u2.id = rt.completed_by_user_id
  WHERE rt.task_completed = true OR rt.task_status = 'completed'
  ORDER BY rt.completed_at DESC;

--

CREATE FUNCTION public.get_completed_tasks(p_limit integer DEFAULT 500) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;

--

CREATE FUNCTION public.get_current_user_id() RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN current_setting('app.current_user_id', true)::UUID;

--

CREATE FUNCTION public.get_customer_products_with_offers(p_branch_id text DEFAULT NULL::text, p_service_type text DEFAULT 'both'::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result json;

--

CREATE FUNCTION public.get_customer_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, branch_id integer, target_user_id uuid, status text, items jsonb, notes text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.notes,
        r.created_at,
        r.updated_at,
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        COALESCE(b.name_en, '')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, b.name_en, '')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, b.location_en, '')::TEXT AS branch_location_ar
    FROM customer_product_requests r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches b ON b.id = r.branch_id
    ORDER BY r.created_at DESC;

--

CREATE FUNCTION public.get_database_schema() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;

--

CREATE FUNCTION public.get_database_triggers() RETURNS TABLE(trigger_name text, event_manipulation text, event_object_table text, action_statement text, action_timing text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tg.trigger_name::text,
        tg.event_manipulation::text,
        tg.event_object_table::text,
        tg.action_statement::text,
        tg.action_timing::text
    FROM information_schema.triggers tg
    WHERE tg.trigger_schema = 'public'
    ORDER BY tg.event_object_table, tg.trigger_name;

--

CREATE FUNCTION public.get_day_offs_with_details(p_date_from date, p_date_to date) RETURNS TABLE(id text, employee_id text, employee_id_number text, employee_name_en text, employee_name_ar text, employee_email text, employee_whatsapp text, branch_id text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text, nationality_id text, nationality_name_en text, nationality_name_ar text, sponsorship_status text, employment_status text, day_off_date date, approval_status text, reason_en text, reason_ar text, document_url text, description text, is_deductible_on_salary boolean, approval_requested_at timestamp with time zone, day_off_reason_id text, approver_name_en text, approver_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        d.id::TEXT,
        d.employee_id::TEXT,
        COALESCE(e.id_number, '')::TEXT AS employee_id_number,
        COALESCE(e.name_en, 'N/A')::TEXT AS employee_name_en,
        COALESCE(e.name_ar, 'N/A')::TEXT AS employee_name_ar,
        COALESCE(e.email, '')::TEXT AS employee_email,
        COALESCE(e.whatsapp_number, '')::TEXT AS employee_whatsapp,
        e.current_branch_id::TEXT AS branch_id,
        COALESCE(b.name_en, 'N/A')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, 'N/A')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, '')::TEXT AS branch_location_ar,
        e.nationality_id::TEXT,
        COALESCE(n.name_en, 'N/A')::TEXT AS nationality_name_en,
        COALESCE(n.name_ar, 'N/A')::TEXT AS nationality_name_ar,
        e.sponsorship_status::TEXT,
        e.employment_status::TEXT,
        d.day_off_date,
        COALESCE(d.approval_status, 'pending')::TEXT AS approval_status,
        COALESCE(r.reason_en, 'N/A')::TEXT AS reason_en,
        COALESCE(r.reason_ar, 'N/A')::TEXT AS reason_ar,
        d.document_url::TEXT,
        d.description::TEXT,
        COALESCE(d.is_deductible_on_salary, false) AS is_deductible_on_salary,
        d.approval_requested_at,
        d.day_off_reason_id::TEXT,
        COALESCE(a.name_en, '')::TEXT AS approver_name_en,
        COALESCE(a.name_ar, '')::TEXT AS approver_name_ar
    FROM day_off d
    LEFT JOIN hr_employee_master e ON e.id = d.employee_id
    LEFT JOIN branches b ON b.id = e.current_branch_id
    LEFT JOIN nationalities n ON n.id = e.nationality_id
    LEFT JOIN day_off_reasons r ON r.id = d.day_off_reason_id
    LEFT JOIN hr_employee_master a ON a.user_id = d.approval_approved_by
    WHERE d.day_off_date >= p_date_from
      AND d.day_off_date <= p_date_to
    ORDER BY d.day_off_date DESC;

--

CREATE FUNCTION public.get_default_flyer_template() RETURNS TABLE(id uuid, name character varying, description text, first_page_image_url text, sub_page_image_urls text[], first_page_configuration jsonb, sub_page_configurations jsonb, metadata jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.id,
    t.name,
    t.description,
    t.first_page_image_url,
    t.sub_page_image_urls,
    t.first_page_configuration,
    t.sub_page_configurations,
    t.metadata
  FROM flyer_templates t
  WHERE t.is_default = true 
    AND t.is_active = true 
    AND t.deleted_at IS NULL
  LIMIT 1;

--

CREATE FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    calculated_fee numeric;

--

CREATE FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_fee numeric;

--

CREATE FUNCTION public.get_delivery_service_settings() RETURNS TABLE(minimum_order_amount numeric, is_24_hours boolean, operating_start_time time without time zone, operating_end_time time without time zone, is_active boolean, display_message_ar text, display_message_en text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.minimum_order_amount,
        s.is_24_hours,
        s.operating_start_time,
        s.operating_end_time,
        s.is_active,
        s.display_message_ar,
        s.display_message_en
    FROM public.delivery_service_settings s
    WHERE s.id = '00000000-0000-0000-0000-000000000001'::uuid
    LIMIT 1;

--

CREATE FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) RETURNS TABLE(id uuid, branch_id bigint, min_order_amount numeric, max_order_amount numeric, delivery_fee numeric, tier_order integer, is_active boolean, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- Strictly branch-specific tiers;

--

CREATE FUNCTION public.get_dependency_completion_photos(receiving_record_id_param uuid, dependency_role_types text[]) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  result_photos JSONB := '{}'::JSONB;

--

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

--

CREATE FUNCTION public.get_employee_basic_hours(p_employee_id bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    emp_basic_hours DECIMAL(4,2);

--

CREATE FUNCTION public.get_employee_basic_hours(p_employee_id uuid, p_date date DEFAULT CURRENT_DATE) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    basic_hours DECIMAL(4,2);

--

CREATE FUNCTION public.get_employee_document_category_stats(emp_id uuid) RETURNS TABLE(category public.document_category_enum, count bigint, total_days integer, latest_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.document_category::document_category_enum,
        COUNT(*)::BIGINT,
        SUM(COALESCE(d.category_days, 0))::INTEGER,
        MAX(d.upload_date)
    FROM hr_employee_documents d
    WHERE d.employee_id = emp_id 
      AND d.is_active = true 
      AND d.document_category IS NOT NULL
    GROUP BY d.document_category;

--

CREATE FUNCTION public.get_employee_schedules(p_employee_id bigint, p_start_date date, p_end_date date) RETURNS TABLE(schedule_id bigint, schedule_date date, start_time time without time zone, end_time time without time zone, hours numeric, is_overnight boolean, is_auto boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ds.id,
        ds.schedule_date,
        ds.scheduled_start_time,
        ds.scheduled_end_time,
        ds.scheduled_hours,
        ds.is_overnight,
        ds.is_auto_generated
    FROM duty_schedules ds
    WHERE ds.employee_id = p_employee_id
      AND ds.schedule_date >= p_start_date
      AND ds.schedule_date <= p_end_date
    ORDER BY ds.schedule_date;

--

CREATE FUNCTION public.get_employee_schedules(p_employee_id uuid, p_start_date date, p_end_date date) RETURNS TABLE(schedule_id uuid, schedule_date date, start_time time without time zone, end_time time without time zone, hours numeric, is_overnight boolean, is_auto boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ds.id,
        ds.schedule_date,
        ds.scheduled_start_time,
        ds.scheduled_end_time,
        ds.scheduled_hours,
        ds.is_overnight,
        ds.is_auto_generated
    FROM duty_schedules ds
    WHERE ds.employee_id = p_employee_id
      AND ds.schedule_date >= p_start_date
      AND ds.schedule_date <= p_end_date
    ORDER BY ds.schedule_date;

--

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

--

CREATE FUNCTION public.get_expiring_products_count(p_employee_id text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_branch_id INTEGER;

--

CREATE FUNCTION public.get_file_extension(filename text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN lower(split_part(filename, '.', array_length(string_to_array(filename, '.'), 1)));

--

CREATE FUNCTION public.get_flyer_generator_data(p_offer_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;

--

CREATE FUNCTION public.get_incident_manager_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_result JSONB;

--

CREATE FUNCTION public.get_incomplete_receiving_tasks() RETURNS TABLE(id uuid, receiving_record_id uuid, template_id uuid, role_type character varying, title text, description text, priority character varying, task_status character varying, task_completed boolean, due_date timestamp with time zone, assigned_user_id uuid, completed_at timestamp with time zone, completed_by_user_id uuid, clearance_certificate_url text, created_at timestamp with time zone, bill_number character varying, bill_amount numeric, vendor_name text, branch_name text, assigned_user_name text, is_overdue boolean, days_until_due integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    rt.id,
    rt.receiving_record_id,
    rt.template_id,
    rt.role_type,
    rt.title,
    rt.description,
    rt.priority,
    rt.task_status,
    rt.task_completed,
    rt.due_date,
    rt.assigned_user_id,
    rt.completed_at,
    rt.completed_by_user_id,
    rt.clearance_certificate_url,
    rt.created_at,
    rr.bill_number,
    rr.bill_amount,
    v.vendor_name,
    b.name_en as branch_name,
    u1.username as assigned_user_name,
    (rt.due_date < NOW() AND rt.task_status != 'completed') as is_overdue,
    EXTRACT(DAY FROM (rt.due_date - NOW()))::INTEGER as days_until_due
  FROM receiving_tasks rt
  LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  LEFT JOIN users u1 ON u1.id = rt.assigned_user_id
  WHERE rt.task_completed = false AND rt.task_status != 'completed'
  ORDER BY rt.due_date ASC, rt.priority DESC;

--

CREATE FUNCTION public.get_incomplete_receiving_tasks_breakdown() RETURNS TABLE(total_receiving_tasks integer, incomplete_receiving_tasks integer, missing_task_completions integer, incomplete_task_completions integer, tasks_not_completed integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH stats AS (
        SELECT 
            COUNT(*) as total_tasks,
            COUNT(CASE WHEN rt.task_completed = false OR t.status != 'completed' THEN 1 END) as incomplete_tasks,
            COUNT(CASE WHEN tc.id IS NULL THEN 1 END) as missing_completions,
            COUNT(CASE WHEN tc.id IS NOT NULL AND tc.task_finished_completed = false THEN 1 END) as incomplete_completions,
            COUNT(CASE WHEN t.status != 'completed' THEN 1 END) as tasks_not_completed
        FROM receiving_tasks rt
        LEFT JOIN tasks t ON rt.task_id = t.id
        LEFT JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
    )
    SELECT 
        s.total_tasks::INTEGER,
        s.incomplete_tasks::INTEGER,
        s.missing_completions::INTEGER,
        s.incomplete_completions::INTEGER,
        s.tasks_not_completed::INTEGER
    FROM stats s;

--

CREATE FUNCTION public.get_incomplete_tasks() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;

--

CREATE FUNCTION public.get_lease_rent_properties_with_spaces() RETURNS TABLE(property_id uuid, property_name_en character varying, property_name_ar character varying, property_location_en character varying, property_location_ar character varying, property_is_leased boolean, property_is_rented boolean, space_id uuid, space_number character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS property_id,
        p.name_en AS property_name_en,
        p.name_ar AS property_name_ar,
        p.location_en AS property_location_en,
        p.location_ar AS property_location_ar,
        p.is_leased AS property_is_leased,
        p.is_rented AS property_is_rented,
        s.id AS space_id,
        s.space_number AS space_number
    FROM lease_rent_properties p
    LEFT JOIN lease_rent_property_spaces s ON s.property_id = p.id
    ORDER BY p.name_en, s.space_number;

--

CREATE FUNCTION public.get_lease_rent_tab_data(p_party_type text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    parties_json JSON;

--

CREATE FUNCTION public.get_mobile_dashboard_data(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_employee_id TEXT;

--

CREATE FUNCTION public.get_my_assignments(p_user_id uuid, p_limit integer DEFAULT 500) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;

--

CREATE FUNCTION public.get_my_tasks(p_user_id uuid, p_include_completed boolean DEFAULT false, p_limit integer DEFAULT 500) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;

--

CREATE FUNCTION public.get_next_delivery_tier(current_amount numeric) RETURNS TABLE(next_tier_min_amount numeric, next_tier_delivery_fee numeric, amount_needed numeric, potential_savings numeric, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    current_fee numeric;

--

CREATE FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) RETURNS TABLE(next_tier_min_amount numeric, next_tier_delivery_fee numeric, amount_needed numeric, potential_savings numeric, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_current_fee numeric;

--

CREATE FUNCTION public.get_next_product_serial() RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    next_number INTEGER;

--

CREATE FUNCTION public.get_offer_products_data(p_exclude_offer_id integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result json;

--

CREATE FUNCTION public.get_offer_variation_summary(p_offer_id integer) RETURNS TABLE(variation_group_id uuid, parent_barcode text, group_name_en text, group_name_ar text, selected_count integer, total_count integer, has_price_mismatch boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH variation_groups AS (
    SELECT DISTINCT 
      op.variation_group_id,
      op.variation_parent_barcode
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.is_part_of_variation_group = true
      AND op.variation_group_id IS NOT NULL
  ),
  selected_variations AS (
    SELECT 
      op.variation_group_id,
      COUNT(DISTINCT op.product_id) as selected_count,
      COUNT(DISTINCT op.offer_price) as price_count,
      COUNT(DISTINCT op.offer_percentage) as percentage_count
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.variation_group_id IS NOT NULL
    GROUP BY op.variation_group_id
  ),
  total_variations AS (
    SELECT 
      vg.variation_group_id,
      COUNT(DISTINCT p.id) as total_count
    FROM variation_groups vg
    JOIN products p ON p.parent_product_barcode = vg.variation_parent_barcode
      OR p.barcode = vg.variation_parent_barcode
    WHERE p.is_variation = true
    GROUP BY vg.variation_group_id
  )
  SELECT 
    vg.variation_group_id,
    vg.variation_parent_barcode as parent_barcode,
    p.variation_group_name_en as group_name_en,
    p.variation_group_name_ar as group_name_ar,
    sv.selected_count::INTEGER,
    tv.total_count::INTEGER,
    CASE 
      WHEN sv.price_count > 1 OR sv.percentage_count > 1 THEN true
      ELSE false
    END as has_price_mismatch
  FROM variation_groups vg
  JOIN products p ON p.barcode = vg.variation_parent_barcode
  LEFT JOIN selected_variations sv ON sv.variation_group_id = vg.variation_group_id
  LEFT JOIN total_variations tv ON tv.variation_group_id = vg.variation_group_id
  ORDER BY p.variation_group_name_en;

--

CREATE FUNCTION public.get_or_create_app_function(p_function_code text, p_function_name text DEFAULT NULL::text, p_description text DEFAULT NULL::text, p_category text DEFAULT 'Application'::text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    function_id UUID;

--

CREATE FUNCTION public.get_party_payment_data(p_party_type text, p_party_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN json_build_object(
        'changes', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_special_changes
                WHERE party_type = p_party_type AND party_id = p_party_id
                ORDER BY effective_from ASC
            ) sub
        ),
        'entries', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_payment_entries
                WHERE party_type = p_party_type AND party_id = p_party_id
                ORDER BY created_at ASC
            ) sub
        )
    );

--

CREATE FUNCTION public.get_po_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, from_branch_id integer, target_user_id uuid, status character varying, items jsonb, document_url text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.from_branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.document_url,
        r.created_at,
        r.updated_at,
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        COALESCE(b.name_en, '')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, b.name_en, '')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, b.location_en, '')::TEXT AS branch_location_ar
    FROM product_request_po r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches b ON b.id = r.from_branch_id
    ORDER BY r.created_at DESC;

--

CREATE FUNCTION public.get_product_master_init_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_total_products int;

--

CREATE FUNCTION public.get_product_offers(p_product_id uuid) RETURNS TABLE(offer_id integer, offer_name_en text, offer_name_ar text, offer_type text, discount_type text, offer_qty integer, offer_percentage numeric, offer_price numeric, original_price numeric, savings numeric, end_date timestamp with time zone, service_type text, branch_id integer)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    o.id AS offer_id,
    o.name_en AS offer_name_en,
    o.name_ar AS offer_name_ar,
    o.type AS offer_type,
    o.discount_type,
    op.offer_qty,
    op.offer_percentage,
    op.offer_price,
    p.sale_price AS original_price,
    CASE 
      WHEN op.offer_percentage IS NOT NULL THEN 
        (p.sale_price * op.offer_qty) - ((p.sale_price * op.offer_qty) * (1 - op.offer_percentage / 100))
      WHEN op.offer_price IS NOT NULL THEN 
        (p.sale_price * op.offer_qty) - op.offer_price
      ELSE 0
    END AS savings,
    o.end_date,
    o.service_type,
    o.branch_id
  FROM offers o
  INNER JOIN offer_products op ON o.id = op.offer_id
  INNER JOIN products p ON op.product_id = p.id
  WHERE op.product_id = p_product_id
    AND o.is_active = true
    AND o.type = 'product'
    AND o.start_date <= NOW()
    AND o.end_date >= NOW()
  ORDER BY savings DESC;

--

CREATE FUNCTION public.get_product_variations(p_barcode text) RETURNS TABLE(id character varying, barcode text, product_name_en text, product_name_ar text, unit_name text, image_url text, variation_order integer, is_parent boolean, parent_barcode text, group_name_en text, group_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH target_product AS (
    SELECT 
      COALESCE(p.parent_product_barcode, p.barcode) as parent_ref
    FROM products p
    WHERE p.barcode = p_barcode
  )
  SELECT 
    p.id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    pu.name_en as unit_name,
    p.image_url,
    p.variation_order,
    (p.barcode = (SELECT parent_ref FROM target_product)) as is_parent,
    p.parent_product_barcode as parent_barcode,
    p.variation_group_name_en as group_name_en,
    p.variation_group_name_ar as group_name_ar
  FROM products p
  LEFT JOIN product_units pu ON p.unit_id = pu.id
  WHERE p.is_variation = true
    AND (p.parent_product_barcode = (SELECT parent_ref FROM target_product)
         OR p.barcode = (SELECT parent_ref FROM target_product))
  ORDER BY p.variation_order ASC, p.product_name_en ASC;

--

CREATE FUNCTION public.get_products_in_active_offers() RETURNS TABLE(product_id uuid, offer_id integer, offer_name_en text, offer_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    op.product_id,
    o.id AS offer_id,
    o.name_en AS offer_name_en,
    o.name_ar AS offer_name_ar
  FROM offer_products op
  INNER JOIN offers o ON op.offer_id = o.id
  WHERE o.is_active = true
    AND o.type = 'product'
    AND o.start_date <= NOW()
    AND o.end_date >= NOW();

--

CREATE FUNCTION public.get_quick_access_stats() RETURNS TABLE(total_codes bigint, active_codes bigint, unused_codes bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_codes,
        COUNT(CASE WHEN status = 'active' THEN 1 END)::BIGINT as active_codes,
        COUNT(CASE WHEN quick_access_code IS NOT NULL AND last_login_at IS NULL THEN 1 END)::BIGINT as unused_codes
    FROM users
    WHERE deleted_at IS NULL;

--

CREATE FUNCTION public.get_quick_expiry_report(days_threshold integer DEFAULT 15) RETURNS TABLE(branch_id integer, barcode character varying, product_name_en character varying, product_name_ar character varying, expiry_date date, days_left integer)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    (entry->>'branch_id')::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    (entry->>'expiry_date')::date AS expiry_date,
    ((entry->>'expiry_date')::date - CURRENT_DATE) AS days_left
  FROM erp_synced_products p,
    jsonb_array_elements(p.expiry_dates) AS entry
  WHERE jsonb_array_length(p.expiry_dates) > 0
    AND (p.expiry_hidden IS NOT TRUE)
    AND (entry->>'expiry_date') IS NOT NULL
    AND (entry->>'branch_id') IS NOT NULL
    AND ((entry->>'expiry_date')::date - CURRENT_DATE) <= days_threshold
  ORDER BY p.barcode, ((entry->>'expiry_date')::date - CURRENT_DATE) ASC;

--

CREATE FUNCTION public.get_quick_task_completion_stats() RETURNS TABLE(total_completions bigint, submitted_count bigint, verified_count bigint, rejected_count bigint, pending_review_count bigint, completions_with_photos bigint, completions_with_erp bigint, avg_verification_time interval)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_completions,
        COUNT(*) FILTER (WHERE completion_status = 'submitted') as submitted_count,
        COUNT(*) FILTER (WHERE completion_status = 'verified') as verified_count,
        COUNT(*) FILTER (WHERE completion_status = 'rejected') as rejected_count,
        COUNT(*) FILTER (WHERE completion_status = 'pending_review') as pending_review_count,
        COUNT(*) FILTER (WHERE photo_path IS NOT NULL) as completions_with_photos,
        COUNT(*) FILTER (WHERE erp_reference IS NOT NULL) as completions_with_erp,
        AVG(verified_at - created_at) FILTER (WHERE verified_at IS NOT NULL) as avg_verification_time
    FROM quick_task_completions;

--

CREATE FUNCTION public.get_receiving_task_statistics(branch_id_param integer DEFAULT NULL::integer, date_from date DEFAULT NULL::date, date_to date DEFAULT NULL::date) RETURNS TABLE(total_tasks bigint, pending_tasks bigint, in_progress_tasks bigint, completed_tasks bigint, overdue_tasks bigint, high_priority_tasks bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_tasks,
        COUNT(*) FILTER (WHERE t.status = 'pending') as pending_tasks,
        COUNT(*) FILTER (WHERE t.status = 'in_progress') as in_progress_tasks,
        COUNT(*) FILTER (WHERE t.status = 'completed') as completed_tasks,
        COUNT(*) FILTER (WHERE t.status != 'completed' AND t.due_datetime < NOW()) as overdue_tasks,
        COUNT(*) FILTER (WHERE t.priority = 'high') as high_priority_tasks
    FROM tasks t
    LEFT JOIN receiving_records rr ON rr.id::text = SUBSTRING(t.description FROM 'receiving record ([0-9a-f-]+)')
    WHERE t.description LIKE '%receiving record%'
    AND (branch_id_param IS NULL OR rr.branch_id = branch_id_param)
    AND (date_from IS NULL OR DATE(t.created_at) >= date_from)
    AND (date_to IS NULL OR DATE(t.created_at) <= date_to);

--

CREATE FUNCTION public.get_receiving_task_statistics(branch_id_param integer DEFAULT NULL::integer, date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, date_to timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS TABLE(total_tasks bigint, completed_tasks bigint, pending_tasks bigint, overdue_tasks bigint, tasks_by_role jsonb, completion_rate numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_tasks,
        COUNT(*) FILTER (WHERE task_completed = true) as completed_tasks,
        COUNT(*) FILTER (WHERE task_completed = false) as pending_tasks,
        COUNT(*) FILTER (WHERE is_overdue = true AND task_completed = false) as overdue_tasks,
        jsonb_object_agg(
            role_type, 
            jsonb_build_object(
                'total', role_count,
                'completed', role_completed
            )
        ) as tasks_by_role,
        CASE 
            WHEN COUNT(*) > 0 THEN 
                ROUND((COUNT(*) FILTER (WHERE task_completed = true) * 100.0) / COUNT(*), 2)
            ELSE 0
        END as completion_rate
    FROM (
        SELECT 
            rtd.role_type,
            rtd.task_completed,
            rtd.is_overdue,
            COUNT(*) OVER (PARTITION BY rtd.role_type) as role_count,
            COUNT(*) FILTER (WHERE rtd.task_completed = true) OVER (PARTITION BY rtd.role_type) as role_completed
        FROM receiving_tasks_detailed rtd
        WHERE (branch_id_param IS NULL OR rtd.branch_id = branch_id_param)
          AND (date_from IS NULL OR rtd.created_at >= date_from)
          AND (date_to IS NULL OR rtd.created_at <= date_to)
    ) stats
    GROUP BY ();

--

CREATE FUNCTION public.get_receiving_tasks_for_user(p_user_id uuid, p_completed_days integer DEFAULT 7) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_my_tasks json;

--

CREATE FUNCTION public.get_reminder_statistics(p_user_id uuid DEFAULT NULL::uuid, p_days integer DEFAULT 30) RETURNS TABLE(total_reminders bigint, reminders_today bigint, reminders_this_week bigint, reminders_this_month bigint, avg_hours_overdue numeric, most_overdue_task text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  WITH stats AS (
    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE DATE(reminder_sent_at) = CURRENT_DATE) as today,
      COUNT(*) FILTER (WHERE reminder_sent_at >= CURRENT_DATE - INTERVAL '7 days') as week,
      COUNT(*) FILTER (WHERE reminder_sent_at >= CURRENT_DATE - INTERVAL '30 days') as month,
      AVG(hours_overdue) as avg_overdue
    FROM task_reminder_logs
    WHERE (p_user_id IS NULL OR assigned_to_user_id = p_user_id)
      AND reminder_sent_at >= CURRENT_DATE - (p_days || ' days')::INTERVAL
  ),
  most_overdue AS (
    SELECT task_title
    FROM task_reminder_logs
    WHERE (p_user_id IS NULL OR assigned_to_user_id = p_user_id)
    ORDER BY hours_overdue DESC NULLS LAST
    LIMIT 1
  )
  SELECT 
    COALESCE(s.total, 0),
    COALESCE(s.today, 0),
    COALESCE(s.week, 0),
    COALESCE(s.month, 0),
    ROUND(COALESCE(s.avg_overdue, 0), 1),
    COALESCE(m.task_title, 'N/A')
  FROM stats s
  CROSS JOIN most_overdue m;

--

CREATE FUNCTION public.get_report_data(p_party_type text, p_party_ids uuid[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN json_build_object(
        'entries', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_payment_entries
                WHERE party_type = p_party_type AND party_id = ANY(p_party_ids)
                ORDER BY created_at ASC
            ) sub
        ),
        'changes', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_special_changes
                WHERE party_type = p_party_type AND party_id = ANY(p_party_ids)
                ORDER BY created_at DESC
            ) sub
        )
    );

--

CREATE FUNCTION public.get_report_party_paid_totals(p_party_type text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN (
        SELECT COALESCE(json_object_agg(party_id, total_paid), '{}'::json)
        FROM (
            SELECT party_id, SUM(amount)::numeric as total_paid
            FROM lease_rent_payment_entries
            WHERE party_type = p_party_type
            GROUP BY party_id
        ) sub
    );

--

CREATE FUNCTION public.get_stock_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, branch_id integer, target_user_id uuid, status character varying, items jsonb, document_url text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.document_url,
        r.created_at,
        r.updated_at,
        -- Requester name
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        -- Target name
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        -- Branch info
        COALESCE(b.name_en, '')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, b.name_en, '')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, b.location_en, '')::TEXT AS branch_location_ar
    FROM product_request_st r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches b ON b.id = r.branch_id
    ORDER BY r.created_at DESC;

--

CREATE FUNCTION public.get_task_dashboard(user_id_param text DEFAULT NULL::text, branch_id_param uuid DEFAULT NULL::uuid) RETURNS TABLE(total_tasks bigint, my_tasks bigint, completed_today bigint, overdue_count bigint, high_priority_count bigint, recent_completions json)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*) FROM tasks WHERE deleted_at IS NULL) as total_tasks,
        (
            SELECT COUNT(DISTINCT ta.task_id) 
            FROM task_assignments ta 
            JOIN tasks t ON ta.task_id = t.id
            WHERE (ta.assigned_to_user_id = user_id_param OR ta.assignment_type = 'all' 
                   OR (ta.assignment_type = 'branch' AND ta.assigned_to_branch_id = branch_id_param))
            AND t.deleted_at IS NULL
        ) as my_tasks,
        (
            SELECT COUNT(*) 
            FROM task_completions tc 
            JOIN tasks t ON tc.task_id = t.id
            WHERE tc.completed_by = user_id_param 
            AND tc.completed_at::date = CURRENT_DATE
            AND t.deleted_at IS NULL
        ) as completed_today,
        (SELECT COUNT(*) FROM tasks WHERE due_date < CURRENT_DATE AND status IN ('active', 'draft', 'paused') AND deleted_at IS NULL) as overdue_count,
        (SELECT COUNT(*) FROM tasks WHERE priority = 'high' AND status IN ('active', 'draft', 'paused') AND deleted_at IS NULL) as high_priority_count,
        (
            SELECT json_agg(json_build_object(
                'task_id', tc.task_id,
                'task_title', t.title,
                'completed_at', tc.completed_at,
                'completed_by_name', tc.completed_by_name
            ))
            FROM task_completions tc
            JOIN tasks t ON tc.task_id = t.id
            WHERE tc.completed_at >= CURRENT_DATE - INTERVAL '7 days'
            AND t.deleted_at IS NULL
            ORDER BY tc.completed_at DESC
            LIMIT 10
        ) as recent_completions;

--

CREATE FUNCTION public.get_task_master_stats(p_user_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;

--

CREATE FUNCTION public.get_task_statistics(user_id_param text DEFAULT NULL::text) RETURNS TABLE(total_tasks bigint, active_tasks bigint, completed_tasks bigint, draft_tasks bigint, paused_tasks bigint, cancelled_tasks bigint, my_assigned_tasks bigint, my_completed_tasks bigint, overdue_tasks bigint, due_today bigint, high_priority_tasks bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) FILTER (WHERE t.deleted_at IS NULL) as total_tasks,
        COUNT(*) FILTER (WHERE t.status = 'active' AND t.deleted_at IS NULL) as active_tasks,
        COUNT(*) FILTER (WHERE t.status = 'completed' AND t.deleted_at IS NULL) as completed_tasks,
        COUNT(*) FILTER (WHERE t.status = 'draft' AND t.deleted_at IS NULL) as draft_tasks,
        COUNT(*) FILTER (WHERE t.status = 'paused' AND t.deleted_at IS NULL) as paused_tasks,
        COUNT(*) FILTER (WHERE t.status = 'cancelled' AND t.deleted_at IS NULL) as cancelled_tasks,
        COUNT(DISTINCT ta.task_id) FILTER (WHERE (ta.assigned_to_user_id = user_id_param OR ta.assignment_type = 'all') AND t.deleted_at IS NULL) as my_assigned_tasks,
        COUNT(DISTINCT tc.task_id) FILTER (WHERE tc.completed_by = user_id_param AND t.deleted_at IS NULL) as my_completed_tasks,
        COUNT(*) FILTER (WHERE t.due_date < CURRENT_DATE AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as overdue_tasks,
        COUNT(*) FILTER (WHERE t.due_date = CURRENT_DATE AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as due_today,
        COUNT(*) FILTER (WHERE t.priority = 'high' AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as high_priority_tasks
    FROM public.tasks t
    LEFT JOIN public.task_assignments ta ON t.id = ta.task_id
    LEFT JOIN public.task_completions tc ON t.id = tc.task_id AND tc.completed_by = user_id_param;

--

CREATE FUNCTION public.get_task_statistics(user_id uuid DEFAULT NULL::uuid) RETURNS TABLE(total_tasks bigint, pending_tasks bigint, in_progress_tasks bigint, completed_tasks bigint, overdue_tasks bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_tasks,
        COUNT(CASE WHEN t.status = 'pending' THEN 1 END)::BIGINT as pending_tasks,
        COUNT(CASE WHEN t.status = 'in_progress' THEN 1 END)::BIGINT as in_progress_tasks,
        COUNT(CASE WHEN t.status = 'completed' THEN 1 END)::BIGINT as completed_tasks,
        COUNT(CASE WHEN t.status = 'overdue' THEN 1 END)::BIGINT as overdue_tasks
    FROM tasks t
    LEFT JOIN task_assignments ta ON t.id = ta.task_id
    WHERE (user_id IS NULL OR ta.assigned_to = user_id OR t.created_by = user_id)
      AND t.deleted_at IS NULL;

--

CREATE FUNCTION public.get_tasks_for_receiving_record(receiving_record_id_param uuid) RETURNS TABLE(task_id uuid, receiving_record_id uuid, role_type text, title text, description text, priority text, task_status text, task_completed boolean, due_date timestamp with time zone, created_at timestamp with time zone, completed_at timestamp with time zone, completed_by_user_id uuid, assigned_user_id uuid, requires_erp_reference boolean, requires_original_bill_upload boolean, erp_reference_number text, original_bill_uploaded boolean, original_bill_file_path text, clearance_certificate_url text, is_overdue boolean, days_until_due integer, bill_number text, vendor_name text, branch_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    rt.id AS task_id,
    rt.receiving_record_id,
    rt.role_type::TEXT,
    rt.title,
    rt.description,
    rt.priority::TEXT,
    rt.task_status::TEXT,
    rt.task_completed,
    rt.due_date,
    rt.created_at,
    rt.completed_at,
    rt.completed_by_user_id,
    rt.assigned_user_id,
    rt.requires_erp_reference,
    rt.requires_original_bill_upload,
    rt.erp_reference_number::TEXT,
    rt.original_bill_uploaded,
    rt.original_bill_file_path,
    rt.clearance_certificate_url,
    -- Calculate if overdue
    CASE 
      WHEN rt.task_completed = false AND rt.due_date < NOW() THEN true
      ELSE false
    END AS is_overdue,
    -- Calculate days until due
    CASE 
      WHEN rt.task_completed = false THEN 
        EXTRACT(DAY FROM (rt.due_date - NOW()))::INTEGER
      ELSE 
        NULL
    END AS days_until_due,
    rr.bill_number::TEXT,
    v.vendor_name::TEXT,
    b.name_en::TEXT AS branch_name
  FROM receiving_tasks rt
  LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  WHERE rt.receiving_record_id = receiving_record_id_param
  ORDER BY 
    CASE rt.task_status
      WHEN 'pending' THEN 1
      WHEN 'in_progress' THEN 2
      WHEN 'completed' THEN 3
      ELSE 4
    END,
    rt.due_date ASC;

--

CREATE FUNCTION public.get_todays_scheduled_visits(target_date date DEFAULT CURRENT_DATE) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, pattern_info text, notes text, branch_id uuid, vendor_id uuid, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date date, next_visit_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        CASE 
            WHEN vv.visit_type = 'weekly' THEN ('Weekly on ' || COALESCE(vv.weekday_name, ''))::TEXT
            WHEN vv.visit_type = 'daily' THEN ('Daily (' || COALESCE(vv.fresh_type, '') || ')')::TEXT
            WHEN vv.visit_type = 'monthly' THEN ('Monthly on day ' || COALESCE(vv.day_number::TEXT, ''))::TEXT
            WHEN vv.visit_type = 'skip_days' THEN ('Every ' || COALESCE(vv.skip_days::TEXT, '') || ' days')::TEXT
            ELSE vv.visit_type::TEXT
        END as pattern_info,
        COALESCE(vv.notes, '')::TEXT,
        vv.branch_id,
        vv.vendor_id,
        COALESCE(vv.weekday_name, '')::TEXT,
        COALESCE(vv.fresh_type, '')::TEXT,
        vv.day_number,
        vv.skip_days,
        vv.start_date,
        vv.next_visit_date
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = target_date
    AND vv.status = 'active'
    ORDER BY b.name, v.name;

--

CREATE FUNCTION public.get_todays_scheduled_visits(branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_type text, fresh_type text, notes text, branch_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_type,
        vv.fresh_type,
        vv.notes,
        b.name as branch_name
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = CURRENT_DATE
    AND vv.status = 'active'
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY v.company;

--

CREATE FUNCTION public.get_todays_vendor_visits(branch_uuid uuid) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_time time without time zone, purpose text, status text, priority text, contact_person text, expected_duration_minutes integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_time,
        vv.purpose,
        vv.status,
        vv.priority,
        vv.contact_person,
        vv.expected_duration_minutes
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    WHERE vv.branch_id = branch_uuid 
    AND vv.visit_date = CURRENT_DATE
    AND vv.status IN ('scheduled', 'confirmed', 'in_progress')
    ORDER BY vv.visit_time ASC NULLS LAST, vv.priority DESC;

--

CREATE FUNCTION public.get_todays_visits(branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, next_visit_date date, pattern_config jsonb, notes text, last_visit_date date, visit_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        vv.next_visit_date,
        COALESCE(vv.pattern_config, '{}'::jsonb) as pattern_config,
        COALESCE(vv.notes, '')::TEXT,
        vv.last_visit_date,
        COALESCE(
            (SELECT COUNT(*)::INTEGER 
             FROM visit_history vh 
             WHERE vh.visit_schedule_id = vv.id 
             AND vh.status = 'completed'), 
            0
        ) as visit_count
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = CURRENT_DATE
    AND COALESCE(vv.is_active, true) = true
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY v.name ASC;

--

CREATE FUNCTION public.get_upcoming_visits(branch_uuid uuid DEFAULT NULL::uuid, days_ahead integer DEFAULT 7) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_type text, next_visit_date date, days_until_visit integer, notes text, branch_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_type,
        vv.next_visit_date,
        (vv.next_visit_date - CURRENT_DATE)::INTEGER as days_until_visit,
        vv.notes,
        b.name as branch_name
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date BETWEEN CURRENT_DATE AND CURRENT_DATE + days_ahead
    AND vv.status = 'active'
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY vv.next_visit_date, v.company;

--

CREATE FUNCTION public.get_user_interface_permissions(p_user_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_permissions record;

--

CREATE FUNCTION public.get_user_receiving_tasks_dashboard(user_id_param uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result JSON;

--

CREATE FUNCTION public.get_users_with_employee_details() RETURNS TABLE(id uuid, username character varying, email character varying, role_type character varying, status character varying, employee_id uuid, employee_name character varying, employee_code character varying, employee_status character varying, department_name character varying, position_title character varying, branch_name character varying, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.username,
        ''::VARCHAR as email,
        -- Use admin flags instead of role_type column
        CASE 
            WHEN u.is_master_admin THEN 'Master Admin'::VARCHAR
            WHEN u.is_admin THEN 'Admin'::VARCHAR
            ELSE 'User'::VARCHAR
        END as role_type,
        COALESCE(u.status::VARCHAR, 'active') as status,
        u.employee_id,
        COALESCE(e.name, u.username)::VARCHAR as employee_name,
        COALESCE(e.employee_id, '')::VARCHAR as employee_code,
        COALESCE(e.status, 'active')::VARCHAR as employee_status,
        COALESCE(d.department_name_en, 'No Department')::VARCHAR as department_name,
        COALESCE(p.position_title_en, 'No Position')::VARCHAR as position_title,
        COALESCE(b.name_en, 'No Branch')::VARCHAR as branch_name,
        u.created_at,
        u.updated_at
    FROM users u
    LEFT JOIN hr_employees e ON u.employee_id = e.id
    LEFT JOIN branches b ON u.branch_id = b.id
    LEFT JOIN hr_positions p ON u.position_id = p.id
    LEFT JOIN hr_departments d ON p.department_id = d.id
    WHERE u.status = 'active'
    ORDER BY u.created_at DESC;

--

CREATE FUNCTION public.get_variation_group_info(p_barcode text) RETURNS TABLE(parent_barcode text, group_name_en text, group_name_ar text, total_variations integer, variation_image_override text, created_by uuid, modified_by uuid, modified_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH parent_info AS (
    SELECT 
      COALESCE(p.parent_product_barcode, p.barcode) as parent_ref
    FROM products p
    WHERE p.barcode = p_barcode
  )
  SELECT 
    parent.barcode as parent_barcode,
    parent.variation_group_name_en as group_name_en,
    parent.variation_group_name_ar as group_name_ar,
    COUNT(DISTINCT variations.barcode)::INTEGER as total_variations,
    parent.variation_image_override,
    parent.created_by,
    parent.modified_by,
    parent.modified_at
  FROM products parent
  LEFT JOIN products variations 
    ON variations.parent_product_barcode = parent.barcode 
    OR variations.barcode = parent.barcode
  WHERE parent.barcode = (SELECT parent_ref FROM parent_info)
    AND parent.is_variation = true
  GROUP BY 
    parent.barcode,
    parent.variation_group_name_en,
    parent.variation_group_name_ar,
    parent.variation_image_override,
    parent.created_by,
    parent.modified_by,
    parent.modified_at;

--

CREATE FUNCTION public.get_vendor_count_by_branch() RETURNS TABLE(branch_id bigint, branch_name text, vendor_count bigint, active_vendor_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.id as branch_id,
        b.name_en as branch_name,
        COUNT(v.erp_vendor_id) as vendor_count,
        COUNT(CASE WHEN v.status = 'Active' THEN 1 END) as active_vendor_count
    FROM branches b
    LEFT JOIN vendors v ON b.id = v.branch_id
    GROUP BY b.id, b.name_en
    ORDER BY b.name_en;

--

CREATE FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) RETURNS TABLE(erp_vendor_id integer, vendor_name text, vat_number text, salesman_name text, salesman_contact text, branch_id bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.erp_vendor_id,
        v.vendor_name,
        v.vat_number,
        v.salesman_name,
        v.salesman_contact,
        v.branch_id
    FROM vendors v
    WHERE v.erp_vendor_id = vendor_id_param
    AND (v.branch_id = branch_id_param OR v.branch_id IS NULL)
    LIMIT 1;

--

CREATE FUNCTION public.get_vendor_promissory_notes_summary(vendor_uuid uuid) RETURNS TABLE(total_notes integer, total_active_amount numeric, total_collected_amount numeric, oldest_active_date date, newest_note_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_notes,
        COALESCE(SUM(CASE WHEN status = 'active' THEN amount ELSE 0 END), 0) as total_active_amount,
        COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END), 0) as total_collected_amount,
        MIN(CASE WHEN status = 'active' THEN signed_date END) as oldest_active_date,
        MAX(signed_date) as newest_note_date
    FROM promissory_notes 
    WHERE vendor_id = vendor_uuid;

--

CREATE FUNCTION public.get_vendor_visits_summary(vendor_uuid uuid) RETURNS TABLE(total_visits integer, completed_visits integer, scheduled_visits integer, cancelled_visits integer, last_visit_date date, next_visit_date date, avg_duration_minutes numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_visits,
        COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER as completed_visits,
        COUNT(CASE WHEN status IN ('scheduled', 'confirmed') THEN 1 END)::INTEGER as scheduled_visits,
        COUNT(CASE WHEN status = 'cancelled' THEN 1 END)::INTEGER as cancelled_visits,
        MAX(CASE WHEN status = 'completed' THEN visit_date END) as last_visit_date,
        MIN(CASE WHEN status IN ('scheduled', 'confirmed') AND visit_date >= CURRENT_DATE THEN visit_date END) as next_visit_date,
        AVG(CASE 
            WHEN actual_start_time IS NOT NULL AND actual_end_time IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (actual_end_time - actual_start_time))/60 
            ELSE expected_duration_minutes 
        END)::NUMERIC(10,2) as avg_duration_minutes
    FROM vendor_visits 
    WHERE vendor_id = vendor_uuid;

--

CREATE FUNCTION public.get_vendors_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS TABLE(erp_vendor_id integer, vendor_name text, salesman_name text, vendor_contact_number text, payment_method text, status text, branch_id bigint, categories text[], delivery_modes text[], place text, vat_number text, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF branch_id_param IS NULL THEN
        -- Return all vendors if no branch specified
        RETURN QUERY
        SELECT 
            v.erp_vendor_id,
            v.vendor_name,
            v.salesman_name,
            v.vendor_contact_number,
            v.payment_method,
            v.status,
            v.branch_id,
            v.categories,
            v.delivery_modes,
            v.place,
            v.vat_number,
            v.created_at,
            v.updated_at
        FROM vendors v
        ORDER BY v.vendor_name;

--

CREATE FUNCTION public.get_visit_history(start_date_param date DEFAULT (CURRENT_DATE - '30 days'::interval), end_date_param date DEFAULT CURRENT_DATE, branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, scheduled_date date, actual_date date, status text, outcome_notes text, completed_by text, duration_minutes integer, next_scheduled_date date, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vh.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        vh.scheduled_date,
        vh.actual_date,
        vh.status::TEXT,
        COALESCE(vh.outcome_notes, '')::TEXT,
        COALESCE(vh.completed_by, '')::TEXT,
        vh.duration_minutes,
        vh.next_scheduled_date,
        vh.created_at
    FROM visit_history vh
    JOIN vendor_visits vv ON vh.visit_schedule_id = vv.id
    JOIN vendors v ON vh.vendor_id = v.id
    JOIN branches b ON vh.branch_id = b.id
    WHERE vh.scheduled_date BETWEEN start_date_param AND end_date_param
    AND (branch_uuid IS NULL OR vh.branch_id = branch_uuid)
    ORDER BY vh.scheduled_date DESC, vh.created_at DESC;

--

CREATE FUNCTION public.get_visits_by_date_range(start_date date DEFAULT CURRENT_DATE, end_date date DEFAULT CURRENT_DATE) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, pattern_info text, notes text, branch_id uuid, vendor_id uuid, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date_schedule date, next_visit_date date, is_past boolean, is_today boolean, is_future boolean, days_difference integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        CASE 
            WHEN vv.visit_type = 'weekly' THEN ('Weekly on ' || COALESCE(vv.weekday_name, ''))::TEXT
            WHEN vv.visit_type = 'daily' THEN ('Daily (' || COALESCE(vv.fresh_type, '') || ')')::TEXT
            WHEN vv.visit_type = 'monthly' THEN ('Monthly on day ' || COALESCE(vv.day_number::TEXT, ''))::TEXT
            WHEN vv.visit_type = 'skip_days' THEN ('Every ' || COALESCE(vv.skip_days::TEXT, '') || ' days')::TEXT
            ELSE vv.visit_type::TEXT
        END as pattern_info,
        COALESCE(vv.notes, '')::TEXT,
        vv.branch_id,
        vv.vendor_id,
        COALESCE(vv.weekday_name, '')::TEXT,
        COALESCE(vv.fresh_type, '')::TEXT,
        vv.day_number,
        vv.skip_days,
        vv.start_date as start_date_schedule,
        vv.next_visit_date,
        (vv.next_visit_date < CURRENT_DATE) as is_past,
        (vv.next_visit_date = CURRENT_DATE) as is_today,
        (vv.next_visit_date > CURRENT_DATE) as is_future,
        (vv.next_visit_date - CURRENT_DATE)::INTEGER as days_difference
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date BETWEEN start_date AND end_date
    AND vv.status = 'active'
    ORDER BY vv.next_visit_date DESC, b.name, v.name;

--

CREATE FUNCTION public.get_visits_by_date_range(start_date_param date DEFAULT CURRENT_DATE, end_date_param date DEFAULT (CURRENT_DATE + '7 days'::interval), branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, next_visit_date date, pattern_config jsonb, notes text, is_active boolean, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        vv.next_visit_date,
        COALESCE(vv.pattern_config, '{}'::jsonb) as pattern_config,
        COALESCE(vv.notes, '')::TEXT,
        COALESCE(vv.is_active, true) as is_active,
        vv.created_at
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date BETWEEN start_date_param AND end_date_param
    AND COALESCE(vv.is_active, true) = true
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY vv.next_visit_date ASC;

--

CREATE FUNCTION public.get_wa_priority_conversations(p_account_id uuid) RETURNS TABLE(id uuid, customer_phone character varying, customer_name text, last_message_at timestamp with time zone, last_message_preview text, unread_count integer, is_bot_handling boolean, bot_type character varying, handled_by character varying, needs_human boolean, status character varying, is_inside_24hr boolean, is_sos boolean, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.customer_phone,
        c.customer_name,
        c.last_message_at,
        c.last_message_preview,
        c.unread_count,
        c.is_bot_handling,
        c.bot_type,
        c.handled_by,
        c.needs_human,
        c.status,
        CASE
            WHEN c.last_message_at IS NOT NULL
                 AND c.last_message_at > (NOW() - INTERVAL '24 hours')
            THEN TRUE
            ELSE FALSE
        END AS is_inside_24hr,
        c.is_sos,
        COUNT(*) OVER() AS total_count
    FROM wa_conversations c
    WHERE c.wa_account_id = p_account_id
      AND c.status = 'active'
      AND (c.is_sos = TRUE OR c.needs_human = TRUE)
    ORDER BY
        CASE WHEN c.is_sos = TRUE THEN 0 ELSE 1 END ASC,
        c.last_message_at DESC NULLS LAST;

--

CREATE FUNCTION public.handle_document_deactivation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- If document is being deactivated, clear the main document columns
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        IF NEW.document_type = 'health_card' THEN
            NEW.health_card_number := NULL;

--

CREATE FUNCTION public.handle_order_task_completion() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_task RECORD;

--

CREATE FUNCTION public.has_order_management_access(user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users u
        LEFT JOIN user_roles ur ON u.position_id::text = ur.role_code
        WHERE u.id = user_id
        AND (
            -- Use boolean flags instead of role_type
            u.is_admin = true 
            OR u.is_master_admin = true
            OR ur.role_code IN (
                'CEO',
                'OPERATIONS_MANAGER',
                'BRANCH_MANAGER',
                'CUSTOMER_SERVICE_SUPERVISOR',
                'NIGHT_SUPERVISORS',
                'IT_SYSTEMS_MANAGER'
            )
        )
    );

--

CREATE FUNCTION public.hash_password(password text, salt text) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN crypt(password, salt);

--

CREATE FUNCTION public.increment_ai_token_usage(config_id uuid, p_tokens integer, p_prompt integer, p_completion integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  UPDATE wa_ai_bot_config SET
    tokens_used = COALESCE(tokens_used, 0) + p_tokens,
    prompt_tokens_used = COALESCE(prompt_tokens_used, 0) + p_prompt,
    completion_tokens_used = COALESCE(completion_tokens_used, 0) + p_completion,
    total_requests = COALESCE(total_requests, 0) + 1
  WHERE id = config_id;

--

CREATE FUNCTION public.increment_social_link_click(_branch_id bigint, _platform text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_count BIGINT;

--

CREATE FUNCTION public.insert_order_items(p_order_items jsonb) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_count integer;

--

CREATE FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name character varying, p_vat_number character varying DEFAULT NULL::character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    vendor_id UUID;

--

CREATE FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name_english character varying, p_vendor_name_arabic character varying DEFAULT NULL::character varying, p_vat_number character varying DEFAULT NULL::character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    vendor_id UUID;

--

CREATE FUNCTION public.is_delivery_staff(user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users u
        LEFT JOIN user_roles ur ON u.position_id::text = ur.role_code
        WHERE u.id = user_id
        AND ur.role_code IN ('DELIVERY_STAFF', 'DRIVER')
    );

--

CREATE FUNCTION public.is_overnight_shift(start_time time without time zone, end_time time without time zone) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN start_time > end_time;

--

CREATE FUNCTION public.is_product_in_active_bundle(p_product_id uuid, p_exclude_offer_id integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_found BOOLEAN;

--

CREATE FUNCTION public.is_quick_access_code_available(p_quick_access_code text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
    -- Validate format first
    IF LENGTH(p_quick_access_code) != 6 OR p_quick_access_code !~ '^[0-9]{6}$' THEN
        RETURN false;

--

CREATE FUNCTION public.is_user_admin(check_user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_is_master_admin BOOLEAN;

--

CREATE FUNCTION public.is_user_master_admin(check_user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_is_master_admin BOOLEAN;

--

CREATE FUNCTION public.link_finger_transaction_to_employee(p_employee_code character varying, p_branch_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_employee_id UUID;

--

CREATE FUNCTION public.log_offer_usage(p_offer_id integer, p_customer_id uuid, p_order_id integer, p_discount_applied numeric, p_original_amount numeric, p_final_amount numeric, p_cart_items jsonb DEFAULT NULL::jsonb) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_log_id INTEGER;

--

CREATE FUNCTION public.log_user_action() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO user_audit_logs (
        user_id,
        action,
        table_name,
        record_id,
        old_values,
        new_values,
        created_at
    ) VALUES (
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.id
            ELSE NEW.id
        END,
        TG_OP,
        TG_TABLE_NAME,
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.id
            ELSE NEW.id
        END,
        CASE 
            WHEN TG_OP = 'UPDATE' THEN row_to_json(OLD)
            WHEN TG_OP = 'DELETE' THEN row_to_json(OLD)
            ELSE NULL
        END,
        CASE 
            WHEN TG_OP = 'INSERT' THEN row_to_json(NEW)
            WHEN TG_OP = 'UPDATE' THEN row_to_json(NEW)
            ELSE NULL
        END,
        now()
    );

--

CREATE FUNCTION public.notify_branches_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify(
        'branches_changed',
        json_build_object(
            'operation', TG_OP,
            'id', COALESCE(NEW.id, OLD.id),
            'timestamp', NOW()
        )::text
    );

--

CREATE FUNCTION public.notify_customer_order_status_change() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_order RECORD;

--

CREATE FUNCTION public.notify_erp_daily_sales_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify(
        'erp_daily_sales_changed',
        json_build_object(
            'operation', TG_OP,
            'id', COALESCE(NEW.id, OLD.id),
            'sale_date', COALESCE(NEW.sale_date, OLD.sale_date),
            'timestamp', extract(epoch from now())
        )::text
    );

--

CREATE FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text DEFAULT NULL::text, generated_by_role text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_tasks_created INT := 0;

--

CREATE FUNCTION public.process_customer_recovery(p_request_id uuid, p_admin_user_id uuid, p_action text, p_notes text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_request_record record;

--

CREATE FUNCTION public.process_finger_transaction_linking() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Link with employee if not already set
    IF NEW.employee_id IS NULL THEN
        NEW.employee_id := link_finger_transaction_to_employee(
            NEW.employee_code,
            NEW.branch_id
        );

--

CREATE FUNCTION public.queue_push_notification(p_notification_id uuid, p_target_type text, p_target_users jsonb DEFAULT NULL::jsonb, p_target_roles text[] DEFAULT NULL::text[], p_target_branches uuid[] DEFAULT NULL::uuid[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_record RECORD;

--

CREATE FUNCTION public.queue_quick_task_push_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_record RECORD;

--

CREATE FUNCTION public.reassign_receiving_task(receiving_task_id_param uuid, new_assigned_user_id uuid, reassigned_by_user_id text, reassignment_reason text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;

--

CREATE FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text DEFAULT NULL::text, p_new_branch_id uuid DEFAULT NULL::uuid, p_reassignment_reason text DEFAULT NULL::text, p_copy_deadline boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_assignment_id UUID;

--

CREATE FUNCTION public.record_fine_payment(warning_id_param uuid, payment_amount_param numeric, payment_method_param character varying, payment_reference_param character varying, processed_by_param uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    payment_id UUID;

--

CREATE FUNCTION public.refresh_expiry_cache() RETURNS void
    LANGUAGE sql
    AS $$
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_expiry_products;

--

CREATE FUNCTION public.refresh_user_roles_from_positions() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    roles_updated INTEGER := 0;

--

CREATE FUNCTION public.register_app_function(p_function_name text, p_function_code text, p_description text DEFAULT NULL::text, p_category text DEFAULT 'Application'::text, p_enabled boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_id UUID;

--

CREATE FUNCTION public.register_push_subscription(p_user_id uuid, p_device_id character varying, p_endpoint text, p_p256dh text, p_auth text, p_device_type character varying DEFAULT 'desktop'::character varying, p_browser_name character varying DEFAULT NULL::character varying, p_user_agent text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    subscription_id UUID;

--

CREATE FUNCTION public.register_system_role(p_role_name text, p_role_code text, p_description text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_role_id UUID;

--

CREATE FUNCTION public.request_new_access_code(p_whatsapp_number text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_customer_id uuid;

--

CREATE FUNCTION public.search_tasks(search_term text DEFAULT NULL::text, task_status text DEFAULT NULL::text, assigned_user_id uuid DEFAULT NULL::uuid, created_by_user_id uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, title character varying, description text, status character varying, priority character varying, assigned_to uuid, created_by uuid, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, assignee_name character varying, creator_name character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id,
        t.title,
        t.description,
        t.status,
        t.priority,
        ta.assigned_to,
        t.created_by,
        t.created_at,
        t.updated_at,
        t.due_date,
        COALESCE(u_assignee.username, 'Unassigned')::VARCHAR as assignee_name,
        COALESCE(u_creator.username, 'Unknown')::VARCHAR as creator_name
    FROM tasks t
    LEFT JOIN task_assignments ta ON t.id = ta.task_id
    LEFT JOIN users u_assignee ON ta.assigned_to = u_assignee.id
    LEFT JOIN users u_creator ON t.created_by = u_creator.id
    WHERE (search_term IS NULL OR t.title ILIKE '%' || search_term || '%' OR t.description ILIKE '%' || search_term || '%')
      AND (task_status IS NULL OR t.status = task_status)
      AND (assigned_user_id IS NULL OR ta.assigned_to = assigned_user_id)
      AND (created_by_user_id IS NULL OR t.created_by = created_by_user_id)
      AND t.deleted_at IS NULL
    ORDER BY t.created_at DESC;

--

CREATE FUNCTION public.select_random_product(p_campaign_id uuid) RETURNS TABLE(id uuid, product_name_en character varying, product_name_ar character varying, product_image_url text, original_price numeric, offer_price numeric, special_barcode character varying, stock_remaining integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.product_name_en,
    p.product_name_ar,
    p.product_image_url,
    p.original_price,
    p.offer_price,
    p.special_barcode,
    p.stock_remaining
  FROM coupon_products p
  WHERE p.campaign_id = p_campaign_id
    AND p.is_active = true
    AND p.stock_remaining > 0
    AND p.deleted_at IS NULL
  ORDER BY RANDOM()
  LIMIT 1
  FOR UPDATE SKIP LOCKED;

--

CREATE FUNCTION public.send_order_notification(p_order_id uuid, p_title text, p_message text, p_type text DEFAULT 'info'::text, p_priority text DEFAULT 'medium'::text, p_performed_by uuid DEFAULT NULL::uuid, p_target_user_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_notification_id UUID;

--

CREATE FUNCTION public.setup_role_permissions(p_role_code text, p_permissions jsonb DEFAULT '{"can_add": false, "can_edit": false, "can_view": true, "can_delete": false, "can_export": false}'::jsonb) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_role_id UUID;

--

CREATE FUNCTION public.soft_delete_flyer_template(template_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  is_default_template BOOLEAN;

--

CREATE FUNCTION public.start_break(p_user_id uuid, p_reason_id integer, p_reason_note text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_emp RECORD;

--

CREATE FUNCTION public.submit_quick_task_completion(p_assignment_id uuid, p_user_id uuid, p_completion_notes text DEFAULT NULL::text, p_photos text[] DEFAULT NULL::text[], p_erp_reference text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_quick_task_id uuid;

--

CREATE FUNCTION public.sync_all_missing_erp_references() RETURNS TABLE(synced_count integer, details text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;

--

CREATE FUNCTION public.sync_all_pending_erp_references() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;

--

CREATE FUNCTION public.sync_app_functions_from_components(component_metadata jsonb) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    component JSONB;

--

CREATE FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;

--

CREATE FUNCTION public.sync_requisition_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    scheduler_balance NUMERIC(10,2);

--

CREATE FUNCTION public.sync_user_roles_from_positions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- This function would sync user roles based on position changes
    -- Implementation depends on business logic
    RETURN NEW;

--

CREATE FUNCTION public.track_media_activation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.is_active = true AND (OLD.is_active IS NULL OR OLD.is_active = false) THEN
        NEW.activated_at = NOW();

--

CREATE FUNCTION public.trigger_cleanup_assignment_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up notifications related to the deleted assignment
    DELETE FROM notifications 
    WHERE task_assignment_id = OLD.id;

--

CREATE FUNCTION public.trigger_cleanup_task_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up notifications related to the deleted task
    DELETE FROM notifications 
    WHERE task_id = OLD.id;

--

CREATE FUNCTION public.trigger_notify_new_order() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_customer_name VARCHAR(255);

--

CREATE FUNCTION public.trigger_order_status_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Only log if status actually changed
    IF OLD.order_status IS DISTINCT FROM NEW.order_status THEN
        INSERT INTO order_audit_logs (
            order_id,
            action_type,
            from_status,
            to_status,
            performed_by,
            notes
        ) VALUES (
            NEW.id,
            'status_changed',
            OLD.order_status,
            NEW.order_status,
            NEW.updated_by,
            'Status changed from ' || OLD.order_status || ' to ' || NEW.order_status
        );

--

CREATE FUNCTION public.trigger_sync_erp_reference_on_task_completion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    update_count INTEGER := 0;

--

CREATE FUNCTION public.update_ai_chat_guide_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_app_icons_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_approval_permissions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_approver_visibility_config_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_attendance_hours() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate actual hours
    NEW.actual_hours = calculate_working_hours(NEW.check_in_time, NEW.check_out_time);

--

CREATE FUNCTION public.update_bank_reconciliations_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_bogo_offer_rules_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_box_operations_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_branch_default_positions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_branch_delivery_receivers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_branches_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_coupon_campaigns_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();

--

CREATE FUNCTION public.update_coupon_products_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();

--

CREATE FUNCTION public.update_customer_app_media_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_customer_recovery_requests_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_customers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_day_off_reasons_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_day_off_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_day_off_weekday_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_deadline_datetime() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.deadline_date IS NOT NULL THEN
        NEW.deadline_datetime = (NEW.deadline_date || ' ' || COALESCE(NEW.deadline_time::text, '23:59:59'))::timestamp with time zone;

--

CREATE FUNCTION public.update_delivery_tiers_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_denomination_transactions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_denomination_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_departments_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_desktop_themes_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_duty_schedule_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_early_leave_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_employee_positions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_erp_connections_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_erp_daily_sales_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_expense_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_expense_parent_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_expense_scheduler_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();

--

CREATE FUNCTION public.update_final_bill_amount_on_adjustment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only recalculate if there are actual adjustments (discount, GRR, or PRI)
  -- This prevents the trigger from interfering with split payments
  IF (COALESCE(NEW.discount_amount, 0) > 0 OR 
      COALESCE(NEW.grr_amount, 0) > 0 OR 
      COALESCE(NEW.pri_amount, 0) > 0) THEN
    
    DECLARE
      base_amount DECIMAL(15, 2);

--

CREATE FUNCTION public.update_flyer_templates_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();

--

CREATE FUNCTION public.update_hr_checklist_operations_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_hr_checklist_questions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_hr_checklists_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_hr_employee_master_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_interface_permissions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_issue_types_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_lease_rent_lease_parties_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_lease_rent_property_spaces_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_lease_rent_rent_parties_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_levels_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_main_document_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the dedicated columns based on document type
    IF NEW.document_type = 'health_card' THEN
        NEW.health_card_number := NEW.document_number;

--

CREATE FUNCTION public.update_multi_shift_date_wise_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_multi_shift_regular_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_multi_shift_weekday_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_near_expiry_reports_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_next_visit_date(visit_id uuid) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
    visit_record vendor_visits%ROWTYPE;

--

CREATE FUNCTION public.update_non_approved_scheduler_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();

--

CREATE FUNCTION public.update_notification_queue_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_offer_cart_tiers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_offers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_official_holidays_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text DEFAULT NULL::text) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_status VARCHAR(50);

--

CREATE FUNCTION public.update_payment_transactions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_pos_deduction_transfers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_positions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_product_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_product_request_bt_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_product_request_po_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_product_request_st_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_product_units_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_products_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_purchase_voucher_items_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_purchase_vouchers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_push_subscriptions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_quick_task_completions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_receiving_records_pr_excel_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.pr_excel_file_url IS DISTINCT FROM NEW.pr_excel_file_url THEN
        NEW.updated_at = now();

--

CREATE FUNCTION public.update_receiving_records_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_receiving_task_completion(receiving_task_id_param uuid, erp_reference_param character varying DEFAULT NULL::character varying, original_bill_uploaded_param boolean DEFAULT NULL::boolean, original_bill_file_path_param text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;

--

CREATE FUNCTION public.update_receiving_task_templates_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_receiving_tasks_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_receiving_user_defaults_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_regular_shift_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_social_links_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_special_shift_date_wise_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_special_shift_weekday_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_stock_request_status(p_request_id uuid, p_new_status character varying) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_requester_user_id UUID;

--

CREATE FUNCTION public.update_system_api_keys_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_tax_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();

--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());

--

CREATE FUNCTION public.update_user_device_sessions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_user_theme_assignments_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_vendor_payment_with_exact_calculation(payment_id uuid, new_discount_amount numeric DEFAULT NULL::numeric, new_grr_amount numeric DEFAULT NULL::numeric, new_pri_amount numeric DEFAULT NULL::numeric, discount_notes_val text DEFAULT NULL::text, grr_reference_val text DEFAULT NULL::text, grr_notes_val text DEFAULT NULL::text, pri_reference_val text DEFAULT NULL::text, pri_notes_val text DEFAULT NULL::text, history_val jsonb DEFAULT NULL::jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  current_bill_amount NUMERIC;

--

CREATE FUNCTION public.update_warning_main_category_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_warning_sub_category_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.update_warning_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();

--

CREATE FUNCTION public.update_warning_violation_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;

--

CREATE FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text DEFAULT NULL::text) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id BIGINT;

--

CREATE FUNCTION public.upsert_erp_products_with_expiry(p_products jsonb) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_inserted int := 0;

--

CREATE FUNCTION public.upsert_social_links(_branch_id bigint, _facebook text DEFAULT NULL::text, _whatsapp text DEFAULT NULL::text, _instagram text DEFAULT NULL::text, _tiktok text DEFAULT NULL::text, _snapchat text DEFAULT NULL::text, _website text DEFAULT NULL::text, _location_link text DEFAULT NULL::text) RETURNS TABLE(id uuid, branch_id bigint, facebook text, whatsapp text, instagram text, tiktok text, snapchat text, website text, location_link text, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE sql
    AS $$
  INSERT INTO public.social_links (branch_id, facebook, whatsapp, instagram, tiktok, snapchat, website, location_link)
  VALUES (_branch_id, _facebook, _whatsapp, _instagram, _tiktok, _snapchat, _website, _location_link)
  ON CONFLICT (branch_id) DO UPDATE SET
    facebook = _facebook,
    whatsapp = _whatsapp,
    instagram = _instagram,
    tiktok = _tiktok,
    snapchat = _snapchat,
    website = _website,
    location_link = _location_link,
    updated_at = NOW()
  RETURNING id, branch_id, facebook, whatsapp, instagram, tiktok, snapchat, website, location_link, created_at, updated_at
$$;

--

CREATE FUNCTION public.validate_bundle_offer_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_offer_type VARCHAR;

--

CREATE FUNCTION public.validate_coupon_eligibility(p_campaign_code character varying, p_mobile_number character varying) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_campaign_id UUID;

--

CREATE FUNCTION public.validate_flyer_template_configuration(config jsonb) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  field JSONB;

--

CREATE FUNCTION public.validate_payment_methods(payment_methods text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    valid_methods TEXT[] := ARRAY['Cash on Delivery', 'Bank on Delivery', 'Cash Credit', 'Bank Credit'];

--

CREATE FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  v_offer_qty INTEGER;

--

CREATE FUNCTION public.validate_task_completion_requirements(receiving_task_id_param uuid, user_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;

--

CREATE FUNCTION public.validate_variation_prices(p_offer_id integer, p_group_id uuid) RETURNS TABLE(barcode text, product_name_en text, offer_price numeric, offer_percentage numeric, price_mismatch boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH group_prices AS (
    SELECT 
      op.offer_price,
      op.offer_percentage,
      COUNT(DISTINCT op.offer_price) OVER () as price_count,
      COUNT(DISTINCT op.offer_percentage) OVER () as percentage_count
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.variation_group_id = p_group_id
    LIMIT 1
  )
  SELECT 
    p.barcode,
    p.product_name_en,
    op.offer_price,
    op.offer_percentage,
    CASE 
      WHEN gp.price_count > 1 OR gp.percentage_count > 1 THEN true
      ELSE false
    END as price_mismatch
  FROM offer_products op
  JOIN products p ON op.product_id = p.id
  CROSS JOIN group_prices gp
  WHERE op.offer_id = p_offer_id
    AND op.variation_group_id = p_group_id
  ORDER BY p.variation_order, p.product_name_en;

--

CREATE FUNCTION public.validate_vendor_branch_match() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if vendor belongs to the selected branch or is unassigned
    IF NOT EXISTS (
        SELECT 1 FROM vendors 
        WHERE erp_vendor_id = NEW.vendor_id 
        AND (branch_id = NEW.branch_id OR branch_id IS NULL)
    ) THEN
        RAISE EXCEPTION 'Vendor % does not belong to branch % or is not assigned to any branch', 
            NEW.vendor_id, NEW.branch_id;

--

CREATE FUNCTION public.verify_password(password text, hash text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN hash = crypt(password, hash);

--

CREATE FUNCTION public.verify_password(input_username character varying, input_password character varying) RETURNS TABLE(user_id uuid, username character varying, email character varying, role_type character varying, is_valid boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id as user_id,
        u.username,
        u.email,
        -- Return derived role_type for backward compatibility
        CASE 
            WHEN u.is_master_admin = true THEN 'Master Admin'::character varying
            WHEN u.is_admin = true THEN 'Admin'::character varying
            ELSE 'User'::character varying
        END as role_type,
        (u.password_hash = crypt(input_password, u.password_hash)) as is_valid
    FROM users u
    WHERE u.username = input_username
      AND u.deleted_at IS NULL
    LIMIT 1;

--

CREATE FUNCTION public.verify_quick_task_completion(completion_id_param uuid, verified_by_user_id_param uuid, verification_notes_param text DEFAULT NULL::text, is_approved boolean DEFAULT true) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_status VARCHAR(50);