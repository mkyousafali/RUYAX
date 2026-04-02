SET lock_timeout = 0;

SET idle_in_transaction_session_timeout = 0;

SET client_encoding = 'UTF8';

SET standard_conforming_strings = on;

SET check_function_bodies = false;

SET xmloption = content;

SET client_min_messages = warning;

SET row_security = off;

--

CREATE FUNCTION public.acknowledge_warning(warning_id_param uuid, acknowledged_by_param uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE employee_warnings 
    SET 
        warning_status = 'acknowledged',
        acknowledged_at = CURRENT_TIMESTAMP,
        acknowledged_by = acknowledged_by_param,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = warning_id_param
    AND warning_status = 'active';

--

CREATE FUNCTION public.authenticate_customer_access_code(p_access_code text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer record;

--

CREATE FUNCTION public.bulk_toggle_customer_product(p_barcodes text[], p_value boolean) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_count INTEGER;

BEGIN
    UPDATE products
    SET is_customer_product = p_value
    WHERE barcode = ANY(p_barcodes);

--

CREATE FUNCTION public.check_overdue_tasks_and_send_reminders() RETURNS TABLE(task_id uuid, task_title text, user_id uuid, user_name text, hours_overdue numeric, reminder_sent boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  task_record RECORD;

--

CREATE FUNCTION public.cleanup_expired_otps() RETURNS void
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  DELETE FROM access_code_otp WHERE expires_at < NOW();

--

CREATE FUNCTION public.cleanup_expired_sessions() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up expired device sessions
    UPDATE user_device_sessions
    SET is_active = false
    WHERE expires_at < NOW()
    AND is_active = true;

--

CREATE FUNCTION public.clear_sync_tables(p_tables text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_table text;

--

CREATE FUNCTION public.copy_completion_requirements_to_assignment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the assignment with completion requirements from the task
    UPDATE quick_task_assignments 
    SET 
        require_task_finished = (
            SELECT require_task_finished 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        ),
        require_photo_upload = (
            SELECT require_photo_upload 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        ),
        require_erp_reference = (
            SELECT require_erp_reference 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        )
    WHERE id = NEW.id;

--

CREATE FUNCTION public.count_bills_without_erp_reference() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    no_erp_count INTEGER;

--

CREATE FUNCTION public.count_bills_without_original() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    no_original_count INTEGER;

--

CREATE FUNCTION public.count_completed_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    completed_count INTEGER;

--

CREATE FUNCTION public.count_incomplete_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    incomplete_count INTEGER;

--

CREATE FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text DEFAULT NULL::text) RETURNS TABLE(order_id uuid, order_number character varying, success boolean, message text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_order_id UUID;

--

CREATE FUNCTION public.create_customer_registration(p_name text, p_whatsapp_number text, p_branch_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer_id uuid;

UPDATE public.customers
            SET name = p_name,
                access_code = v_hashed_code,
                access_code_generated_at = now(),
                registration_status = 'approved',
                updated_at = now()
            WHERE id = v_existing_customer.id
            RETURNING id INTO v_customer_id;

--

CREATE FUNCTION public.create_user(p_username character varying, p_password character varying, p_is_master_admin boolean DEFAULT false, p_is_admin boolean DEFAULT false, p_user_type character varying DEFAULT 'branch_specific'::character varying, p_branch_id bigint DEFAULT NULL::bigint, p_employee_id uuid DEFAULT NULL::uuid, p_position_id uuid DEFAULT NULL::uuid, p_quick_access_code character varying DEFAULT NULL::character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;

--

CREATE FUNCTION public.deactivate_expired_media() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE customer_app_media
    SET 
        is_active = false,
        deactivated_at = NOW(),
        updated_at = NOW()
    WHERE 
        is_active = true
        AND is_infinite = false
        AND expiry_date <= NOW();

--

CREATE FUNCTION public.decrement_voucher_stock(voucher_value numeric, decrement_amount integer DEFAULT 1) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE purchase_voucher_stock
    SET quantity = quantity - decrement_amount,
        updated_at = NOW()
    WHERE value = voucher_value
      AND quantity >= decrement_amount;

--

CREATE FUNCTION public.delete_app_icon(p_icon_key text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    DELETE FROM public.app_icons WHERE icon_key = p_icon_key;

--

CREATE FUNCTION public.delete_branch_sync_config(p_id bigint) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    DELETE FROM branch_sync_config WHERE id = p_id;

--

CREATE FUNCTION public.delete_incident_cascade(p_incident_id text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_task_ids uuid[];

UPDATE break_register
  SET end_time = NOW(),
      duration_seconds = v_duration,
      status = 'closed'
  WHERE id = v_break.id;

--

CREATE FUNCTION public.end_break(p_user_id uuid, p_security_code text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_break_id uuid;

--

CREATE FUNCTION public.ensure_single_default_flyer_template() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.is_default = true THEN
    -- Unset all other default templates
    UPDATE flyer_templates 
    SET is_default = false 
    WHERE id != NEW.id 
      AND is_default = true 
      AND deleted_at IS NULL;

--

CREATE FUNCTION public.export_schema_ddl() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE
    v_functions text := '';

--

CREATE FUNCTION public.export_table_for_sync(p_table_name text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_result jsonb;

--

CREATE FUNCTION public.generate_new_customer_access_code(p_customer_id uuid, p_admin_user_id uuid, p_notes text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_new_access_code text;

UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = v_current_time,
        updated_at = v_current_time
    WHERE id = p_customer_id;

--

CREATE FUNCTION public.generate_unique_quick_access_code() RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_code VARCHAR(6);

--

CREATE FUNCTION public.get_all_expiry_products(p_page integer DEFAULT 1, p_page_size integer DEFAULT 1000, p_search_barcode text DEFAULT NULL::text, p_search_name text DEFAULT NULL::text, p_branch_id integer DEFAULT NULL::integer) RETURNS TABLE(branch_id integer, barcode character varying, product_name_en character varying, product_name_ar character varying, expiry_date date, days_left integer, managed_by jsonb, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  v_offset integer;

BEGIN
  v_offset := CASE WHEN (p_search_barcode IS NOT NULL OR p_search_name IS NOT NULL) THEN 0 ELSE (p_page - 1) * p_page_size END;

RETURN QUERY
  SELECT
    (entry->>'branch_id')::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    (entry->>'expiry_date')::date AS expiry_date,
    ((entry->>'expiry_date')::date - CURRENT_DATE)::integer AS days_left,
    p.managed_by,
    count(*) OVER() AS total_count
  FROM erp_synced_products p,
    jsonb_array_elements(p.expiry_dates) AS entry
  WHERE p.expiry_hidden IS NOT TRUE
    AND jsonb_array_length(p.expiry_dates) > 0
    AND (entry->>'expiry_date') IS NOT NULL
    AND (entry->>'branch_id') IS NOT NULL
    AND (p_branch_id IS NULL OR (entry->>'branch_id')::integer = p_branch_id)
    AND (p_search_barcode IS NULL OR p.barcode ILIKE '%' || p_search_barcode || '%')
    AND (p_search_name IS NULL OR p.product_name_en ILIKE '%' || p_search_name || '%' OR p.product_name_ar ILIKE '%' || p_search_name || '%')
  ORDER BY ((entry->>'expiry_date')::date - CURRENT_DATE) ASC, p.barcode
  LIMIT v_limit
  OFFSET v_offset;

--

CREATE FUNCTION public.get_app_icons() RETURNS TABLE(id uuid, name text, icon_key text, category text, storage_path text, mime_type text, file_size bigint, description text, is_active boolean, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT id, name, icon_key, category, storage_path, mime_type, file_size, description, is_active, created_at, updated_at
    FROM public.app_icons
    ORDER BY category, name;

--

CREATE FUNCTION public.get_branch_sync_configs() RETURNS TABLE(id bigint, branch_id bigint, branch_name_en text, branch_name_ar text, local_supabase_url text, local_supabase_key text, tunnel_url text, ssh_user text, is_active boolean, last_sync_at timestamp with time zone, last_sync_status text, last_sync_details jsonb, sync_tables text[])
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    c.id, c.branch_id,
    b.name_en as branch_name_en,
    b.name_ar as branch_name_ar,
    c.local_supabase_url, c.local_supabase_key,
    c.tunnel_url, COALESCE(c.ssh_user, 'u') as ssh_user,
    c.is_active,
    c.last_sync_at, c.last_sync_status, c.last_sync_details,
    c.sync_tables
  FROM branch_sync_config c
  JOIN branches b ON b.id = c.branch_id
  WHERE c.is_active = true
  ORDER BY b.name_en;

--

CREATE FUNCTION public.get_break_security_code() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_seed text;

--

CREATE FUNCTION public.get_broadcast_recipients(p_broadcast_id uuid, p_limit integer DEFAULT 100, p_offset integer DEFAULT 0, p_status_filter text DEFAULT NULL::text) RETURNS TABLE(id uuid, phone_number character varying, customer_name text, status character varying, sent_at timestamp with time zone, error_details text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT r.id, r.phone_number, r.customer_name, r.status, r.sent_at, r.error_details
    FROM wa_broadcast_recipients r
    WHERE r.broadcast_id = p_broadcast_id
      AND (p_status_filter IS NULL OR r.status = p_status_filter)
    ORDER BY r.sent_at DESC NULLS LAST
    LIMIT p_limit
    OFFSET p_offset;

--

CREATE FUNCTION public.get_broadcast_summary(p_broadcast_id uuid) RETURNS TABLE(total_count bigint, pending_count bigint, sent_count bigint, delivered_count bigint, read_count bigint, failed_count bigint)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        COUNT(*)::bigint AS total_count,
        COUNT(*) FILTER (WHERE status = 'pending')::bigint AS pending_count,
        COUNT(*) FILTER (WHERE status = 'sent')::bigint AS sent_count,
        COUNT(*) FILTER (WHERE status = 'delivered')::bigint AS delivered_count,
        COUNT(*) FILTER (WHERE status = 'read')::bigint AS read_count,
        COUNT(*) FILTER (WHERE status = 'failed')::bigint AS failed_count
    FROM wa_broadcast_recipients
    WHERE broadcast_id = p_broadcast_id;

--

CREATE FUNCTION public.get_bucket_files(p_bucket_id text) RETURNS TABLE(file_name text, full_path text, file_size bigint, created_at timestamp with time zone, mime_type text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    o.name::text AS file_name,
    o.name::text AS full_path,
    COALESCE((o.metadata->>'size')::bigint, 0) AS file_size,
    o.created_at,
    COALESCE(o.metadata->>'mimetype', o.metadata->>'mimeType', '') AS mime_type
  FROM storage.objects o
  WHERE o.bucket_id = p_bucket_id
  ORDER BY o.name;

--

CREATE FUNCTION public.get_close_purchase_voucher_data() RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'vouchers', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pvi.id,
          'purchase_voucher_id', pvi.purchase_voucher_id,
          'serial_number', pvi.serial_number,
          'value', pvi.value,
          'status', pvi.status,
          'issue_type', pvi.issue_type,
          'stock_location', pvi.stock_location,
          'stock_location_name', COALESCE(b.name_en || ' - ' || b.location_en, '-'),
          'issued_by', pvi.issued_by,
          'issued_by_name', COALESCE(eby.name_en, uby.username, '-'),
          'issued_to', pvi.issued_to,
          'issued_to_name', COALESCE(eto.name_en, uto.username, '-'),
          'issued_date', pvi.issued_date,
          'issue_remarks', pvi.issue_remarks,
          'approval_status', pvi.approval_status
        )
        ORDER BY pvi.issued_date DESC
      )
      FROM purchase_voucher_items pvi
      LEFT JOIN branches b ON b.id = pvi.stock_location
      LEFT JOIN users uby ON uby.id = pvi.issued_by
      LEFT JOIN hr_employee_master eby ON eby.id = uby.employee_id::text
      LEFT JOIN users uto ON uto.id = pvi.issued_to
      LEFT JOIN hr_employee_master eto ON eto.id = uto.employee_id::text
      WHERE pvi.status = 'issued' OR pvi.approval_status = 'pending'
    ), '[]'::jsonb),
    'branches', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', id, 'name_en', name_en, 'location_en', location_en))
      FROM branches
    ), '[]'::jsonb),
    'expense_categories', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', id, 'name_en', name_en, 'name_ar', name_ar, 'parent_category_id', parent_category_id))
      FROM expense_sub_categories WHERE is_active = true
    ), '[]'::jsonb)
  );

--

CREATE FUNCTION public.get_closed_boxes(p_branch_id text DEFAULT 'all'::text, p_date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, p_date_to timestamp with time zone DEFAULT NULL::timestamp with time zone, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_total_count bigint;

--

CREATE FUNCTION public.get_contact_broadcast_stats(phone_number text) RETURNS TABLE(sent integer, delivered integer, read integer, failed integer, total integer)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
  SELECT
    COALESCE(COUNT(*) FILTER (WHERE status = 'sent'), 0) as sent,
    COALESCE(COUNT(*) FILTER (WHERE status = 'delivered'), 0) as delivered,
    COALESCE(COUNT(*) FILTER (WHERE status = 'read'), 0) as read,
    COALESCE(COUNT(*) FILTER (WHERE status = 'failed'), 0) as failed,
    COUNT(*) as total
  FROM wa_broadcast_recipients
  WHERE phone_number = $1;

--

CREATE FUNCTION public.get_customers_list() RETURNS TABLE(id uuid, name text, access_code text, whatsapp_number text, registration_status text, registration_notes text, approved_by uuid, approved_at timestamp with time zone, access_code_generated_at timestamp with time zone, last_login_at timestamp with time zone, created_at timestamp with time zone, updated_at timestamp with time zone, location1_name text, location1_url text, location1_lat double precision, location1_lng double precision, location2_name text, location2_url text, location2_lat double precision, location2_lng double precision, location3_name text, location3_url text, location3_lat double precision, location3_lng double precision, is_deleted boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id,
    c.name,
    c.access_code,
    c.whatsapp_number::text,
    c.registration_status,
    c.registration_notes,
    c.approved_by,
    c.approved_at,
    c.access_code_generated_at,
    c.last_login_at,
    c.created_at,
    c.updated_at,
    c.location1_name,
    c.location1_url,
    c.location1_lat,
    c.location1_lng,
    c.location2_name,
    c.location2_url,
    c.location2_lat,
    c.location2_lng,
    c.location3_name,
    c.location3_url,
    c.location3_lat,
    c.location3_lng,
    c.is_deleted
  FROM customers c
  ORDER BY
    CASE
      WHEN c.registration_status = 'pending' THEN 1
      WHEN c.registration_status = 'approved' THEN 2
      WHEN c.registration_status = 'rejected' THEN 3
      WHEN c.registration_status = 'suspended' THEN 4
      ELSE 5
    END,
    c.created_at DESC;

--

CREATE FUNCTION public.get_customers_list_paginated(p_search text DEFAULT ''::text, p_status text DEFAULT 'all'::text, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result json;

--

CREATE FUNCTION public.get_database_functions() RETURNS TABLE(func_name text, func_args text, return_type text, func_language text, func_type text, is_security_definer boolean, func_definition text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE
  rec RECORD;

--

CREATE FUNCTION public.get_edge_functions() RETURNS TABLE(func_name text, func_size text, file_count integer, last_modified timestamp with time zone, has_index boolean, func_code text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT func_name, func_size, file_count, last_modified, has_index, func_code
  FROM public.edge_functions_cache
  ORDER BY func_name;

--

CREATE FUNCTION public.get_employee_products(p_employee_id text, p_limit integer DEFAULT 1000, p_offset integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result JSON;

BEGIN
  SELECT json_build_object(
    'products', COALESCE((
      SELECT json_agg(row_to_json(t))
      FROM (
        SELECT 
          barcode, 
          product_name_en, 
          product_name_ar, 
          parent_barcode,
          expiry_dates,
          managed_by
        FROM erp_synced_products
        WHERE managed_by @> ('[{"employee_id":"' || p_employee_id || '"}]')::jsonb
        ORDER BY product_name_en
        LIMIT p_limit
        OFFSET p_offset
      ) t
    ), '[]'::json),
    'total_count', (
      SELECT count(*)
      FROM erp_synced_products
      WHERE managed_by @> ('[{"employee_id":"' || p_employee_id || '"}]')::jsonb
    )
  ) INTO v_result;

--

CREATE FUNCTION public.get_issue_pv_vouchers(p_pv_id text DEFAULT NULL::text, p_serial_number bigint DEFAULT NULL::bigint) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;

--

CREATE FUNCTION public.get_latest_frontend_build() RETURNS TABLE(id integer, version text, file_name text, file_size bigint, storage_path text, notes text, created_at timestamp with time zone, download_url text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        fb.id,
        fb.version,
        fb.file_name,
        fb.file_size,
        fb.storage_path,
        fb.notes,
        fb.created_at,
        '/storage/v1/object/public/frontend-builds/' || fb.storage_path as download_url
    FROM public.frontend_builds fb
    ORDER BY fb.created_at DESC
    LIMIT 1;

--

CREATE FUNCTION public.get_ongoing_quick_assignment_count(p_user_id uuid) RETURNS bigint
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT count(*)
  FROM quick_task_assignments qta
  INNER JOIN quick_tasks qt ON qt.id = qta.quick_task_id
  WHERE qt.assigned_by = p_user_id
    AND qta.status NOT IN ('completed', 'cancelled');

--

CREATE FUNCTION public.get_overdue_tasks_without_reminders() RETURNS TABLE(assignment_id uuid, task_id uuid, task_title text, assigned_to_user_id uuid, user_name character varying, deadline timestamp with time zone, hours_overdue numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ta.id as assignment_id,
    t.id as task_id,
    t.title as task_title,
    ta.assigned_to_user_id,
    u.username as user_name,
    COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) as deadline,
    EXTRACT(EPOCH FROM (NOW() - COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime))) / 3600 as hours_overdue
  FROM task_assignments ta
  JOIN tasks t ON t.id = ta.task_id
  JOIN users u ON u.id = ta.assigned_to_user_id
  LEFT JOIN task_completions tc ON tc.assignment_id = ta.id
  WHERE tc.id IS NULL  -- Not completed
    AND COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) IS NOT NULL  -- Has deadline
    AND COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) < NOW()  -- Overdue
    AND NOT EXISTS (  -- No reminder sent yet
      SELECT 1 FROM task_reminder_logs trl 
      WHERE trl.task_assignment_id = ta.id
    )
  ORDER BY hours_overdue DESC;

--

CREATE FUNCTION public.get_paid_expense_payments(p_date_from date, p_date_to date) RETURNS TABLE(id bigint, amount numeric, is_paid boolean, paid_date timestamp with time zone, status text, branch_id bigint, payment_method text, expense_category_name_en text, expense_category_name_ar text, description text, schedule_type text, due_date date, co_user_name text, created_by uuid, requisition_id bigint, requisition_number text, payment_reference character varying, creator_username text)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    e.id, e.amount, e.is_paid, e.paid_date, e.status,
    e.branch_id, e.payment_method,
    e.expense_category_name_en, e.expense_category_name_ar,
    e.description, e.schedule_type, e.due_date,
    e.co_user_name, e.created_by,
    e.requisition_id, e.requisition_number,
    e.payment_reference,
    u.username AS creator_username
  FROM expense_scheduler e
  LEFT JOIN public.users u ON u.id = e.created_by
  WHERE e.is_paid = true
    AND e.due_date >= p_date_from
    AND e.due_date <= p_date_to
  ORDER BY e.due_date DESC;

--

CREATE FUNCTION public.get_paid_vendor_payments(p_date_from date, p_date_to date) RETURNS TABLE(id uuid, bill_number character varying, vendor_name character varying, final_bill_amount numeric, bill_date date, branch_id integer, payment_method character varying, bank_name character varying, iban character varying, is_paid boolean, paid_date timestamp without time zone, due_date date, payment_reference character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    v.id, v.bill_number, v.vendor_name, v.final_bill_amount,
    v.bill_date, v.branch_id, v.payment_method, v.bank_name, v.iban,
    v.is_paid, v.paid_date, v.due_date, v.payment_reference
  FROM vendor_payment_schedule v
  WHERE v.is_paid = true
    AND v.due_date >= p_date_from
    AND v.due_date <= p_date_to
  ORDER BY v.due_date DESC;

--

CREATE FUNCTION public.get_pos_report(p_date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, p_date_to timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_result jsonb;

--

CREATE FUNCTION public.get_products_dashboard_data(p_limit integer DEFAULT 500, p_offset integer DEFAULT 0) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;

BEGIN
  SELECT jsonb_build_object(
    'products', COALESCE((
      SELECT jsonb_agg(row_data ORDER BY rn)
      FROM (
        SELECT 
          jsonb_build_object(
            'id', p.id,
            'barcode', p.barcode,
            'product_name_en', COALESCE(p.product_name_en, ''),
            'product_name_ar', COALESCE(p.product_name_ar, ''),
            'category_id', p.category_id,
            'category_name_en', pc.name_en,
            'category_name_ar', pc.name_ar,
            'unit_id', p.unit_id,
            'unit_name_en', pu.name_en,
            'unit_name_ar', pu.name_ar
          ) AS row_data,
          ROW_NUMBER() OVER (ORDER BY p.product_name_en) AS rn
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
        LEFT JOIN product_units pu ON p.unit_id = pu.id
        ORDER BY p.product_name_en
        LIMIT p_limit
        OFFSET p_offset
      ) sub
    ), '[]'::jsonb),
    'categories', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pc.id,
          'name_en', pc.name_en,
          'name_ar', pc.name_ar
        ) ORDER BY pc.name_en
      )
      FROM product_categories pc
    ), '[]'::jsonb),
    'units', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pu.id,
          'name_en', pu.name_en,
          'name_ar', pu.name_ar
        ) ORDER BY pu.name_en
      )
      FROM product_units pu
    ), '[]'::jsonb),
    'total_count', (SELECT COUNT(*)::int FROM products)
  )
  INTO result;

--

CREATE FUNCTION public.get_purchase_voucher_manager_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;

--

CREATE FUNCTION public.get_pv_stock_manager_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;

--

CREATE FUNCTION public.get_pv_stock_voucher_items() RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'items', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pvi.id,
          'purchase_voucher_id', pvi.purchase_voucher_id,
          'serial_number', pvi.serial_number,
          'value', pvi.value,
          'stock', pvi.stock,
          'status', pvi.status,
          'issue_type', pvi.issue_type,
          'stock_location', pvi.stock_location,
          'stock_person', pvi.stock_person,
          'stock_location_name', COALESCE(b.name_en, '-'),
          'stock_person_name', COALESCE(e.name_en, u.username, '-')
        )
        ORDER BY pvi.purchase_voucher_id, pvi.serial_number
      )
      FROM purchase_voucher_items pvi
      LEFT JOIN branches b ON b.id = pvi.stock_location
      LEFT JOIN users u ON u.id = pvi.stock_person
      LEFT JOIN hr_employee_master e ON e.id = u.employee_id::text
    ), '[]'::jsonb)
  );

--

CREATE FUNCTION public.get_pv_stock_voucher_items(p_offset integer DEFAULT 0, p_limit integer DEFAULT 2000) RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'total_count', (SELECT count(*) FROM purchase_voucher_items),
    'items', COALESCE((
      SELECT jsonb_agg(row_data)
      FROM (
        SELECT jsonb_build_object(
          'id', pvi.id,
          'purchase_voucher_id', pvi.purchase_voucher_id,
          'serial_number', pvi.serial_number,
          'value', pvi.value,
          'stock', pvi.stock,
          'status', pvi.status,
          'issue_type', pvi.issue_type,
          'stock_location', pvi.stock_location,
          'stock_person', pvi.stock_person,
          'stock_location_name', COALESCE(b.name_en, '-'),
          'stock_person_name', COALESCE(e.name_en, u.username, '-')
        ) as row_data
        FROM purchase_voucher_items pvi
        LEFT JOIN branches b ON b.id = pvi.stock_location
        LEFT JOIN users u ON u.id = pvi.stock_person
        LEFT JOIN hr_employee_master e ON e.id = u.employee_id::text
        ORDER BY pvi.purchase_voucher_id, pvi.serial_number
        LIMIT p_limit OFFSET p_offset
      ) sub
    ), '[]'::jsonb)
  );

--

CREATE FUNCTION public.get_receiving_records_with_details(p_limit integer DEFAULT 500, p_offset integer DEFAULT 0, p_branch_id text DEFAULT NULL::text, p_vendor_search text DEFAULT NULL::text, p_pr_excel_filter text DEFAULT NULL::text, p_erp_ref_filter text DEFAULT NULL::text) RETURNS TABLE(id text, bill_number text, vendor_id text, branch_id text, bill_date date, bill_amount numeric, created_at timestamp with time zone, user_id text, original_bill_url text, erp_purchase_invoice_reference text, certificate_url text, due_date date, pr_excel_file_url text, final_bill_amount numeric, payment_method text, credit_period integer, bank_name text, iban text, branch_name_en text, branch_location_en text, vendor_name text, vat_number text, username text, user_display_name text, is_scheduled boolean, is_paid boolean, pr_excel_verified boolean, pr_excel_verified_by text, pr_excel_verified_date timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_total BIGINT;

RETURN QUERY
    SELECT
        r.id::TEXT,
        r.bill_number::TEXT,
        r.vendor_id::TEXT,
        r.branch_id::TEXT,
        r.bill_date,
        r.bill_amount,
        r.created_at,
        r.user_id::TEXT,
        r.original_bill_url::TEXT,
        r.erp_purchase_invoice_reference::TEXT,
        r.certificate_url::TEXT,
        r.due_date,
        r.pr_excel_file_url::TEXT,
        r.final_bill_amount,
        r.payment_method::TEXT,
        r.credit_period,
        r.bank_name::TEXT,
        r.iban::TEXT,
        -- Branch
        COALESCE(b.name_en, 'N/A')::TEXT AS branch_name_en,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        -- Vendor (match by erp_vendor_id AND branch_id)
        COALESCE(v.vendor_name, 'N/A')::TEXT AS vendor_name,
        v.vat_number::TEXT,
        -- User
        COALESCE(u.username, '')::TEXT AS username,
        COALESCE(he.name, u.username, '')::TEXT AS user_display_name,
        -- Payment schedule
        (ps.receiving_record_id IS NOT NULL) AS is_scheduled,
        COALESCE(ps.is_paid, false) AS is_paid,
        COALESCE(ps.pr_excel_verified, false) AS pr_excel_verified,
        ps.pr_excel_verified_by::TEXT,
        ps.pr_excel_verified_date,
        -- Total count
        v_total AS total_count
    FROM receiving_records r
    LEFT JOIN branches b ON b.id = r.branch_id
    LEFT JOIN vendors v ON v.erp_vendor_id = r.vendor_id AND v.branch_id = r.branch_id
    LEFT JOIN users u ON u.id = r.user_id
    LEFT JOIN hr_employees he ON he.id = u.id
    LEFT JOIN LATERAL (
        SELECT 
            vps.receiving_record_id,
            vps.is_paid,
            vps.pr_excel_verified,
            vps.pr_excel_verified_by,
            vps.pr_excel_verified_date
        FROM vendor_payment_schedule vps
        WHERE vps.receiving_record_id = r.id
        LIMIT 1
    ) ps ON true
    WHERE (p_branch_id IS NULL OR r.branch_id::TEXT = p_branch_id)
      AND (p_vendor_search IS NULL OR p_vendor_search = '' OR LOWER(v.vendor_name) LIKE '%' || LOWER(p_vendor_search) || '%')
      AND (p_pr_excel_filter IS NULL OR p_pr_excel_filter = ''
           OR (p_pr_excel_filter = 'verified' AND COALESCE(ps.pr_excel_verified, false) = true)
           OR (p_pr_excel_filter = 'unverified' AND COALESCE(ps.pr_excel_verified, false) = false))
      AND (p_erp_ref_filter IS NULL OR p_erp_ref_filter = ''
           OR (p_erp_ref_filter = 'entered' AND r.erp_purchase_invoice_reference IS NOT NULL AND TRIM(r.erp_purchase_invoice_reference::TEXT) <> '')
           OR (p_erp_ref_filter = 'not_entered' AND (r.erp_purchase_invoice_reference IS NULL OR TRIM(r.erp_purchase_invoice_reference::TEXT) = '')))
    ORDER BY r.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;

--

CREATE FUNCTION public.get_server_disk_usage() RETURNS TABLE(filesystem text, total_size text, used_size text, available_size text, use_percent integer, mount_point text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
BEGIN
  CREATE TEMP TABLE IF NOT EXISTS _disk_raw (line text) ON COMMIT DROP;

--

CREATE FUNCTION public.get_storage_buckets_info() RETURNS TABLE(bucket_id text, bucket_name text, is_public boolean, created_at timestamp with time zone, updated_at timestamp with time zone, file_size_limit bigint, allowed_mime_types text[], file_count bigint, total_size bigint)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public', 'storage'
    AS $$
  SELECT 
    b.id::text AS bucket_id,
    b.name::text AS bucket_name,
    b.public AS is_public,
    b.created_at,
    b.updated_at,
    b.file_size_limit,
    b.allowed_mime_types,
    COALESCE(stats.file_count, 0) AS file_count,
    COALESCE(stats.total_size, 0) AS total_size
  FROM storage.buckets b
  LEFT JOIN (
    SELECT 
      bucket_id,
      COUNT(*) AS file_count,
      SUM(COALESCE((metadata->>'size')::bigint, 0)) AS total_size
    FROM storage.objects
    GROUP BY bucket_id
  ) stats ON stats.bucket_id = b.id
  ORDER BY total_size DESC NULLS LAST;

--

CREATE FUNCTION public.get_storage_stats() RETURNS TABLE(bucket_id text, bucket_name text, file_count bigint, total_size bigint)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        b.id::text AS bucket_id,
        b.name::text AS bucket_name,
        COALESCE(COUNT(o.id), 0) AS file_count,
        COALESCE(SUM((o.metadata->>'size')::bigint), 0) AS total_size
    FROM storage.buckets b
    LEFT JOIN storage.objects o ON o.bucket_id = b.id
    GROUP BY b.id, b.name
    ORDER BY total_size DESC;

--

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
      'â€”'
    ) as expiry_date_formatted
  FROM erp_synced_products esp
  WHERE esp.barcode = ANY(barcode_list)
  ORDER BY esp.barcode;

--

CREATE FUNCTION public.get_table_schemas() RETURNS TABLE(table_name text, column_count bigint, row_estimate bigint, table_size text, total_size text, schema_ddl text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  rec RECORD;

--

CREATE FUNCTION public.get_user_assigned_tasks(user_id_param text, branch_id_param uuid DEFAULT NULL::uuid, status_filter text DEFAULT NULL::text, limit_param integer DEFAULT 50, offset_param integer DEFAULT 0) RETURNS TABLE(id uuid, title text, description text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean, can_escalate boolean, can_reassign boolean, created_by text, created_by_name text, status text, priority text, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, due_time time without time zone, assignment_status text, assigned_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id, t.title, t.description, t.require_task_finished, t.require_photo_upload, t.require_erp_reference,
        t.can_escalate, t.can_reassign, t.created_by, t.created_by_name, t.status, t.priority,
        t.created_at, t.updated_at, t.due_date, t.due_time,
        ta.status as assignment_status, ta.assigned_at
    FROM public.tasks t
    INNER JOIN public.task_assignments ta ON t.id = ta.task_id
    WHERE t.deleted_at IS NULL
    AND (
        ta.assignment_type = 'all' 
        OR (ta.assignment_type = 'user' AND ta.assigned_to_user_id = user_id_param)
        OR (ta.assignment_type = 'branch' AND ta.assigned_to_branch_id = branch_id_param)
    )
    AND (status_filter IS NULL OR t.status = status_filter)
    ORDER BY t.created_at DESC
    LIMIT limit_param OFFSET offset_param;

--

CREATE FUNCTION public.get_vendor_pending_summary() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;

--

CREATE FUNCTION public.get_wa_catalog_stats(p_account_id uuid) RETURNS TABLE(total_catalogs bigint, total_products bigint, active_products bigint, hidden_products bigint, total_orders bigint, pending_orders bigint, total_revenue numeric)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT
        (SELECT count(*) FROM wa_catalogs WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id AND status = 'active' AND NOT is_hidden),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id AND is_hidden),
        (SELECT count(*) FROM wa_catalog_orders WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_orders WHERE wa_account_id = p_account_id AND order_status = 'pending'),
        (SELECT COALESCE(sum(total), 0) FROM wa_catalog_orders WHERE wa_account_id = p_account_id AND order_status NOT IN ('cancelled', 'refunded'));

--

CREATE FUNCTION public.get_wa_contacts(p_limit integer DEFAULT 100, p_offset integer DEFAULT 0, p_search text DEFAULT NULL::text) RETURNS TABLE(id uuid, name text, whatsapp_number character varying, registration_status text, whatsapp_available boolean, created_at timestamp with time zone, approved_at timestamp with time zone, last_login_at timestamp with time zone, is_deleted boolean, conversation_id uuid, last_message_at timestamp with time zone, last_interaction_at timestamp with time zone, unread_count integer, is_inside_24hr boolean, handled_by text, is_bot_handling boolean, total_count bigint)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT
    c.id,
    c.name::text AS name,
    c.whatsapp_number,
    c.registration_status,
    c.whatsapp_available,
    c.created_at,
    c.approved_at,
    c.last_login_at,
    COALESCE(c.is_deleted, false) AS is_deleted,
    conv.id AS conversation_id,
    conv.last_message_at,
    GREATEST(conv.last_message_at, code_hist.last_code_at, c.created_at) AS last_interaction_at,
    COALESCE(conv.unread_count, 0)::int AS unread_count,
    CASE
      WHEN conv.last_message_at IS NOT NULL
        AND conv.last_message_at > (now() - interval '24 hours')
      THEN true
      ELSE false
    END AS is_inside_24hr,
    COALESCE(conv.handled_by, 'bot') AS handled_by,
    COALESCE(conv.is_bot_handling, true) AS is_bot_handling,
    COUNT(*) OVER() AS total_count
  FROM customers c
  LEFT JOIN LATERAL (
    SELECT wc.id, wc.last_message_at, wc.unread_count, wc.handled_by, wc.is_bot_handling
    FROM wa_conversations wc
    WHERE wc.customer_phone = c.whatsapp_number
      AND wc.status = 'active'
    ORDER BY wc.created_at DESC
    LIMIT 1
  ) conv ON true
  LEFT JOIN LATERAL (
    SELECT MAX(ach.created_at) AS last_code_at
    FROM customer_access_code_history ach
    WHERE ach.customer_id = c.id
  ) code_hist ON true
  WHERE c.whatsapp_number IS NOT NULL
    AND c.whatsapp_number != ''
    AND COALESCE(c.is_deleted, false) = false
    AND (
      p_search IS NULL
      OR c.name ILIKE '%' || p_search || '%'
      OR c.whatsapp_number ILIKE '%' || p_search || '%'
    )
  ORDER BY GREATEST(conv.last_message_at, code_hist.last_code_at, c.created_at) DESC NULLS LAST
  LIMIT p_limit
  OFFSET p_offset;

--

CREATE FUNCTION public.get_wa_conversations_fast(p_account_id uuid, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0, p_search text DEFAULT NULL::text, p_filter text DEFAULT 'all'::text) RETURNS TABLE(id uuid, customer_phone character varying, customer_name text, last_message_at timestamp with time zone, last_message_preview text, unread_count integer, is_bot_handling boolean, bot_type character varying, handled_by character varying, needs_human boolean, status character varying, is_inside_24hr boolean, is_sos boolean, total_count bigint)
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
      -- Exclude priority conversations (SOS / needs_human) — they go in their own section
      AND c.is_sos IS NOT TRUE
      AND c.needs_human IS NOT TRUE
      -- Search filter
      AND (
          p_search IS NULL
          OR p_search = ''
          OR c.customer_name ILIKE '%' || p_search || '%'
          OR c.customer_phone ILIKE '%' || p_search || '%'
      )
      -- Chat filter
      AND (
          p_filter = 'all'
          OR (p_filter = 'unread' AND c.unread_count > 0)
          OR (p_filter = 'ai' AND c.is_bot_handling = TRUE AND c.bot_type = 'ai')
          OR (p_filter = 'bot' AND c.is_bot_handling = TRUE AND c.bot_type = 'auto_reply')
          OR (p_filter = 'human' AND c.is_bot_handling = FALSE)
      )
    ORDER BY c.last_message_at DESC NULLS LAST
    LIMIT p_limit
    OFFSET p_offset;

--

CREATE FUNCTION public.import_sync_batch(p_table_name text, p_data jsonb) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE 
    v_count integer := 0;

--

CREATE FUNCTION public.increment_flyer_template_usage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE flyer_templates
  SET 
    usage_count = usage_count + 1,
    last_used_at = now()
  WHERE id = NEW.template_id;

--

CREATE FUNCTION public.increment_page_visit_count(offer_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE view_offer
  SET page_visit_count = page_visit_count + 1
  WHERE id = offer_id;

BEGIN
  IF _platform = 'facebook' THEN
    UPDATE social_links SET facebook_clicks = facebook_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'whatsapp' THEN
    UPDATE social_links SET whatsapp_clicks = whatsapp_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'instagram' THEN
    UPDATE social_links SET instagram_clicks = instagram_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'tiktok' THEN
    UPDATE social_links SET tiktok_clicks = tiktok_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'snapchat' THEN
    UPDATE social_links SET snapchat_clicks = snapchat_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'website' THEN
    UPDATE social_links SET website_clicks = website_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'location_link' THEN
    UPDATE social_links SET location_link_clicks = location_link_clicks + 1 WHERE branch_id = _branch_id;

--

CREATE FUNCTION public.increment_view_button_count(offer_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE view_offer
  SET view_button_count = view_button_count + 1
  WHERE id = offer_id;

--

CREATE FUNCTION public.is_quick_access_code_available(p_quick_access_code character varying) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN NOT EXISTS (
    SELECT 1 FROM users
    WHERE extensions.crypt(p_quick_access_code, quick_access_code) = quick_access_code
  );

--

CREATE FUNCTION public.mark_overdue_quick_tasks() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Mark main tasks as overdue
    UPDATE quick_tasks 
    SET status = 'overdue', updated_at = NOW()
    WHERE deadline_datetime < NOW() 
    AND status NOT IN ('completed', 'overdue');

--

COMMENT ON FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text, generated_by_role text) IS 'Generates tasks and notifications when a clearance certificate is created. Fixed to properly set deadline_date, deadline_time, and require_task_finished=true for all task assignments. Purchasing Manager gets 72-hour deadline, all others get 24-hour deadline.';

ELSE -- p_action = 'reject'
        -- Update recovery request status
        UPDATE public.customer_recovery_requests
        SET 
            verification_status = 'rejected',
            processed_by = p_admin_user_id,
            processed_at = v_current_time,
            verification_notes = p_notes
        WHERE id = p_request_id;

--

CREATE FUNCTION public.reassign_task(assignment_id uuid, new_assignee uuid, reassigned_by uuid, reason text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE task_assignments 
    SET 
        assigned_to = new_assignee,
        reassigned_by = reassigned_by,
        reassignment_reason = reason,
        updated_at = NOW()
    WHERE id = assignment_id;

--

CREATE FUNCTION public.refresh_broadcast_status(p_broadcast_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_total int;

BEGIN
    -- Step 1: Update broadcast recipients whose wa_messages have a higher status
    UPDATE wa_broadcast_recipients r
    SET status = sub.new_status
    FROM (
        SELECT 
            r2.id AS recipient_id,
            (
                SELECT m.status
                FROM wa_messages m
                WHERE m.whatsapp_message_id = r2.whatsapp_message_id
                ORDER BY 
                    CASE m.status
                        WHEN 'read' THEN 3
                        WHEN 'delivered' THEN 2
                        WHEN 'sent' THEN 1
                        ELSE 0
                    END DESC
                LIMIT 1
            ) AS new_status
        FROM wa_broadcast_recipients r2
        WHERE r2.broadcast_id = p_broadcast_id
          AND r2.whatsapp_message_id IS NOT NULL
    ) sub
    WHERE r.id = sub.recipient_id
      AND sub.new_status IS NOT NULL
      AND (
          CASE sub.new_status
              WHEN 'read' THEN 3
              WHEN 'delivered' THEN 2
              WHEN 'sent' THEN 1
              ELSE 0
          END
      ) > (
          CASE r.status
              WHEN 'read' THEN 3
              WHEN 'delivered' THEN 2
              WHEN 'sent' THEN 1
              ELSE 0
          END
      );

--

CREATE FUNCTION public.refresh_edge_functions_cache(p_functions jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  DELETE FROM public.edge_functions_cache;

BEGIN
    -- Check if function already exists
    IF EXISTS (SELECT 1 FROM app_functions WHERE function_code = p_function_code) THEN
        -- Update existing function
        UPDATE app_functions 
        SET function_name = p_function_name,
            description = COALESCE(p_description, description),
            category = p_category,
            is_active = p_enabled,
            updated_at = CURRENT_TIMESTAMP
        WHERE function_code = p_function_code
        RETURNING id INTO new_id;

BEGIN
    -- Try to update existing subscription first
    UPDATE push_subscriptions 
    SET 
        endpoint = p_endpoint,
        p256dh = p_p256dh,
        auth = p_auth,
        device_type = p_device_type,
        browser_name = p_browser_name,
        user_agent = p_user_agent,
        is_active = true,
        last_seen = NOW(),
        updated_at = NOW()
    WHERE user_id = p_user_id AND device_id = p_device_id
    RETURNING id INTO subscription_id;

--

CREATE FUNCTION public.request_access_code_change(p_email character varying, p_whatsapp character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;

--

CREATE FUNCTION public.request_access_code_resend(p_whatsapp_number text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer record;

UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = now(),
        updated_at = now()
    WHERE id = v_customer.id;

--

CREATE FUNCTION public.request_server_restart() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- Write a trigger file to the shared volume (PG data dir)
  -- Host path: /opt/supabase/supabase/docker/volumes/db/data/restart_trigger
  -- Container path: /var/lib/postgresql/data/restart_trigger
  COPY (SELECT 'restart_requested_at_' || now()::text) 
    TO '/var/lib/postgresql/data/restart_trigger';

--

CREATE FUNCTION public.reschedule_visit(visit_id uuid, new_date date) RETURNS date
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the visit with the new date
    UPDATE vendor_visits 
    SET next_visit_date = new_date, updated_at = NOW()
    WHERE id = visit_id;

--

CREATE FUNCTION public.search_tasks(search_query text, user_id_param text DEFAULT NULL::text, limit_param integer DEFAULT 50, offset_param integer DEFAULT 0) RETURNS TABLE(id uuid, title text, description text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean, can_escalate boolean, can_reassign boolean, created_by text, created_by_name text, status text, priority text, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, due_time time without time zone, rank real)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id, t.title, t.description, t.require_task_finished, t.require_photo_upload, t.require_erp_reference,
        t.can_escalate, t.can_reassign, t.created_by, t.created_by_name, t.status, t.priority,
        t.created_at, t.updated_at, t.due_date, t.due_time,
        ts_rank(t.search_vector, plainto_tsquery('english', search_query)) as rank
    FROM public.tasks t
    WHERE t.deleted_at IS NULL
    AND (
        search_query IS NULL 
        OR search_query = '' 
        OR t.search_vector @@ plainto_tsquery('english', search_query)
        OR t.title ILIKE '%' || search_query || '%'
        OR t.description ILIKE '%' || search_query || '%'
    )
    ORDER BY 
        CASE WHEN search_query IS NOT NULL AND search_query != '' 
        THEN ts_rank(t.search_vector, plainto_tsquery('english', search_query)) 
        ELSE 0 END DESC,
        t.created_at DESC
    LIMIT limit_param OFFSET offset_param;

--

CREATE FUNCTION public.set_user_context(user_id uuid, is_master_admin boolean DEFAULT false, is_admin boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Set configuration variables that RLS policies can access
  PERFORM set_config('app.current_user_id', user_id::text, false);

permissions_set INTEGER := 0;

permissions_set := permissions_set + 1;

--

CREATE FUNCTION public.skip_visit(visit_id uuid, skip_reason text DEFAULT ''::text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the record to mark as handled (no date change for skip)
    UPDATE vendor_visits 
    SET updated_at = NOW()
    WHERE id = visit_id;

BEGIN
    -- Process all unsynced inventory manager task completions
    FOR sync_record IN
        SELECT 
            tc.id as completion_id,
            tc.task_id,
            tc.erp_reference_number,
            rt.receiving_record_id,
            rt.role_type,
            rr.erp_purchase_invoice_reference as current_erp
        FROM task_completions tc
        JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
        JOIN receiving_records rr ON rt.receiving_record_id = rr.id
        WHERE tc.erp_reference_completed = true 
          AND tc.erp_reference_number IS NOT NULL 
          AND TRIM(tc.erp_reference_number) != ''
          AND rt.role_type = 'inventory_manager'
          AND (rr.erp_purchase_invoice_reference IS NULL 
               OR rr.erp_purchase_invoice_reference != TRIM(tc.erp_reference_number))
    LOOP
        -- Update the receiving record
        UPDATE receiving_records 
        SET 
            erp_purchase_invoice_reference = TRIM(sync_record.erp_reference_number),
            updated_at = now()
        WHERE id = sync_record.receiving_record_id;

BEGIN
    -- Find all receiving records that need ERP sync
    FOR sync_record IN
        SELECT 
            rr.id as receiving_record_id,
            tc.erp_reference_number,
            rr.erp_purchase_invoice_reference as current_erp,
            tc.completed_by
        FROM receiving_records rr
        JOIN receiving_tasks rt ON rr.id = rt.receiving_record_id
        JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
        WHERE rt.role_type = 'inventory_manager'
          AND tc.erp_reference_completed = true
          AND tc.erp_reference_number IS NOT NULL
          AND TRIM(tc.erp_reference_number) != ''
          AND (rr.erp_purchase_invoice_reference IS NULL 
               OR rr.erp_purchase_invoice_reference != TRIM(tc.erp_reference_number))
        ORDER BY tc.completed_at DESC
    LOOP
        -- Update the receiving record
        UPDATE receiving_records 
        SET 
            erp_purchase_invoice_reference = TRIM(sync_record.erp_reference_number),
            updated_at = now()
        WHERE id = sync_record.receiving_record_id;

--

CREATE FUNCTION public.sync_employee_with_hr(p_employee_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Update user information based on employee record
    UPDATE users u
    SET 
        updated_at = NOW()
    FROM hr_employees e
    WHERE u.employee_id = e.id
      AND e.id = p_employee_id;

--

CREATE FUNCTION public.sync_erp_references_from_task_completions() RETURNS TABLE(receiving_record_id uuid, erp_reference_updated text, sync_status text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH erp_updates AS (
        UPDATE receiving_records rr
        SET 
            erp_purchase_invoice_reference = tc.erp_reference_number,
            updated_at = now()
        FROM task_completions tc
        JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
        WHERE rt.receiving_record_id = rr.id
        AND rt.role_type = 'inventory_manager'
        AND tc.erp_reference_completed = true
        AND tc.erp_reference_number IS NOT NULL
        AND tc.erp_reference_number != ''
        AND (rr.erp_purchase_invoice_reference IS NULL OR rr.erp_purchase_invoice_reference != tc.erp_reference_number)
        RETURNING rr.id as receiving_record_id, tc.erp_reference_number::TEXT, 'updated'::TEXT as sync_status
    )
    SELECT 
        eu.receiving_record_id,
        eu.erp_reference_number,
        eu.sync_status
    FROM erp_updates eu;

ELSE
            -- Balance still exists - update the amounts
            UPDATE expense_requisitions
            SET 
                remaining_balance = scheduler_balance,
                used_amount = original_amount - scheduler_balance,
                updated_at = NOW()
            WHERE id = NEW.requisition_id;

--

CREATE FUNCTION public.trigger_log_order_offer_usage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update offer_usage_logs with order_id for items that have offers
    UPDATE offer_usage_logs
    SET order_id = NEW.order_id
    WHERE offer_id IN (
        SELECT offer_id
        FROM order_items
        WHERE order_id = NEW.order_id
        AND has_offer = TRUE
        AND offer_id IS NOT NULL
    )
    AND order_id IS NULL
    AND customer_id = (
        SELECT customer_id FROM orders WHERE id = NEW.order_id
    )
    AND used_at >= (
        SELECT created_at FROM orders WHERE id = NEW.order_id
    ) - INTERVAL '1 minute';

--

CREATE FUNCTION public.trigger_update_order_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Recalculate total items and quantities when order_items change
    UPDATE orders
    SET total_items = (
            SELECT COUNT(*)
            FROM order_items
            WHERE order_id = COALESCE(NEW.order_id, OLD.order_id)
        ),
        total_quantity = (
            SELECT COALESCE(SUM(quantity), 0)
            FROM order_items
            WHERE order_id = COALESCE(NEW.order_id, OLD.order_id)
        ),
        updated_at = NOW()
    WHERE id = COALESCE(NEW.order_id, OLD.order_id);

--

CREATE FUNCTION public.update_branch_sync_status(p_branch_id bigint, p_status text, p_details jsonb DEFAULT '{}'::jsonb) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    UPDATE branch_sync_config
    SET last_sync_at = now(),
        last_sync_status = p_status,
        last_sync_details = p_details,
        updated_at = now()
    WHERE branch_id = p_branch_id;

--

CREATE FUNCTION public.update_notification_attachments_flag() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE notifications 
        SET has_attachments = TRUE,
            updated_at = NOW()
        WHERE id = NEW.notification_id;

ELSIF TG_OP = 'DELETE' THEN
        UPDATE notifications 
        SET has_attachments = (
            SELECT COUNT(*) > 0 
            FROM notification_attachments 
            WHERE notification_id = OLD.notification_id
        ),
        updated_at = NOW()
        WHERE id = OLD.notification_id;

--

CREATE FUNCTION public.update_notification_delivery_status() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- When a notification_queue item is marked as 'sent', update the recipient's delivery status
    IF NEW.status = 'sent' AND OLD.status != 'sent' THEN
        UPDATE notification_recipients
        SET 
            delivery_status = 'delivered',
            delivery_attempted_at = NEW.sent_at,
            updated_at = NOW()
        WHERE notification_id = NEW.notification_id
        AND user_id = NEW.user_id;

--

CREATE FUNCTION public.update_notification_read_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update read_count in notifications table when recipient read status changes
    IF TG_OP = 'UPDATE' AND OLD.is_read = FALSE AND NEW.is_read = TRUE THEN
        UPDATE notifications 
        SET read_count = read_count + 1,
            updated_at = NOW()
        WHERE id = NEW.notification_id;

ELSIF TG_OP = 'UPDATE' AND OLD.is_read = TRUE AND NEW.is_read = FALSE THEN
        UPDATE notifications 
        SET read_count = GREATEST(read_count - 1, 0),
            updated_at = NOW()
        WHERE id = NEW.notification_id;

--

CREATE FUNCTION public.update_quick_task_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update main task status based on individual assignments
    IF TG_OP = 'UPDATE' THEN
        -- Check if all assignments are completed
        IF (SELECT COUNT(*) FROM quick_task_assignments 
            WHERE quick_task_id = NEW.quick_task_id AND status != 'completed') = 0 THEN
            
            UPDATE quick_tasks 
            SET status = 'completed', completed_at = NOW(), updated_at = NOW()
            WHERE id = NEW.quick_task_id;

--

CREATE FUNCTION public.update_requisition_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only update if requisition_id is not null
  IF NEW.requisition_id IS NOT NULL THEN
    -- Update the expense_requisitions table
    UPDATE public.expense_requisitions
    SET 
      used_amount = (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = NEW.requisition_id
          AND status != 'cancelled'
      ),
      remaining_balance = amount - (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = NEW.requisition_id
          AND status != 'cancelled'
      ),
      updated_at = now()
    WHERE id = NEW.requisition_id;

--

CREATE FUNCTION public.update_requisition_balance_old() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Handle the old requisition_id if it exists and is different
  IF OLD.requisition_id IS NOT NULL AND (TG_OP = 'DELETE' OR OLD.requisition_id != NEW.requisition_id) THEN
    UPDATE public.expense_requisitions
    SET 
      used_amount = (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = OLD.requisition_id
          AND status != 'cancelled'
      ),
      remaining_balance = amount - (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = OLD.requisition_id
          AND status != 'cancelled'
      ),
      updated_at = now()
    WHERE id = OLD.requisition_id;

BEGIN
    -- 1. Update the request status
    UPDATE product_request_st
    SET status = p_new_status, updated_at = NOW()
    WHERE id = p_request_id
    RETURNING requester_user_id INTO v_requester_user_id;

--

CREATE FUNCTION public.update_user(p_user_id uuid, p_username character varying DEFAULT NULL::character varying, p_is_master_admin boolean DEFAULT NULL::boolean, p_is_admin boolean DEFAULT NULL::boolean, p_user_type character varying DEFAULT NULL::character varying, p_branch_id bigint DEFAULT NULL::bigint, p_employee_id uuid DEFAULT NULL::uuid, p_position_id uuid DEFAULT NULL::uuid, p_status character varying DEFAULT NULL::character varying, p_avatar text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- Check if user exists
  IF NOT EXISTS (SELECT 1 FROM users WHERE id = p_user_id) THEN
    RETURN json_build_object(
      'success', false,
      'message', 'User not found'
    );

IF p_is_master_admin IS NOT NULL THEN
    UPDATE users SET is_master_admin = p_is_master_admin, updated_at = NOW() WHERE id = p_user_id;

IF p_is_admin IS NOT NULL THEN
    UPDATE users SET is_admin = p_is_admin, updated_at = NOW() WHERE id = p_user_id;

IF p_user_type IS NOT NULL THEN
    UPDATE users SET user_type = p_user_type::user_type_enum, updated_at = NOW() WHERE id = p_user_id;

IF p_branch_id IS NOT NULL THEN
    UPDATE users SET branch_id = p_branch_id, updated_at = NOW() WHERE id = p_user_id;

IF p_employee_id IS NOT NULL THEN
    UPDATE users SET employee_id = p_employee_id, updated_at = NOW() WHERE id = p_user_id;

IF p_position_id IS NOT NULL THEN
    UPDATE users SET position_id = p_position_id, updated_at = NOW() WHERE id = p_user_id;

IF p_status IS NOT NULL THEN
    UPDATE users SET status = p_status, updated_at = NOW() WHERE id = p_user_id;

IF p_avatar IS NOT NULL THEN
    UPDATE users SET avatar = p_avatar, updated_at = NOW() WHERE id = p_user_id;

--

CREATE FUNCTION public.upsert_app_icon(p_icon_key text, p_name text, p_category text, p_storage_path text, p_mime_type text DEFAULT NULL::text, p_file_size bigint DEFAULT 0, p_description text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_id uuid;

--

CREATE FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text DEFAULT NULL::text, p_ssh_user text DEFAULT 'u'::text) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_id bigint;

UPDATE erp_synced_products
      SET 
        auto_barcode = COALESCE(v_product->>'auto_barcode', auto_barcode),
        parent_barcode = COALESCE(v_product->>'parent_barcode', parent_barcode),
        product_name_en = COALESCE(v_product->>'product_name_en', product_name_en),
        product_name_ar = COALESCE(v_product->>'product_name_ar', product_name_ar),
        unit_name = COALESCE(v_product->>'unit_name', unit_name),
        unit_qty = COALESCE((v_product->>'unit_qty')::numeric, unit_qty),
        is_base_unit = COALESCE((v_product->>'is_base_unit')::boolean, is_base_unit),
        expiry_dates = v_merged_expiry,
        synced_at = NOW()
      WHERE barcode = v_product->>'barcode';

--

CREATE FUNCTION public.validate_break_code(p_code text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_seed text;

ELSE
            -- Auto-update the receiving task if bill is already uploaded
            UPDATE receiving_tasks 
            SET 
                original_bill_uploaded = true,
                original_bill_file_path = receiving_record.original_bill_url,
                updated_at = now()
            WHERE id = receiving_task_id_param;

--

CREATE FUNCTION public.verify_otp_and_change_access_code(p_email character varying, p_whatsapp character varying, p_otp character varying, p_new_code character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;

UPDATE users
  SET quick_access_code = v_hashed_code,
      updated_at = NOW()
  WHERE id = v_user_id;

--

CREATE FUNCTION public.verify_quick_access_code(p_code character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE
  v_user RECORD;

UPDATE quick_task_completions 
    SET completion_status = new_status,
        verified_by_user_id = verified_by_user_id_param,
        verified_at = now(),
        verification_notes = verification_notes_param,
        updated_at = now()
    WHERE id = completion_id_param;

SET default_tablespace = '';

SET default_table_access_method = heap;

--

COMMENT ON COLUMN public.customers.is_deleted IS 'Soft delete flag - set to true when customer deletes their account';

--

COMMENT ON CONSTRAINT at_least_one_discount ON public.offer_products IS 'Ensures at least one discount field is set. Both can be set for percentage offers (stores calculated price).';

To set up automatic daily execution:
1. Enable pg_cron extension in Supabase (may require contacting support)
2. Create cron job: 
   SELECT cron.schedule(''check-recurring-schedules'', ''0 6 * * *'', 
   $$SELECT check_and_notify_recurring_schedules_with_logging();

--

ALTER TABLE ONLY public.ai_chat_guide ALTER COLUMN id SET DEFAULT nextval('public.ai_chat_guide_id_seq'::regclass);

--

ALTER TABLE ONLY public.approval_permissions ALTER COLUMN id SET DEFAULT nextval('public.approval_permissions_id_seq'::regclass);

--

ALTER TABLE ONLY public.approver_branch_access ALTER COLUMN id SET DEFAULT nextval('public.approver_branch_access_id_seq'::regclass);

--

ALTER TABLE ONLY public.approver_visibility_config ALTER COLUMN id SET DEFAULT nextval('public.approver_visibility_config_id_seq'::regclass);

--

ALTER TABLE ONLY public.asset_main_categories ALTER COLUMN id SET DEFAULT nextval('public.asset_main_categories_id_seq'::regclass);

--

ALTER TABLE ONLY public.asset_sub_categories ALTER COLUMN id SET DEFAULT nextval('public.asset_sub_categories_id_seq'::regclass);

--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);

--

ALTER TABLE ONLY public.bank_reconciliations ALTER COLUMN id SET DEFAULT nextval('public.bank_reconciliations_id_seq'::regclass);

--

ALTER TABLE ONLY public.bogo_offer_rules ALTER COLUMN id SET DEFAULT nextval('public.bogo_offer_rules_id_seq'::regclass);

--

ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);

--

ALTER TABLE ONLY public.break_reasons ALTER COLUMN id SET DEFAULT nextval('public.break_reasons_id_seq'::regclass);

--

ALTER TABLE ONLY public.denomination_types ALTER COLUMN id SET DEFAULT nextval('public.denomination_types_id_seq'::regclass);

--

ALTER TABLE ONLY public.desktop_themes ALTER COLUMN id SET DEFAULT nextval('public.desktop_themes_id_seq'::regclass);

--

ALTER TABLE ONLY public.employee_checklist_assignments ALTER COLUMN id SET DEFAULT nextval('public.employee_checklist_assignments_id_seq'::regclass);

--

ALTER TABLE ONLY public.erp_sync_logs ALTER COLUMN id SET DEFAULT nextval('public.erp_sync_logs_id_seq'::regclass);

--

ALTER TABLE ONLY public.erp_synced_products ALTER COLUMN id SET DEFAULT nextval('public.erp_synced_products_id_seq'::regclass);

--

ALTER TABLE ONLY public.expense_parent_categories ALTER COLUMN id SET DEFAULT nextval('public.expense_parent_categories_id_seq'::regclass);

--

ALTER TABLE ONLY public.expense_requisitions ALTER COLUMN id SET DEFAULT nextval('public.expense_requisitions_id_seq'::regclass);

--

ALTER TABLE ONLY public.expense_scheduler ALTER COLUMN id SET DEFAULT nextval('public.expense_scheduler_id_seq'::regclass);

--

ALTER TABLE ONLY public.expense_sub_categories ALTER COLUMN id SET DEFAULT nextval('public.expense_sub_categories_id_seq'::regclass);

--

ALTER TABLE ONLY public.frontend_builds ALTER COLUMN id SET DEFAULT nextval('public.frontend_builds_id_seq'::regclass);

--

ALTER TABLE ONLY public.hr_analysed_attendance_data ALTER COLUMN id SET DEFAULT nextval('public.hr_analysed_attendance_data_id_seq'::regclass);

--

ALTER TABLE ONLY public.mobile_themes ALTER COLUMN id SET DEFAULT nextval('public.mobile_themes_id_seq'::regclass);

--

ALTER TABLE ONLY public.multi_shift_date_wise ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_date_wise_id_seq'::regclass);

--

ALTER TABLE ONLY public.multi_shift_regular ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_regular_id_seq'::regclass);

--

ALTER TABLE ONLY public.multi_shift_weekday ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_weekday_id_seq'::regclass);

--

ALTER TABLE ONLY public.non_approved_payment_scheduler ALTER COLUMN id SET DEFAULT nextval('public.non_approved_payment_scheduler_id_seq'::regclass);

--

ALTER TABLE ONLY public.offer_bundles ALTER COLUMN id SET DEFAULT nextval('public.offer_bundles_id_seq'::regclass);

--

ALTER TABLE ONLY public.offer_cart_tiers ALTER COLUMN id SET DEFAULT nextval('public.offer_cart_tiers_id_seq'::regclass);

--

ALTER TABLE ONLY public.offer_usage_logs ALTER COLUMN id SET DEFAULT nextval('public.offer_usage_logs_id_seq'::regclass);

--

ALTER TABLE ONLY public.offers ALTER COLUMN id SET DEFAULT nextval('public.offers_id_seq'::regclass);

--

ALTER TABLE ONLY public.recurring_schedule_check_log ALTER COLUMN id SET DEFAULT nextval('public.recurring_schedule_check_log_id_seq'::regclass);

--

ALTER TABLE ONLY public.system_api_keys ALTER COLUMN id SET DEFAULT nextval('public.system_api_keys_id_seq'::regclass);

--

ALTER TABLE ONLY public.user_mobile_theme_assignments ALTER COLUMN id SET DEFAULT nextval('public.user_mobile_theme_assignments_id_seq'::regclass);

--

ALTER TABLE ONLY public.user_theme_assignments ALTER COLUMN id SET DEFAULT nextval('public.user_theme_assignments_id_seq'::regclass);

--

ALTER TABLE ONLY public.ai_chat_guide
    ADD CONSTRAINT ai_chat_guide_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_accountant_user_id_fkey FOREIGN KEY (accountant_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_manager_user_id_fkey FOREIGN KEY (branch_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_inventory_manager_user_id_fkey FOREIGN KEY (inventory_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_purchasing_manager_user_id_fkey FOREIGN KEY (purchasing_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_warehouse_handler_user_id_fkey FOREIGN KEY (warehouse_handler_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.coupon_campaigns
    ADD CONSTRAINT coupon_campaigns_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_claimed_by_user_fkey FOREIGN KEY (claimed_by_user) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.coupon_products(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT coupon_eligible_customers_imported_by_fkey FOREIGN KEY (imported_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_approval_approved_by_fkey FOREIGN KEY (approval_approved_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_approval_requested_by_fkey FOREIGN KEY (approval_requested_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_day_off_reason_id_fkey FOREIGN KEY (day_off_reason_id) REFERENCES public.day_off_reasons(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.desktop_themes
    ADD CONSTRAINT desktop_themes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.employee_fine_payments
    ADD CONSTRAINT employee_fine_payments_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_approver FOREIGN KEY (approver_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_category FOREIGN KEY (expense_category_id) REFERENCES public.expense_sub_categories(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_requisition FOREIGN KEY (requisition_id) REFERENCES public.expense_requisitions(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_approved_by FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_expense_scheduler FOREIGN KEY (expense_scheduler_id) REFERENCES public.expense_scheduler(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT fk_task_assignments_reassigned_from FOREIGN KEY (reassigned_from) REFERENCES public.task_assignments(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_offer_name_id_fkey FOREIGN KEY (offer_name_id) REFERENCES public.offer_names(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_box_operation_id_fkey FOREIGN KEY (box_operation_id) REFERENCES public.box_operations(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_current_position_id_fkey FOREIGN KEY (current_position_id) REFERENCES public.hr_positions(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_property_space_id_fkey FOREIGN KEY (property_space_id) REFERENCES public.lease_rent_property_spaces(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.lease_rent_properties
    ADD CONSTRAINT lease_rent_property_spaces_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT lease_rent_property_spaces_created_by_fkey1 FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_property_space_id_fkey FOREIGN KEY (property_space_id) REFERENCES public.lease_rent_property_spaces(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_assigned_user_id_fkey FOREIGN KEY (assigned_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.product_units(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_cancelled_by_fkey FOREIGN KEY (cancelled_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_delivery_person_id_fkey FOREIGN KEY (delivery_person_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_picker_id_fkey FOREIGN KEY (picker_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_closed_by_fkey FOREIGN KEY (closed_by) REFERENCES auth.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_verified_by_user_id_fkey FOREIGN KEY (verified_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_assigned_to_branch_id_fkey FOREIGN KEY (assigned_to_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_accountant_user_id_fkey FOREIGN KEY (accountant_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_branch_manager_user_id_fkey FOREIGN KEY (branch_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_inventory_manager_user_id_fkey FOREIGN KEY (inventory_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_purchasing_manager_user_id_fkey FOREIGN KEY (purchasing_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_assigned_user_id_fkey FOREIGN KEY (assigned_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.receiving_task_templates(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.shelf_paper_templates
    ADD CONSTRAINT shelf_paper_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_to_branch_id_fkey FOREIGN KEY (assigned_to_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_to_user_id_fkey FOREIGN KEY (assigned_to_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employees(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_approval_requested_by_fkey FOREIGN KEY (approval_requested_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_assigned_approver_fkey FOREIGN KEY (assigned_approver_id) REFERENCES public.users(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_task_assignment_id_fkey FOREIGN KEY (task_assignment_id) REFERENCES public.task_assignments(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_follow_up_trigger_id_fkey FOREIGN KEY (follow_up_trigger_id) REFERENCES public.wa_auto_reply_triggers(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_reply_template_id_fkey FOREIGN KEY (reply_template_id) REFERENCES public.wa_templates(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_recipient_group_id_fkey FOREIGN KEY (recipient_group_id) REFERENCES public.wa_contact_groups(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.wa_templates(id) ON DELETE SET NULL;

--

ALTER TABLE ONLY public.wa_conversations
    ADD CONSTRAINT wa_conversations_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;

--

GRANT ALL ON FUNCTION public.get_broadcast_recipients(p_broadcast_id uuid, p_limit integer, p_offset integer, p_status_filter text) TO authenticated;

GRANT ALL ON FUNCTION public.get_broadcast_recipients(p_broadcast_id uuid, p_limit integer, p_offset integer, p_status_filter text) TO anon;

--

GRANT ALL ON FUNCTION public.get_closed_boxes(p_branch_id text, p_date_from timestamp with time zone, p_date_to timestamp with time zone, p_limit integer, p_offset integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_closed_boxes(p_branch_id text, p_date_from timestamp with time zone, p_date_to timestamp with time zone, p_limit integer, p_offset integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_customers_list_paginated(p_search text, p_status text, p_limit integer, p_offset integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_customers_list_paginated(p_search text, p_status text, p_limit integer, p_offset integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_products_dashboard_data(p_limit integer, p_offset integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_products_dashboard_data(p_limit integer, p_offset integer) TO anon;

GRANT ALL ON FUNCTION public.get_products_dashboard_data(p_limit integer, p_offset integer) TO service_role;

--

GRANT ALL ON FUNCTION public.get_pv_stock_voucher_items(p_offset integer, p_limit integer) TO authenticated;

GRANT ALL ON FUNCTION public.get_pv_stock_voucher_items(p_offset integer, p_limit integer) TO anon;

--

GRANT ALL ON FUNCTION public.get_receiving_records_with_details(p_limit integer, p_offset integer, p_branch_id text, p_vendor_search text, p_pr_excel_filter text, p_erp_ref_filter text) TO authenticated;

GRANT ALL ON FUNCTION public.get_receiving_records_with_details(p_limit integer, p_offset integer, p_branch_id text, p_vendor_search text, p_pr_excel_filter text, p_erp_ref_filter text) TO anon;

--

GRANT ALL ON FUNCTION public.get_wa_contacts(p_limit integer, p_offset integer, p_search text) TO authenticated;

GRANT ALL ON FUNCTION public.get_wa_contacts(p_limit integer, p_offset integer, p_search text) TO anon;

--

GRANT ALL ON FUNCTION public.get_wa_conversations_fast(p_account_id uuid, p_limit integer, p_offset integer, p_search text, p_filter text) TO anon;

GRANT ALL ON FUNCTION public.get_wa_conversations_fast(p_account_id uuid, p_limit integer, p_offset integer, p_search text, p_filter text) TO authenticated;

GRANT ALL ON FUNCTION public.get_wa_conversations_fast(p_account_id uuid, p_limit integer, p_offset integer, p_search text, p_filter text) TO service_role;