v_tables := v_tables || 'CREATE TABLE IF NOT EXISTS public.' || quote_ident(r.table_name) || ' (' || E'\n';

--

CREATE TABLE IF NOT EXISTS public.access_code_otp (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    otp_code character varying(6) NOT NULL,
    email character varying(255) NOT NULL,
    whatsapp_number character varying(20) NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:05:00'::interval) NOT NULL,
    verified boolean DEFAULT false,
    attempts integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.ai_chat_guide (
    id integer NOT NULL,
    guide_text text DEFAULT ''::text NOT NULL,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.app_icons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    icon_key text NOT NULL,
    category text DEFAULT 'general'::text NOT NULL,
    storage_path text NOT NULL,
    mime_type text,
    file_size bigint DEFAULT 0,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.approval_permissions (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    can_approve_requisitions boolean DEFAULT false NOT NULL,
    requisition_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_single_bill boolean DEFAULT false NOT NULL,
    single_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_multiple_bill boolean DEFAULT false NOT NULL,
    multiple_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_recurring_bill boolean DEFAULT false NOT NULL,
    recurring_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_vendor_payments boolean DEFAULT false NOT NULL,
    vendor_payment_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_leave_requests boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    can_approve_purchase_vouchers boolean DEFAULT false NOT NULL,
    can_add_missing_punches boolean DEFAULT false NOT NULL,
    can_receive_customer_incidents boolean DEFAULT false NOT NULL,
    can_receive_employee_incidents boolean DEFAULT false NOT NULL,
    can_receive_maintenance_incidents boolean DEFAULT false NOT NULL,
    can_receive_vendor_incidents boolean DEFAULT false NOT NULL,
    can_receive_vehicle_incidents boolean DEFAULT false NOT NULL,
    can_receive_government_incidents boolean DEFAULT false NOT NULL,
    can_receive_other_incidents boolean DEFAULT false NOT NULL,
    can_receive_finance_incidents boolean DEFAULT false NOT NULL,
    can_receive_pos_incidents boolean DEFAULT false NOT NULL,
    CONSTRAINT approval_permissions_multiple_bill_limit_check CHECK ((multiple_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_recurring_bill_limit_check CHECK ((recurring_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_requisition_limit_check CHECK ((requisition_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_single_bill_limit_check CHECK ((single_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_vendor_payment_limit_check CHECK ((vendor_payment_amount_limit >= (0)::numeric))
);

--

CREATE TABLE IF NOT EXISTS public.approver_branch_access (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    branch_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT approver_branch_access_active_check CHECK (((is_active = true) OR (is_active = false)))
);

--

CREATE TABLE IF NOT EXISTS public.approver_visibility_config (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    visibility_type character varying(50) DEFAULT 'global'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT approver_visibility_type_check CHECK (((visibility_type)::text = ANY ((ARRAY['global'::character varying, 'branch_specific'::character varying, 'multiple_branches'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.asset_main_categories (
    id integer NOT NULL,
    group_code character varying(20) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.asset_sub_categories (
    id integer NOT NULL,
    category_id integer NOT NULL,
    group_code character varying(20) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    useful_life_years character varying(20),
    annual_depreciation_pct numeric(8,4) DEFAULT 0,
    monthly_depreciation_pct numeric(8,4) DEFAULT 0,
    residual_pct character varying(20) DEFAULT '0%'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.assets (
    id integer NOT NULL,
    asset_id character varying(30) NOT NULL,
    sub_category_id integer NOT NULL,
    asset_name_en character varying(255) NOT NULL,
    asset_name_ar character varying(255) NOT NULL,
    purchase_date date,
    purchase_value numeric(12,2) DEFAULT 0,
    branch_id integer,
    invoice_url text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.bank_reconciliations (
    id integer NOT NULL,
    operation_id uuid NOT NULL,
    branch_id integer,
    pos_number integer DEFAULT 1 NOT NULL,
    supervisor_id uuid,
    cashier_id uuid,
    reconciliation_number character varying(100) DEFAULT ''::character varying NOT NULL,
    mada_amount numeric(12,2) DEFAULT 0 NOT NULL,
    visa_amount numeric(12,2) DEFAULT 0 NOT NULL,
    mastercard_amount numeric(12,2) DEFAULT 0 NOT NULL,
    google_pay_amount numeric(12,2) DEFAULT 0 NOT NULL,
    other_amount numeric(12,2) DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.biometric_connections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    branch_name text NOT NULL,
    server_ip text NOT NULL,
    server_name text,
    database_name text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    device_id text NOT NULL,
    terminal_sn text,
    is_active boolean DEFAULT true,
    last_sync_at timestamp with time zone,
    last_employee_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    branch_location_code text
);

--

CREATE TABLE IF NOT EXISTS public.bogo_offer_rules (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    buy_product_id character varying(50) NOT NULL,
    buy_quantity integer NOT NULL,
    get_product_id character varying(50) NOT NULL,
    get_quantity integer NOT NULL,
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bogo_offer_rules_buy_quantity_check CHECK ((buy_quantity > 0)),
    CONSTRAINT bogo_offer_rules_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('free'::character varying)::text, ('percentage'::character varying)::text, ('amount'::character varying)::text]))),
    CONSTRAINT bogo_offer_rules_discount_value_check CHECK ((discount_value >= (0)::numeric)),
    CONSTRAINT bogo_offer_rules_get_quantity_check CHECK ((get_quantity > 0)),
    CONSTRAINT valid_discount_value CHECK ((((discount_type)::text = 'free'::text) OR (((discount_type)::text = 'percentage'::text) AND (discount_value > (0)::numeric) AND (discount_value <= (100)::numeric)) OR (((discount_type)::text = 'amount'::text) AND (discount_value > (0)::numeric))))
);

--

CREATE TABLE IF NOT EXISTS public.box_operations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    box_number smallint NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    denomination_record_id uuid NOT NULL,
    counts_before jsonb NOT NULL,
    counts_after jsonb NOT NULL,
    total_before numeric(15,2) NOT NULL,
    total_after numeric(15,2) NOT NULL,
    difference numeric(15,2) NOT NULL,
    is_matched boolean NOT NULL,
    status character varying(20) DEFAULT 'in_use'::character varying NOT NULL,
    start_time timestamp with time zone DEFAULT now() NOT NULL,
    end_time timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    closing_details jsonb,
    supervisor_verified_at timestamp with time zone,
    supervisor_id uuid,
    closing_start_date date,
    closing_start_time time without time zone,
    closing_end_date date,
    closing_end_time time without time zone,
    recharge_opening_balance numeric(15,2),
    recharge_close_balance numeric(15,2),
    recharge_sales numeric(15,2),
    bank_mada numeric(15,2),
    bank_visa numeric(15,2),
    bank_mastercard numeric(15,2),
    bank_google_pay numeric(15,2),
    bank_other numeric(15,2),
    bank_total numeric(15,2),
    system_cash_sales numeric(15,2),
    system_card_sales numeric(15,2),
    system_return numeric(15,2),
    difference_cash_sales numeric(15,2),
    difference_card_sales numeric(15,2),
    total_difference numeric(15,2),
    closing_total numeric(15,2),
    closing_cash_500 integer,
    closing_cash_200 integer,
    closing_cash_100 integer,
    closing_cash_50 integer,
    closing_cash_20 integer,
    closing_cash_10 integer,
    closing_cash_5 integer,
    closing_cash_2 integer,
    closing_cash_1 integer,
    closing_cash_050 integer,
    closing_cash_025 integer,
    closing_coins integer,
    total_cash_sales numeric(15,2),
    cash_sales_per_count numeric(15,2),
    vouchers_total numeric(15,2),
    total_erp_cash_sales numeric(15,2),
    total_erp_sales numeric(15,2),
    suspense_paid jsonb,
    suspense_received jsonb,
    pos_before_url text,
    completed_by_user_id uuid,
    completed_by_name text,
    complete_details jsonb,
    CONSTRAINT box_operations_box_number_check CHECK (((box_number >= 1) AND (box_number <= 12))),
    CONSTRAINT box_operations_status_check CHECK (((status)::text = ANY ((ARRAY['in_use'::character varying, 'pending_close'::character varying, 'completed'::character varying, 'cancelled'::character varying, 'draft'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.branch_default_delivery_receivers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id bigint NOT NULL,
    user_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.branch_default_positions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    branch_manager_user_id uuid,
    purchasing_manager_user_id uuid,
    inventory_manager_user_id uuid,
    accountant_user_id uuid,
    night_supervisor_user_ids uuid[] DEFAULT '{}'::uuid[],
    warehouse_handler_user_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.branch_sync_config (
    id bigint NOT NULL,
    branch_id bigint NOT NULL,
    local_supabase_url text NOT NULL,
    local_supabase_key text NOT NULL,
    is_active boolean DEFAULT true,
    last_sync_at timestamp with time zone,
    last_sync_status text,
    last_sync_details jsonb DEFAULT '{}'::jsonb,
    sync_tables text[] DEFAULT ARRAY['branches'::text, 'users'::text, 'user_sessions'::text, 'user_device_sessions'::text, 'button_permissions'::text, 'sidebar_buttons'::text, 'button_main_sections'::text, 'button_sub_sections'::text, 'interface_permissions'::text, 'user_favorite_buttons'::text, 'erp_synced_products'::text, 'product_categories'::text, 'products'::text, 'product_units'::text, 'offers'::text, 'offer_products'::text, 'offer_names'::text, 'offer_bundles'::text, 'offer_cart_tiers'::text, 'bogo_offer_rules'::text, 'flyer_offers'::text, 'flyer_offer_products'::text, 'customers'::text, 'privilege_cards_master'::text, 'privilege_cards_branch'::text, 'desktop_themes'::text, 'user_theme_assignments'::text, 'erp_connections'::text, 'erp_sync_logs'::text],
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    tunnel_url text,
    ssh_user text DEFAULT 'u'::text,
    CONSTRAINT branch_sync_config_last_sync_status_check CHECK ((last_sync_status = ANY (ARRAY['success'::text, 'failed'::text, 'in_progress'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.branches (
    id bigint NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    location_en character varying(500) NOT NULL,
    location_ar character varying(500) NOT NULL,
    is_active boolean DEFAULT true,
    is_main_branch boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by bigint,
    updated_by bigint,
    vat_number character varying(50),
    delivery_service_enabled boolean DEFAULT true NOT NULL,
    pickup_service_enabled boolean DEFAULT true NOT NULL,
    minimum_order_amount numeric(10,2) DEFAULT 15.00,
    is_24_hours boolean DEFAULT true,
    operating_start_time time without time zone,
    operating_end_time time without time zone,
    delivery_message_ar text,
    delivery_message_en text,
    delivery_is_24_hours boolean DEFAULT true,
    delivery_start_time time without time zone,
    delivery_end_time time without time zone,
    pickup_is_24_hours boolean DEFAULT true,
    pickup_start_time time without time zone,
    pickup_end_time time without time zone,
    location_url text,
    latitude double precision,
    longitude double precision,
    CONSTRAINT check_vat_number_not_empty CHECK (((vat_number IS NULL) OR (length(TRIM(BOTH FROM vat_number)) > 0)))
);

--

CREATE TABLE IF NOT EXISTS public.break_reasons (
    id integer NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    requires_note boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.break_register (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    employee_id character varying(50) NOT NULL,
    employee_name_en character varying(200),
    employee_name_ar character varying(200),
    branch_id integer,
    reason_id integer NOT NULL,
    reason_note text,
    start_time timestamp with time zone DEFAULT now() NOT NULL,
    end_time timestamp with time zone,
    duration_seconds integer,
    status character varying(20) DEFAULT 'open'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT break_register_status_check CHECK (((status)::text = ANY ((ARRAY['open'::character varying, 'closed'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.break_security_seed (
    id integer DEFAULT 1 NOT NULL,
    seed text DEFAULT encode(extensions.gen_random_bytes(32), 'hex'::text) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT break_security_seed_id_check CHECK ((id = 1))
);

--

CREATE TABLE IF NOT EXISTS public.button_main_sections (
    id bigint NOT NULL,
    section_name_en character varying(255) NOT NULL,
    section_name_ar character varying(255) NOT NULL,
    section_code character varying(50) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.button_permissions (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    button_id bigint NOT NULL,
    is_enabled boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.button_sub_sections (
    id bigint NOT NULL,
    main_section_id bigint NOT NULL,
    subsection_name_en character varying(255) NOT NULL,
    subsection_name_ar character varying(255) NOT NULL,
    subsection_code character varying(50) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.coupon_campaigns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_name character varying(255),
    campaign_code character varying(50) NOT NULL,
    description text,
    validity_start_date timestamp with time zone,
    validity_end_date timestamp with time zone,
    is_active boolean DEFAULT true,
    terms_conditions_en text,
    terms_conditions_ar text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    max_claims_per_customer integer DEFAULT 1,
    CONSTRAINT valid_campaign_dates CHECK ((end_date > start_date)),
    CONSTRAINT valid_max_claims CHECK ((max_claims_per_customer > 0))
);

--

CREATE TABLE IF NOT EXISTS public.coupon_claims (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    customer_mobile character varying(20) NOT NULL,
    product_id uuid,
    branch_id bigint,
    claimed_by_user uuid,
    claimed_at timestamp with time zone DEFAULT now(),
    print_count integer DEFAULT 1,
    barcode_scanned boolean DEFAULT false,
    validity_date date NOT NULL,
    status character varying(20) DEFAULT 'claimed'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    max_claims_per_customer integer DEFAULT 1,
    CONSTRAINT valid_status CHECK (((status)::text = ANY (ARRAY[('claimed'::character varying)::text, ('redeemed'::character varying)::text, ('expired'::character varying)::text])))
);

--

CREATE TABLE IF NOT EXISTS public.coupon_eligible_customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    mobile_number character varying(20) NOT NULL,
    customer_name character varying(255),
    import_batch_id uuid,
    imported_at timestamp with time zone DEFAULT now(),
    imported_by uuid,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.coupon_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    product_name_en character varying(255) NOT NULL,
    product_name_ar character varying(255) NOT NULL,
    product_image_url text,
    original_price numeric(10,2) NOT NULL,
    offer_price numeric(10,2) NOT NULL,
    special_barcode character varying(50) NOT NULL,
    stock_limit integer DEFAULT 0 NOT NULL,
    stock_remaining integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    flyer_product_id character varying(10),
    CONSTRAINT valid_price CHECK (((offer_price >= (0)::numeric) AND (original_price >= offer_price))),
    CONSTRAINT valid_stock CHECK (((stock_remaining >= 0) AND (stock_remaining <= stock_limit)))
);

--

CREATE TABLE IF NOT EXISTS public.customer_access_code_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    old_access_code text,
    new_access_code text NOT NULL,
    generated_by uuid NOT NULL,
    reason text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_access_code_history_reason_check CHECK ((reason = ANY (ARRAY['initial_generation'::text, 'admin_regeneration'::text, 'security_reset'::text, 'customer_request'::text, 're_registration'::text, 'forgot_code_resend'::text, 'pre_registered_upgrade'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.customer_app_media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    media_type character varying(10) NOT NULL,
    slot_number integer NOT NULL,
    title_en character varying(255) NOT NULL,
    title_ar character varying(255) NOT NULL,
    description_en text,
    description_ar text,
    file_url text NOT NULL,
    file_size bigint,
    file_type character varying(50),
    duration integer,
    is_active boolean DEFAULT false,
    display_order integer DEFAULT 0,
    is_infinite boolean DEFAULT false,
    expiry_date timestamp with time zone,
    uploaded_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    activated_at timestamp with time zone,
    deactivated_at timestamp with time zone,
    CONSTRAINT customer_app_media_media_type_check CHECK (((media_type)::text = ANY (ARRAY[('video'::character varying)::text, ('image'::character varying)::text]))),
    CONSTRAINT customer_app_media_slot_number_check CHECK (((slot_number >= 1) AND (slot_number <= 6))),
    CONSTRAINT expiry_required_unless_infinite CHECK (((is_infinite = true) OR (expiry_date IS NOT NULL)))
);

--

CREATE TABLE IF NOT EXISTS public.customer_product_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    branch_id integer,
    target_user_id uuid,
    status text DEFAULT 'pending'::text NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT customer_product_requests_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'reviewed'::text, 'resolved'::text, 'dismissed'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.customer_recovery_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid,
    whatsapp_number character varying(20) NOT NULL,
    customer_name text,
    request_type text DEFAULT 'account_recovery'::text NOT NULL,
    verification_status text DEFAULT 'pending'::text NOT NULL,
    verification_notes text,
    processed_by uuid,
    processed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_recovery_requests_request_type_check CHECK ((request_type = ANY (ARRAY['account_recovery'::text, 'access_code_request'::text]))),
    CONSTRAINT customer_recovery_requests_verification_status_check CHECK ((verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text, 'processed'::text]))),
    CONSTRAINT customer_recovery_requests_whatsapp_format_check CHECK (((whatsapp_number)::text ~ '^\+?[1-9]\d{1,14}$'::text))
);

--

CREATE TABLE IF NOT EXISTS public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    access_code text,
    whatsapp_number character varying(20),
    registration_status text DEFAULT 'pending'::text NOT NULL,
    registration_notes text,
    approved_by uuid,
    approved_at timestamp with time zone,
    access_code_generated_at timestamp with time zone,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name text,
    location1_name text,
    location1_url text,
    location2_name text,
    location2_url text,
    location3_name text,
    location3_url text,
    location1_lat double precision,
    location1_lng double precision,
    location2_lat double precision,
    location2_lng double precision,
    location3_lat double precision,
    location3_lng double precision,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    whatsapp_available boolean,
    erp_branch_id integer,
    CONSTRAINT customers_location1_name_len CHECK (((location1_name IS NULL) OR (length(location1_name) <= 120))),
    CONSTRAINT customers_location1_url_len CHECK (((location1_url IS NULL) OR (length(location1_url) <= 2048))),
    CONSTRAINT customers_location2_name_len CHECK (((location2_name IS NULL) OR (length(location2_name) <= 120))),
    CONSTRAINT customers_location2_url_len CHECK (((location2_url IS NULL) OR (length(location2_url) <= 2048))),
    CONSTRAINT customers_location3_name_len CHECK (((location3_name IS NULL) OR (length(location3_name) <= 120))),
    CONSTRAINT customers_location3_url_len CHECK (((location3_url IS NULL) OR (length(location3_url) <= 2048))),
    CONSTRAINT customers_registration_status_check CHECK ((registration_status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'suspended'::text, 'pre_registered'::text, 'deleted'::text]))),
    CONSTRAINT customers_whatsapp_format_check CHECK (((whatsapp_number)::text ~ '^\+?[1-9]\d{1,14}$'::text))
);

--

CREATE TABLE IF NOT EXISTS public.day_off (
    id text NOT NULL,
    employee_id text NOT NULL,
    day_off_date date NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    day_off_reason_id character varying(50),
    approval_status character varying(50) DEFAULT 'pending'::character varying,
    approval_requested_by uuid,
    approval_requested_at timestamp with time zone,
    approval_approved_by uuid,
    approval_approved_at timestamp with time zone,
    approval_notes text,
    document_url text,
    document_uploaded_at timestamp with time zone,
    is_deductible_on_salary boolean DEFAULT false,
    rejection_reason text,
    description text,
    CONSTRAINT day_off_approval_status_check CHECK (((approval_status)::text = ANY ((ARRAY['pending'::character varying, 'sent_for_approval'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.day_off_reasons (
    id character varying(50) NOT NULL,
    reason_en character varying(255) NOT NULL,
    reason_ar character varying(255) NOT NULL,
    is_deductible boolean DEFAULT false,
    is_document_mandatory boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.day_off_weekday (
    id text NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT day_off_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);

--

CREATE TABLE IF NOT EXISTS public.default_incident_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    incident_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.deleted_bundle_offers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    original_offer_id integer NOT NULL,
    offer_data jsonb NOT NULL,
    bundles_data jsonb NOT NULL,
    deleted_at timestamp with time zone DEFAULT now(),
    deleted_by uuid,
    deletion_reason text
);

--

CREATE TABLE IF NOT EXISTS public.delivery_fee_tiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    min_order_amount numeric(10,2) NOT NULL,
    max_order_amount numeric(10,2),
    delivery_fee numeric(10,2) NOT NULL,
    tier_order integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description_en text,
    description_ar text,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    branch_id bigint,
    CONSTRAINT check_delivery_fee_positive CHECK ((delivery_fee >= (0)::numeric)),
    CONSTRAINT check_min_amount_positive CHECK ((min_order_amount >= (0)::numeric)),
    CONSTRAINT check_min_max_order CHECK (((max_order_amount IS NULL) OR (max_order_amount > min_order_amount)))
);

--

CREATE TABLE IF NOT EXISTS public.delivery_service_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    minimum_order_amount numeric(10,2) DEFAULT 15.00 NOT NULL,
    is_24_hours boolean DEFAULT true NOT NULL,
    operating_start_time time without time zone,
    operating_end_time time without time zone,
    is_active boolean DEFAULT true NOT NULL,
    display_message_ar text DEFAULT 'التوصيل متاح على مدار الساعة (24/7)'::text,
    display_message_en text DEFAULT 'Delivery available 24/7'::text,
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    customer_login_mask_enabled boolean DEFAULT true NOT NULL,
    CONSTRAINT delivery_settings_singleton CHECK ((id = '00000000-0000-0000-0000-000000000001'::uuid))
);

--

CREATE TABLE IF NOT EXISTS public.denomination_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    record_id uuid NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    action character varying(10) NOT NULL,
    record_type character varying(30) NOT NULL,
    box_number smallint,
    old_counts jsonb,
    new_counts jsonb,
    old_erp_balance numeric(15,2),
    new_erp_balance numeric(15,2),
    old_grand_total numeric(15,2),
    new_grand_total numeric(15,2),
    old_difference numeric(15,2),
    new_difference numeric(15,2),
    change_reason text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT denomination_audit_log_action_check CHECK (((action)::text = ANY ((ARRAY['INSERT'::character varying, 'UPDATE'::character varying, 'DELETE'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.denomination_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    record_type character varying(30) NOT NULL,
    box_number smallint,
    counts jsonb DEFAULT '{}'::jsonb NOT NULL,
    erp_balance numeric(15,2),
    grand_total numeric(15,2) DEFAULT 0 NOT NULL,
    difference numeric(15,2),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    petty_cash_operation jsonb,
    CONSTRAINT denomination_records_box_number_check CHECK (((box_number IS NULL) OR ((box_number >= 1) AND (box_number <= 12)))),
    CONSTRAINT denomination_records_record_type_check CHECK (((record_type)::text = ANY (ARRAY['main'::text, 'advance_box'::text, 'collection_box'::text, 'paid'::text, 'received'::text, 'petty_cash_box'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.denomination_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    section character varying(20) NOT NULL,
    transaction_type character varying(50) NOT NULL,
    amount numeric(15,2) NOT NULL,
    remarks text,
    apply_denomination boolean DEFAULT false,
    denomination_details jsonb DEFAULT '{}'::jsonb,
    entity_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL,
    CONSTRAINT denomination_transactions_section_check CHECK (((section)::text = ANY ((ARRAY['paid'::character varying, 'received'::character varying])::text[]))),
    CONSTRAINT denomination_transactions_transaction_type_check CHECK (((transaction_type)::text = ANY ((ARRAY['vendor'::character varying, 'expenses'::character varying, 'user'::character varying, 'other'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.denomination_types (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    value numeric(10,2) NOT NULL,
    label character varying(50) NOT NULL,
    label_ar character varying(50),
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.denomination_user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.desktop_themes (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) DEFAULT ''::character varying,
    is_default boolean DEFAULT false,
    taskbar_bg character varying(100) DEFAULT 'rgba(0, 102, 178, 0.75)'::character varying,
    taskbar_border character varying(100) DEFAULT 'rgba(255, 255, 255, 0.2)'::character varying,
    taskbar_btn_active_bg character varying(100) DEFAULT 'linear-gradient(135deg, #4F46E5, #6366F1)'::character varying,
    taskbar_btn_active_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    taskbar_btn_inactive_bg character varying(30) DEFAULT 'rgba(255, 255, 255, 0.95)'::character varying,
    taskbar_btn_inactive_text character varying(30) DEFAULT '#0B1220'::character varying,
    taskbar_btn_hover_border character varying(30) DEFAULT '#4F46E5'::character varying,
    taskbar_quick_access_bg character varying(100) DEFAULT 'rgba(255, 255, 255, 0.1)'::character varying,
    sidebar_bg character varying(30) DEFAULT '#374151'::character varying,
    sidebar_text character varying(30) DEFAULT '#e5e7eb'::character varying,
    sidebar_border character varying(30) DEFAULT '#1f2937'::character varying,
    sidebar_favorites_bg character varying(30) DEFAULT '#1d2c5e'::character varying,
    sidebar_favorites_text character varying(30) DEFAULT '#fcd34d'::character varying,
    section_btn_bg character varying(30) DEFAULT '#1DBC83'::character varying,
    section_btn_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    section_btn_hover_bg character varying(30) DEFAULT '#3b82f6'::character varying,
    section_btn_hover_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    subsection_btn_bg character varying(30) DEFAULT '#1DBC83'::character varying,
    subsection_btn_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    subsection_btn_hover_bg character varying(30) DEFAULT '#3b82f6'::character varying,
    subsection_btn_hover_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    submenu_item_bg character varying(30) DEFAULT '#FFFFFF'::character varying,
    submenu_item_text character varying(30) DEFAULT '#f97316'::character varying,
    submenu_item_hover_bg character varying(30) DEFAULT '#3b82f6'::character varying,
    submenu_item_hover_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    logo_bar_bg character varying(100) DEFAULT 'linear-gradient(135deg, #15A34A 0%, #22C55E 100%)'::character varying,
    logo_bar_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    logo_border character varying(30) DEFAULT '#F59E0B'::character varying,
    window_title_active_bg character varying(30) DEFAULT '#0066b2'::character varying,
    window_title_active_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    window_title_inactive_bg character varying(100) DEFAULT 'linear-gradient(135deg, #F9FAFB, #E5E7EB)'::character varying,
    window_title_inactive_text character varying(30) DEFAULT '#374151'::character varying,
    window_border_active character varying(30) DEFAULT '#4F46E5'::character varying,
    desktop_bg character varying(30) DEFAULT '#F9FAFB'::character varying,
    desktop_pattern_opacity character varying(10) DEFAULT '0.4'::character varying,
    interface_switch_bg character varying(100) DEFAULT 'linear-gradient(145deg, #3b82f6, #2563eb)'::character varying,
    interface_switch_hover_bg character varying(100) DEFAULT 'linear-gradient(145deg, #2563eb, #1d4ed8)'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.edge_functions_cache (
    func_name text NOT NULL,
    func_size text,
    file_count integer DEFAULT 0,
    last_modified timestamp with time zone,
    has_index boolean DEFAULT false,
    func_code text DEFAULT ''::text,
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.employee_checklist_assignments (
    id bigint NOT NULL,
    employee_id text NOT NULL,
    assigned_to_user_id text,
    branch_id bigint,
    checklist_id text NOT NULL,
    frequency_type text NOT NULL,
    day_of_week text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    assigned_by text,
    updated_by text,
    CONSTRAINT employee_checklist_assignments_frequency_type_check CHECK ((frequency_type = ANY (ARRAY['daily'::text, 'weekly'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.employee_fine_payments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    warning_id uuid,
    payment_method character varying(50),
    payment_amount numeric(10,2) NOT NULL,
    payment_currency character varying(3) DEFAULT 'USD'::character varying,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    payment_reference character varying(100),
    payment_notes text,
    processed_by uuid,
    processed_by_username character varying(255),
    account_code character varying(50),
    transaction_id character varying(100),
    receipt_number character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.employee_official_holidays (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    employee_id text NOT NULL,
    official_holiday_id text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.erp_connections (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    server_ip text NOT NULL,
    server_name text,
    database_name text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    device_id text,
    erp_branch_id integer,
    tunnel_url text
);

--

CREATE TABLE IF NOT EXISTS public.erp_daily_sales (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    branch_id bigint NOT NULL,
    sale_date date NOT NULL,
    total_bills integer DEFAULT 0,
    gross_amount numeric(18,2) DEFAULT 0,
    tax_amount numeric(18,2) DEFAULT 0,
    discount_amount numeric(18,2) DEFAULT 0,
    total_returns integer DEFAULT 0,
    return_amount numeric(18,2) DEFAULT 0,
    return_tax numeric(18,2) DEFAULT 0,
    net_bills integer DEFAULT 0,
    net_amount numeric(18,2) DEFAULT 0,
    net_tax numeric(18,2) DEFAULT 0,
    last_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.erp_sync_logs (
    id integer NOT NULL,
    sync_type text DEFAULT 'auto'::text NOT NULL,
    branches_total integer DEFAULT 0,
    branches_success integer DEFAULT 0,
    branches_failed integer DEFAULT 0,
    products_fetched integer DEFAULT 0,
    products_inserted integer DEFAULT 0,
    products_updated integer DEFAULT 0,
    duration_ms integer DEFAULT 0,
    details jsonb,
    triggered_by text DEFAULT 'pg_cron'::text,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.erp_synced_products (
    id integer NOT NULL,
    barcode character varying(50) NOT NULL,
    auto_barcode character varying(50),
    parent_barcode character varying(50),
    product_name_en character varying(500),
    product_name_ar character varying(500),
    unit_name character varying(100),
    unit_qty numeric(18,6) DEFAULT 1,
    is_base_unit boolean DEFAULT false,
    synced_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    expiry_dates jsonb DEFAULT '[]'::jsonb,
    managed_by jsonb DEFAULT '[]'::jsonb,
    in_process jsonb DEFAULT '[]'::jsonb,
    expiry_hidden boolean DEFAULT false
);

--

CREATE TABLE IF NOT EXISTS public.expense_parent_categories (
    id bigint NOT NULL,
    name_en text NOT NULL,
    name_ar text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true
);

--

CREATE TABLE IF NOT EXISTS public.expense_requisitions (
    id bigint NOT NULL,
    requisition_number text NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    approver_id uuid,
    approver_name text,
    expense_category_id bigint,
    expense_category_name_en text,
    expense_category_name_ar text,
    requester_id text NOT NULL,
    requester_name text NOT NULL,
    requester_contact text NOT NULL,
    vat_applicable boolean DEFAULT false,
    amount numeric(15,2) NOT NULL,
    payment_category text NOT NULL,
    description text,
    status text DEFAULT 'pending'::text,
    image_url text,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    credit_period integer,
    bank_name text,
    iban text,
    used_amount numeric DEFAULT 0,
    remaining_balance numeric DEFAULT 0,
    requester_ref_id uuid,
    is_active boolean DEFAULT true NOT NULL,
    due_date date,
    internal_user_id uuid,
    request_type text DEFAULT 'external'::text,
    vendor_id integer,
    vendor_name text,
    CONSTRAINT expense_requisitions_request_type_check CHECK ((request_type = ANY (ARRAY['external'::text, 'internal'::text, 'vendor'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.expense_scheduler (
    id bigint NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    expense_category_id bigint,
    expense_category_name_en text,
    expense_category_name_ar text,
    requisition_id bigint,
    requisition_number text,
    co_user_id uuid,
    co_user_name text,
    bill_type text NOT NULL,
    bill_number text,
    bill_date date,
    payment_method text,
    due_date date,
    credit_period integer,
    amount numeric NOT NULL,
    bill_file_url text,
    description text,
    notes text,
    is_paid boolean DEFAULT false,
    paid_date timestamp with time zone,
    status text DEFAULT 'pending'::text,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    bank_name text,
    iban text,
    payment_reference character varying(255),
    schedule_type text DEFAULT 'single_bill'::text,
    recurring_type text,
    recurring_metadata jsonb,
    approver_id uuid,
    approver_name text,
    vendor_id integer,
    vendor_name text,
    CONSTRAINT check_approver_for_recurring CHECK (((schedule_type <> 'recurring'::text) OR ((schedule_type = 'recurring'::text) AND (approver_id IS NOT NULL) AND (approver_name IS NOT NULL)))),
    CONSTRAINT check_co_user_for_non_recurring CHECK (((schedule_type = 'recurring'::text) OR (schedule_type = 'expense_requisition'::text) OR (schedule_type = 'closed_requisition_bill'::text) OR ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text])) AND (co_user_id IS NOT NULL) AND (co_user_name IS NOT NULL)))),
    CONSTRAINT check_recurring_type_values CHECK ((((schedule_type <> 'recurring'::text) AND (recurring_type IS NULL)) OR ((schedule_type = 'recurring'::text) AND (recurring_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly_date'::text, 'monthly_day'::text, 'yearly'::text, 'half_yearly'::text, 'quarterly'::text, 'custom'::text]))))),
    CONSTRAINT check_schedule_type_values CHECK ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text, 'recurring'::text, 'expense_requisition'::text, 'closed_requisition_bill'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.expense_sub_categories (
    id bigint NOT NULL,
    parent_category_id bigint NOT NULL,
    name_en text NOT NULL,
    name_ar text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true
);

--

CREATE TABLE IF NOT EXISTS public.flyer_offer_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_id uuid NOT NULL,
    product_barcode text NOT NULL,
    cost numeric(10,2),
    sales_price numeric(10,2),
    offer_price numeric(10,2),
    profit_amount numeric(10,2),
    profit_percent numeric(10,2),
    profit_after_offer numeric(10,2),
    decrease_amount numeric(10,2),
    offer_qty integer DEFAULT 1 NOT NULL,
    limit_qty integer,
    free_qty integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    page_number integer DEFAULT 1,
    page_order integer DEFAULT 1,
    total_sales_price numeric DEFAULT 0,
    total_offer_price numeric DEFAULT 0,
    CONSTRAINT flyer_offer_products_free_qty_check CHECK ((free_qty >= 0)),
    CONSTRAINT flyer_offer_products_offer_qty_check CHECK ((offer_qty >= 0))
);

--

CREATE TABLE IF NOT EXISTS public.flyer_offers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id text DEFAULT (gen_random_uuid())::text NOT NULL,
    template_name text NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    offer_name text,
    offer_name_id text,
    CONSTRAINT flyer_offers_dates_check CHECK ((end_date >= start_date))
);

--

CREATE TABLE IF NOT EXISTS public.flyer_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    first_page_image_url text NOT NULL,
    sub_page_image_urls text[] DEFAULT '{}'::text[] NOT NULL,
    first_page_configuration jsonb DEFAULT '[]'::jsonb NOT NULL,
    sub_page_configurations jsonb DEFAULT '[]'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{"sub_page_width": 794, "sub_page_height": 1123, "first_page_width": 794, "first_page_height": 1123}'::jsonb,
    is_active boolean DEFAULT true,
    is_default boolean DEFAULT false,
    category character varying(100),
    tags text[] DEFAULT '{}'::text[],
    usage_count integer DEFAULT 0,
    last_used_at timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    CONSTRAINT flyer_templates_sub_page_images_match_configs CHECK (((array_length(sub_page_image_urls, 1) = jsonb_array_length(sub_page_configurations)) OR ((sub_page_image_urls = '{}'::text[]) AND (sub_page_configurations = '[]'::jsonb))))
);

--

CREATE TABLE IF NOT EXISTS public.frontend_builds (
    id integer NOT NULL,
    version text NOT NULL,
    file_name text NOT NULL,
    file_size bigint DEFAULT 0 NOT NULL,
    storage_path text NOT NULL,
    notes text,
    uploaded_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.hr_analysed_attendance_data (
    id bigint NOT NULL,
    employee_id text NOT NULL,
    shift_date date NOT NULL,
    status text DEFAULT 'Absent'::text NOT NULL,
    worked_minutes integer DEFAULT 0 NOT NULL,
    late_minutes integer DEFAULT 0 NOT NULL,
    under_minutes integer DEFAULT 0 NOT NULL,
    shift_start_time time without time zone,
    shift_end_time time without time zone,
    check_in_time time without time zone,
    check_out_time time without time zone,
    employee_name_en text,
    employee_name_ar text,
    branch_id text,
    nationality text,
    analyzed_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    overtime_minutes integer DEFAULT 0
);

--

CREATE TABLE IF NOT EXISTS public.hr_basic_salary (
    employee_id character varying(50) NOT NULL,
    basic_salary numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    payment_mode character varying(20) DEFAULT 'Bank'::character varying NOT NULL,
    other_allowance numeric(10,2),
    other_allowance_payment_mode character varying(20),
    accommodation_allowance numeric(10,2),
    accommodation_payment_mode character varying(20),
    travel_allowance numeric(10,2),
    travel_payment_mode character varying(20),
    gosi_deduction numeric(10,2),
    total_salary numeric(10,2),
    food_allowance numeric(10,2) DEFAULT 0,
    food_payment_mode text DEFAULT 'Bank'::text,
    CONSTRAINT hr_basic_salary_accommodation_payment_mode_check CHECK (((accommodation_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_food_payment_mode_check CHECK ((food_payment_mode = ANY (ARRAY['Bank'::text, 'Cash'::text]))),
    CONSTRAINT hr_basic_salary_other_allowance_payment_mode_check CHECK (((other_allowance_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_payment_mode_check CHECK (((payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_travel_payment_mode_check CHECK (((travel_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.hr_checklist_operations (
    id character varying(20) DEFAULT ('CLO'::text || nextval('public.hr_checklist_operations_id_seq'::regclass)) NOT NULL,
    user_id uuid NOT NULL,
    employee_id character varying(50),
    box_operation_id uuid,
    checklist_id character varying(20) NOT NULL,
    answers jsonb DEFAULT '[]'::jsonb NOT NULL,
    total_points integer DEFAULT 0 NOT NULL,
    branch_id bigint,
    operation_date date DEFAULT CURRENT_DATE NOT NULL,
    operation_time time without time zone DEFAULT CURRENT_TIME NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    box_number integer,
    max_points integer DEFAULT 0 NOT NULL,
    submission_type_en text,
    submission_type_ar text
);

--

CREATE TABLE IF NOT EXISTS public.hr_checklist_questions (
    id character varying(20) DEFAULT ('Q'::text || nextval('public.hr_checklist_questions_id_seq'::regclass)) NOT NULL,
    question_en text,
    question_ar text,
    answer_1_en text,
    answer_1_ar text,
    answer_1_points integer DEFAULT 0,
    answer_2_en text,
    answer_2_ar text,
    answer_2_points integer DEFAULT 0,
    answer_3_en text,
    answer_3_ar text,
    answer_3_points integer DEFAULT 0,
    answer_4_en text,
    answer_4_ar text,
    answer_4_points integer DEFAULT 0,
    answer_5_en text,
    answer_5_ar text,
    answer_5_points integer DEFAULT 0,
    answer_6_en text,
    answer_6_ar text,
    answer_6_points integer DEFAULT 0,
    has_remarks boolean DEFAULT false,
    has_other boolean DEFAULT false,
    other_points integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.hr_checklists (
    id character varying(20) DEFAULT ('CL'::text || nextval('public.hr_checklists_id_seq'::regclass)) NOT NULL,
    checklist_name_en text,
    checklist_name_ar text,
    question_ids jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.hr_departments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    department_name_en character varying(100) NOT NULL,
    department_name_ar character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.hr_employee_master (
    id text NOT NULL,
    user_id uuid NOT NULL,
    current_branch_id integer NOT NULL,
    current_position_id uuid,
    name_en character varying(255),
    name_ar character varying(255),
    employee_id_mapping jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    nationality_id character varying(10),
    id_expiry_date date,
    id_document_url character varying(500),
    health_card_expiry_date date,
    health_card_document_url character varying(500),
    driving_licence_expiry_date date,
    driving_licence_document_url character varying(500),
    id_number character varying(50),
    health_card_number character varying(50),
    driving_licence_number character varying(50),
    bank_name character varying(255),
    iban character varying(34),
    contract_expiry_date date,
    contract_document_url text,
    sponsorship_status boolean DEFAULT false,
    insurance_expiry_date date,
    insurance_company_id character varying(15),
    health_educational_renewal_date date,
    date_of_birth date,
    join_date date,
    work_permit_expiry_date date,
    probation_period_expiry_date date,
    employment_status text DEFAULT 'Resigned'::text,
    permitted_early_leave_hours numeric DEFAULT 0,
    employment_status_effective_date date,
    employment_status_reason text,
    whatsapp_number text,
    email text,
    privacy_policy_accepted boolean DEFAULT false NOT NULL,
    CONSTRAINT employment_status_values CHECK ((employment_status = ANY (ARRAY['Resigned'::text, 'Job (With Finger)'::text, 'Vacation'::text, 'Terminated'::text, 'Run Away'::text, 'Remote Job'::text, 'Job (No Finger)'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.hr_employees (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id character varying(20) NOT NULL,
    branch_id bigint NOT NULL,
    hire_date date,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    name character varying(200) NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.hr_fingerprint_transactions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id character varying(20) NOT NULL,
    name character varying(200),
    branch_id bigint NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    status character varying(20) NOT NULL,
    device_id character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    location text,
    processed boolean DEFAULT false,
    CONSTRAINT chk_hr_fingerprint_punch CHECK (((status)::text = ANY (ARRAY[('Check In'::character varying)::text, ('Check Out'::character varying)::text, ('Break In'::character varying)::text, ('Break Out'::character varying)::text, ('Overtime In'::character varying)::text, ('Overtime Out'::character varying)::text])))
);

--

CREATE TABLE IF NOT EXISTS public.hr_insurance_companies (
    id character varying(15) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.hr_levels (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    level_name_en character varying(100) NOT NULL,
    level_name_ar character varying(100) NOT NULL,
    level_order integer NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.hr_position_assignments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id uuid NOT NULL,
    position_id uuid NOT NULL,
    department_id uuid NOT NULL,
    level_id uuid NOT NULL,
    branch_id bigint NOT NULL,
    effective_date date DEFAULT CURRENT_DATE NOT NULL,
    is_current boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.hr_position_reporting_template (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    subordinate_position_id uuid NOT NULL,
    manager_position_1 uuid,
    manager_position_2 uuid,
    manager_position_3 uuid,
    manager_position_4 uuid,
    manager_position_5 uuid,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_no_self_report_1 CHECK ((subordinate_position_id <> manager_position_1)),
    CONSTRAINT chk_no_self_report_2 CHECK ((subordinate_position_id <> manager_position_2)),
    CONSTRAINT chk_no_self_report_3 CHECK ((subordinate_position_id <> manager_position_3)),
    CONSTRAINT chk_no_self_report_4 CHECK ((subordinate_position_id <> manager_position_4)),
    CONSTRAINT chk_no_self_report_5 CHECK ((subordinate_position_id <> manager_position_5))
);

--

CREATE TABLE IF NOT EXISTS public.hr_positions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    position_title_en character varying(100) NOT NULL,
    position_title_ar character varying(100) NOT NULL,
    department_id uuid NOT NULL,
    level_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.incident_actions (
    id text DEFAULT ('ACT'::text || nextval('public.incident_actions_id_seq'::regclass)) NOT NULL,
    action_type text NOT NULL,
    recourse_type text,
    action_report jsonb,
    has_fine boolean DEFAULT false,
    fine_amount numeric(10,2) DEFAULT 0,
    fine_threat_amount numeric(10,2) DEFAULT 0,
    is_paid boolean DEFAULT false,
    paid_at timestamp with time zone,
    paid_by text,
    employee_id text NOT NULL,
    incident_id text NOT NULL,
    incident_type_id text,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT incident_actions_action_type_check CHECK ((action_type = ANY (ARRAY['warning'::text, 'investigation'::text, 'termination'::text, 'other'::text]))),
    CONSTRAINT incident_actions_recourse_type_check CHECK ((recourse_type = ANY (ARRAY['warning'::text, 'warning_fine'::text, 'warning_fine_threat'::text, 'warning_fine_termination_threat'::text, 'termination'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.incident_types (
    id text NOT NULL,
    incident_type_en text NOT NULL,
    incident_type_ar text NOT NULL,
    description_en text,
    description_ar text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.incidents (
    id text NOT NULL,
    incident_type_id text NOT NULL,
    employee_id text,
    branch_id bigint NOT NULL,
    violation_id text,
    what_happened jsonb NOT NULL,
    witness_details jsonb,
    report_type text DEFAULT 'employee_related'::text NOT NULL,
    reports_to_user_ids uuid[] DEFAULT ARRAY[]::uuid[] NOT NULL,
    claims_status text,
    claimed_user_id uuid,
    resolution_status public.resolution_status DEFAULT 'reported'::public.resolution_status NOT NULL,
    user_statuses jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    attachments jsonb DEFAULT '[]'::jsonb,
    investigation_report jsonb,
    related_party jsonb,
    resolution_report jsonb
);

--

CREATE TABLE IF NOT EXISTS public.interface_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    desktop_enabled boolean DEFAULT true NOT NULL,
    mobile_enabled boolean DEFAULT true NOT NULL,
    customer_enabled boolean DEFAULT false NOT NULL,
    updated_by uuid NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    cashier_enabled boolean DEFAULT false
);

--

CREATE TABLE IF NOT EXISTS public.lease_rent_lease_parties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    property_space_id uuid,
    party_name_en character varying(255) NOT NULL,
    party_name_ar character varying(255) NOT NULL,
    shop_name character varying(255),
    contract_start_date date,
    contract_end_date date,
    lease_amount_contract numeric(12,2) DEFAULT 0,
    lease_amount_outside_contract numeric(12,2) DEFAULT 0,
    utility_charges numeric(12,2) DEFAULT 0,
    security_charges numeric(12,2) DEFAULT 0,
    other_charges jsonb DEFAULT '[]'::jsonb,
    payment_mode character varying(20) DEFAULT 'cash'::character varying,
    collection_incharge_id text,
    payment_period character varying(30) DEFAULT 'monthly'::character varying,
    payment_specific_date integer,
    payment_end_of_month boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_open_contract boolean DEFAULT false,
    contact_number character varying(50),
    email character varying(255)
);

--

CREATE TABLE IF NOT EXISTS public.lease_rent_payment_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    period_num integer NOT NULL,
    column_name character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    paid_date date DEFAULT CURRENT_DATE NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.lease_rent_payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    period_num integer NOT NULL,
    period_from date NOT NULL,
    period_to date NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    paid_amount numeric(12,2) DEFAULT 0 NOT NULL,
    is_fully_paid boolean DEFAULT false NOT NULL,
    paid_at timestamp with time zone DEFAULT now(),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    paid_contract numeric(12,2) DEFAULT 0,
    paid_outside numeric(12,2) DEFAULT 0,
    paid_utility numeric(12,2) DEFAULT 0,
    paid_security numeric(12,2) DEFAULT 0,
    paid_other numeric(12,2) DEFAULT 0,
    paid_date date,
    CONSTRAINT lease_rent_payments_party_type_check CHECK (((party_type)::text = ANY ((ARRAY['rent'::character varying, 'lease'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.lease_rent_properties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    location_en character varying(500),
    location_ar character varying(500),
    is_leased boolean DEFAULT false,
    is_rented boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.lease_rent_property_spaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    space_number character varying(100) NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.lease_rent_rent_parties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    property_space_id uuid,
    party_name_en character varying(255) NOT NULL,
    party_name_ar character varying(255) NOT NULL,
    shop_name character varying(255),
    contract_start_date date,
    contract_end_date date,
    rent_amount_contract numeric(12,2) DEFAULT 0,
    rent_amount_outside_contract numeric(12,2) DEFAULT 0,
    utility_charges numeric(12,2) DEFAULT 0,
    security_charges numeric(12,2) DEFAULT 0,
    other_charges jsonb DEFAULT '[]'::jsonb,
    payment_mode character varying(20) DEFAULT 'cash'::character varying,
    collection_incharge_id text,
    payment_period character varying(30) DEFAULT 'monthly'::character varying,
    payment_specific_date integer,
    payment_end_of_month boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_open_contract boolean DEFAULT false,
    contact_number character varying(50),
    email character varying(255)
);

--

CREATE TABLE IF NOT EXISTS public.lease_rent_special_changes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    field_name character varying(50) NOT NULL,
    old_value numeric(12,2) DEFAULT 0,
    new_value numeric(12,2) NOT NULL,
    effective_from date NOT NULL,
    effective_until date,
    till_end_of_contract boolean DEFAULT false,
    payment_period character varying(20) DEFAULT 'monthly'::character varying,
    reason text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    CONSTRAINT lease_rent_special_changes_party_type_check CHECK (((party_type)::text = ANY ((ARRAY['rent'::character varying, 'lease'::character varying])::text[])))
);

--

CREATE TABLE IF NOT EXISTS public.mobile_themes (
    id bigint NOT NULL,
    name text NOT NULL,
    description text,
    is_default boolean DEFAULT false,
    colors jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.multi_shift_date_wise (
    id integer NOT NULL,
    employee_id text NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT multi_shift_date_wise_date_check CHECK ((date_from <= date_to))
);

--

CREATE TABLE IF NOT EXISTS public.multi_shift_regular (
    id integer NOT NULL,
    employee_id text NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.multi_shift_weekday (
    id integer NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT multi_shift_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);

--

CREATE TABLE IF NOT EXISTS public.nationalities (
    id character varying(10) NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.near_expiry_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    reporter_user_id uuid NOT NULL,
    branch_id integer,
    target_user_id uuid,
    status text DEFAULT 'pending'::text NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    title text,
    CONSTRAINT near_expiry_reports_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'reviewed'::text, 'resolved'::text, 'dismissed'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.non_approved_payment_scheduler (
    id bigint NOT NULL,
    schedule_type text NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    expense_category_id bigint NOT NULL,
    expense_category_name_en text,
    expense_category_name_ar text,
    co_user_id uuid,
    co_user_name text,
    bill_type text,
    bill_number text,
    bill_date date,
    payment_method text,
    due_date date,
    credit_period integer,
    amount numeric NOT NULL,
    bill_file_url text,
    bank_name text,
    iban text,
    description text,
    notes text,
    recurring_type text,
    recurring_metadata jsonb,
    approver_id uuid NOT NULL,
    approver_name text NOT NULL,
    approval_status text DEFAULT 'pending'::text,
    approved_at timestamp with time zone,
    approved_by uuid,
    rejection_reason text,
    expense_scheduler_id bigint,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT check_non_approved_approval_status CHECK ((approval_status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))),
    CONSTRAINT check_non_approved_co_user_for_non_recurring CHECK (((schedule_type = 'recurring'::text) OR ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text])) AND (co_user_id IS NOT NULL) AND (co_user_name IS NOT NULL)))),
    CONSTRAINT check_non_approved_recurring_type CHECK (((recurring_type IS NULL) OR (recurring_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly_date'::text, 'monthly_day'::text, 'yearly'::text, 'half_yearly'::text, 'quarterly'::text, 'custom'::text])))),
    CONSTRAINT check_non_approved_schedule_type CHECK ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text, 'recurring'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.notification_attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path text NOT NULL,
    file_size bigint NOT NULL,
    file_type character varying(100) NOT NULL,
    uploaded_by character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.notification_read_states (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    user_id text NOT NULL,
    read_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    is_read boolean DEFAULT false NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.notification_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    role character varying(100),
    branch_id character varying(255),
    is_read boolean DEFAULT false NOT NULL,
    read_at timestamp with time zone,
    is_dismissed boolean DEFAULT false NOT NULL,
    dismissed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    delivery_status character varying(20) DEFAULT 'pending'::character varying,
    delivery_attempted_at timestamp with time zone,
    error_message text,
    user_id uuid
);

--

CREATE TABLE IF NOT EXISTS public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    created_by character varying(255) DEFAULT 'system'::character varying NOT NULL,
    created_by_name character varying(100) DEFAULT 'System'::character varying NOT NULL,
    created_by_role character varying(50) DEFAULT 'Admin'::character varying NOT NULL,
    target_users jsonb,
    target_roles jsonb,
    target_branches jsonb,
    scheduled_for timestamp with time zone,
    sent_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone,
    has_attachments boolean DEFAULT false NOT NULL,
    read_count integer DEFAULT 0 NOT NULL,
    total_recipients integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    task_id uuid,
    task_assignment_id uuid,
    priority character varying(20) DEFAULT 'medium'::character varying NOT NULL,
    status character varying(20) DEFAULT 'published'::character varying NOT NULL,
    target_type character varying(50) DEFAULT 'all_users'::character varying NOT NULL,
    type character varying(50) DEFAULT 'info'::character varying NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.offer_bundles (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    bundle_name_ar character varying(255) NOT NULL,
    bundle_name_en character varying(255) NOT NULL,
    required_products jsonb NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    discount_type character varying(20) DEFAULT 'amount'::character varying,
    CONSTRAINT offer_bundles_discount_amount_check CHECK ((discount_value > (0)::numeric)),
    CONSTRAINT offer_bundles_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('percentage'::character varying)::text, ('amount'::character varying)::text]))),
    CONSTRAINT offer_bundles_discount_value_check CHECK ((discount_value > (0)::numeric))
);

--

CREATE TABLE IF NOT EXISTS public.offer_cart_tiers (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    tier_number integer NOT NULL,
    min_amount numeric(10,2) NOT NULL,
    max_amount numeric(10,2),
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT offer_cart_tiers_check CHECK (((max_amount IS NULL) OR (max_amount > min_amount))),
    CONSTRAINT offer_cart_tiers_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('percentage'::character varying)::text, ('fixed'::character varying)::text]))),
    CONSTRAINT offer_cart_tiers_discount_value_check CHECK ((discount_value >= (0)::numeric)),
    CONSTRAINT offer_cart_tiers_min_amount_check CHECK ((min_amount >= (0)::numeric)),
    CONSTRAINT offer_cart_tiers_tier_number_check CHECK (((tier_number >= 1) AND (tier_number <= 6)))
);

--

CREATE TABLE IF NOT EXISTS public.offer_names (
    id text NOT NULL,
    name_en text NOT NULL,
    name_ar text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.offer_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_id integer NOT NULL,
    product_id character varying(50) NOT NULL,
    offer_qty integer DEFAULT 1 NOT NULL,
    offer_percentage numeric(5,2),
    offer_price numeric(10,2),
    max_uses integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_part_of_variation_group boolean DEFAULT false NOT NULL,
    variation_group_id uuid,
    variation_parent_barcode text,
    added_by uuid,
    added_at timestamp with time zone DEFAULT now(),
    CONSTRAINT at_least_one_discount CHECK (((offer_percentage IS NOT NULL) OR (offer_price IS NOT NULL))),
    CONSTRAINT valid_offer_price CHECK (((offer_price IS NULL) OR (offer_price >= (0)::numeric))),
    CONSTRAINT valid_offer_qty CHECK ((offer_qty > 0)),
    CONSTRAINT valid_percentage CHECK (((offer_percentage IS NULL) OR ((offer_percentage >= (0)::numeric) AND (offer_percentage <= (100)::numeric))))
);

--

CREATE TABLE IF NOT EXISTS public.offer_usage_logs (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    customer_id uuid,
    order_id uuid,
    discount_applied numeric(10,2) NOT NULL,
    original_amount numeric(10,2) NOT NULL,
    final_amount numeric(10,2) NOT NULL,
    cart_items jsonb,
    used_at timestamp with time zone DEFAULT now(),
    session_id character varying(255) DEFAULT NULL::character varying,
    device_type character varying(50) DEFAULT NULL::character varying
);

--

CREATE TABLE IF NOT EXISTS public.offers (
    id integer NOT NULL,
    type character varying(20) NOT NULL,
    name_ar character varying(255) NOT NULL,
    name_en character varying(255) NOT NULL,
    description_ar text,
    description_en text,
    start_date timestamp with time zone DEFAULT now() NOT NULL,
    end_date timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true,
    max_uses_per_customer integer,
    max_total_uses integer,
    current_total_uses integer DEFAULT 0,
    branch_id integer,
    service_type character varying(20) DEFAULT 'both'::character varying,
    show_on_product_page boolean DEFAULT true,
    show_in_carousel boolean DEFAULT false,
    send_push_notification boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT offers_service_type_check CHECK (((service_type)::text = ANY (ARRAY[('delivery'::character varying)::text, ('pickup'::character varying)::text, ('both'::character varying)::text]))),
    CONSTRAINT offers_type_check CHECK (((type)::text = ANY (ARRAY[('bundle'::character varying)::text, ('cart'::character varying)::text, ('product'::character varying)::text, ('bogo'::character varying)::text]))),
    CONSTRAINT valid_date_range CHECK ((end_date > start_date))
);

--

CREATE TABLE IF NOT EXISTS public.official_holidays (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    holiday_date date NOT NULL,
    name_en text DEFAULT ''::text NOT NULL,
    name_ar text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.order_audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    action_type character varying(50) NOT NULL,
    from_status character varying(50),
    to_status character varying(50),
    performed_by uuid,
    performed_by_name character varying(255),
    performed_by_role character varying(50),
    assigned_user_id uuid,
    assigned_user_name character varying(255),
    assignment_type character varying(50),
    field_name character varying(100),
    old_value text,
    new_value text,
    notes text,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id character varying(50) NOT NULL,
    product_name_ar character varying(255) NOT NULL,
    product_name_en character varying(255) NOT NULL,
    product_sku character varying(100),
    unit_id character varying(50),
    unit_name_ar character varying(100),
    unit_name_en character varying(100),
    unit_size character varying(50),
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    original_price numeric(10,2) NOT NULL,
    discount_amount numeric(10,2) DEFAULT 0 NOT NULL,
    final_price numeric(10,2) NOT NULL,
    line_total numeric(10,2) NOT NULL,
    has_offer boolean DEFAULT false NOT NULL,
    offer_id integer,
    offer_name_ar character varying(255),
    offer_name_en character varying(255),
    offer_type character varying(50),
    offer_discount_percentage numeric(5,2),
    offer_special_price numeric(10,2),
    item_type character varying(20) DEFAULT 'regular'::character varying NOT NULL,
    bundle_id uuid,
    bundle_name_ar character varying(255),
    bundle_name_en character varying(255),
    is_bundle_item boolean DEFAULT false NOT NULL,
    is_bogo_free boolean DEFAULT false NOT NULL,
    bogo_group_id uuid,
    tax_rate numeric(5,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0 NOT NULL,
    item_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_number character varying(50) NOT NULL,
    customer_id uuid NOT NULL,
    customer_name character varying(255) NOT NULL,
    customer_phone character varying(20) NOT NULL,
    customer_whatsapp character varying(20),
    branch_id bigint NOT NULL,
    selected_location jsonb,
    order_status character varying(50) DEFAULT 'new'::character varying NOT NULL,
    fulfillment_method character varying(20) DEFAULT 'delivery'::character varying NOT NULL,
    subtotal_amount numeric(10,2) DEFAULT 0 NOT NULL,
    delivery_fee numeric(10,2) DEFAULT 0 NOT NULL,
    discount_amount numeric(10,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0 NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    payment_method character varying(20) NOT NULL,
    payment_status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    payment_reference character varying(100),
    total_items integer DEFAULT 0 NOT NULL,
    total_quantity integer DEFAULT 0 NOT NULL,
    picker_id uuid,
    picker_assigned_at timestamp with time zone,
    delivery_person_id uuid,
    delivery_assigned_at timestamp with time zone,
    accepted_at timestamp with time zone,
    ready_at timestamp with time zone,
    delivered_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    cancelled_by uuid,
    cancellation_reason text,
    customer_notes text,
    admin_notes text,
    estimated_pickup_time timestamp with time zone,
    estimated_delivery_time timestamp with time zone,
    actual_pickup_time timestamp with time zone,
    actual_delivery_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    picked_up_at timestamp with time zone
);

--

CREATE TABLE IF NOT EXISTS public.overtime_registrations (
    id text NOT NULL,
    employee_id text NOT NULL,
    overtime_date date NOT NULL,
    overtime_minutes integer DEFAULT 0 NOT NULL,
    worked_minutes integer DEFAULT 0,
    notes text,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.pos_deduction_transfers (
    id text NOT NULL,
    box_number integer NOT NULL,
    branch_id integer NOT NULL,
    cashier_user_id text NOT NULL,
    closed_by uuid,
    short_amount numeric(10,2) DEFAULT 0 NOT NULL,
    status public.pos_deduction_status DEFAULT 'Proposed'::public.pos_deduction_status NOT NULL,
    date_created_box timestamp with time zone NOT NULL,
    date_closed_box timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    completed_by_name character varying(255),
    box_operation_id uuid NOT NULL,
    applied boolean DEFAULT false
);

--

CREATE TABLE IF NOT EXISTS public.privilege_cards_branch (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    privilege_card_id integer NOT NULL,
    card_number character varying(50) NOT NULL,
    branch_id integer NOT NULL,
    card_balance numeric(10,4) DEFAULT 0,
    card_holder_name character varying(255),
    total_redemptions numeric(10,4) DEFAULT 0,
    redemption_count integer DEFAULT 0,
    expiry_date date,
    mobile character varying(20),
    last_sync_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.privilege_cards_master (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    card_number character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.processed_fingerprint_transactions (
    id text NOT NULL,
    center_id text NOT NULL,
    employee_id text NOT NULL,
    branch_id text NOT NULL,
    punch_date date NOT NULL,
    punch_time time without time zone NOT NULL,
    status text,
    processed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.product_categories (
    id character varying(10) NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    image_url text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.product_request_bt (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    from_branch_id integer NOT NULL,
    to_branch_id integer NOT NULL,
    target_user_id uuid NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    document_url text
);

--

CREATE TABLE IF NOT EXISTS public.product_request_po (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    from_branch_id integer NOT NULL,
    target_user_id uuid NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    document_url text
);

--

CREATE TABLE IF NOT EXISTS public.product_request_st (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    branch_id integer NOT NULL,
    target_user_id uuid NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    document_url text
);

--

CREATE TABLE IF NOT EXISTS public.product_units (
    id character varying(10) NOT NULL,
    name_en character varying(50) NOT NULL,
    name_ar character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.products (
    id character varying(10) NOT NULL,
    barcode text NOT NULL,
    product_name_en text,
    product_name_ar text,
    image_url text,
    category_id character varying(10),
    unit_id character varying(10),
    unit_qty numeric DEFAULT 1 NOT NULL,
    sale_price numeric DEFAULT 0 NOT NULL,
    cost numeric DEFAULT 0 NOT NULL,
    profit numeric DEFAULT 0 NOT NULL,
    profit_percentage numeric DEFAULT 0 NOT NULL,
    current_stock integer DEFAULT 0 NOT NULL,
    minim_qty integer DEFAULT 0 NOT NULL,
    minimum_qty_alert integer DEFAULT 0 NOT NULL,
    maximum_qty integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    is_customer_product boolean DEFAULT true,
    is_variation boolean DEFAULT false NOT NULL,
    parent_product_barcode text,
    variation_group_name_en text,
    variation_group_name_ar text,
    variation_order integer DEFAULT 0,
    variation_image_override text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    modified_by uuid,
    modified_at timestamp with time zone
);

--

CREATE TABLE IF NOT EXISTS public.purchase_voucher_issue_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type_name character varying NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.purchase_voucher_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_voucher_id character varying NOT NULL,
    serial_number integer NOT NULL,
    value numeric NOT NULL,
    status character varying DEFAULT 'stocked'::character varying,
    issued_date timestamp with time zone,
    closed_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    stock integer DEFAULT 1,
    issue_type character varying DEFAULT 'not issued'::character varying,
    stock_location bigint,
    stock_person uuid,
    issued_to uuid,
    issued_by uuid,
    receipt_url text,
    issue_remarks text,
    close_remarks text,
    close_bill_number character varying,
    approval_status character varying,
    approver_id uuid,
    pending_stock_location bigint,
    pending_stock_person uuid
);

--

CREATE TABLE IF NOT EXISTS public.purchase_vouchers (
    id character varying NOT NULL,
    book_number character varying NOT NULL,
    serial_start integer NOT NULL,
    serial_end integer NOT NULL,
    voucher_count integer NOT NULL,
    per_voucher_value numeric NOT NULL,
    total_value numeric NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.push_subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    subscription jsonb NOT NULL,
    endpoint text NOT NULL,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    failed_deliveries integer DEFAULT 0,
    is_active boolean DEFAULT true,
    customer_id uuid,
    CONSTRAINT chk_push_sub_user_or_customer CHECK (((user_id IS NOT NULL) OR (customer_id IS NOT NULL)))
);

--

CREATE TABLE IF NOT EXISTS public.quick_task_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    assigned_to_user_id uuid NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    accepted_at timestamp with time zone,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT true,
    require_erp_reference boolean DEFAULT false,
    CONSTRAINT chk_require_task_finished_not_null CHECK ((require_task_finished IS NOT NULL))
);

--

CREATE TABLE IF NOT EXISTS public.quick_task_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    comment text NOT NULL,
    comment_type character varying(50) DEFAULT 'comment'::character varying,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.quick_task_completions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    completed_by_user_id uuid NOT NULL,
    completion_notes text,
    photo_path text,
    erp_reference character varying(255),
    completion_status character varying(50) DEFAULT 'submitted'::character varying NOT NULL,
    verified_by_user_id uuid,
    verified_at timestamp with time zone,
    verification_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_completion_status_valid CHECK (((completion_status)::text = ANY (ARRAY[('submitted'::character varying)::text, ('verified'::character varying)::text, ('rejected'::character varying)::text, ('pending_review'::character varying)::text]))),
    CONSTRAINT chk_verified_at_when_verified CHECK (((((completion_status)::text <> 'verified'::text) AND (verified_at IS NULL)) OR (((completion_status)::text = 'verified'::text) AND (verified_at IS NOT NULL))))
);

--

CREATE TABLE IF NOT EXISTS public.quick_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    price_tag character varying(50),
    issue_type character varying(100) NOT NULL,
    priority character varying(50) NOT NULL,
    assigned_by uuid NOT NULL,
    assigned_to_branch_id bigint,
    created_at timestamp with time zone DEFAULT now(),
    deadline_datetime timestamp with time zone DEFAULT (now() + '24:00:00'::interval),
    completed_at timestamp with time zone,
    status character varying(50) DEFAULT 'pending'::character varying,
    created_from character varying(50) DEFAULT 'quick_task'::character varying,
    updated_at timestamp with time zone DEFAULT now(),
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    incident_id text,
    product_request_id uuid,
    product_request_type character varying(5),
    order_id uuid,
    CONSTRAINT chk_require_task_finished_not_null CHECK ((require_task_finished IS NOT NULL))
);

--

CREATE TABLE IF NOT EXISTS public.users (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    salt character varying(100) NOT NULL,
    quick_access_code character varying(255) NOT NULL,
    quick_access_salt character varying(100) NOT NULL,
    user_type public.user_type_enum DEFAULT 'branch_specific'::public.user_type_enum NOT NULL,
    employee_id uuid,
    branch_id bigint,
    position_id uuid,
    avatar text,
    avatar_small_url text,
    avatar_medium_url text,
    avatar_large_url text,
    is_first_login boolean DEFAULT true,
    failed_login_attempts integer DEFAULT 0,
    locked_at timestamp with time zone,
    locked_by uuid,
    last_login_at timestamp with time zone,
    password_expires_at timestamp with time zone,
    last_password_change timestamp with time zone DEFAULT now(),
    created_by bigint,
    updated_by bigint,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    ai_translation_enabled boolean DEFAULT false NOT NULL,
    is_master_admin boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    CONSTRAINT users_employee_branch_check CHECK (((user_type = 'global'::public.user_type_enum) OR ((user_type = 'branch_specific'::public.user_type_enum) AND (branch_id IS NOT NULL))))
);

--

CREATE TABLE IF NOT EXISTS public.quick_task_files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_type character varying(100),
    file_size integer,
    mime_type character varying(100),
    storage_path text NOT NULL,
    storage_bucket character varying(100) DEFAULT 'quick-task-files'::character varying,
    uploaded_by uuid,
    uploaded_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.quick_task_user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id bigint,
    default_price_tag character varying(50),
    default_issue_type character varying(100),
    default_priority character varying(50),
    selected_user_ids uuid[],
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.receiving_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    branch_id integer NOT NULL,
    vendor_id integer NOT NULL,
    bill_date date NOT NULL,
    bill_amount numeric(15,2) NOT NULL,
    bill_number character varying(100),
    payment_method character varying(100),
    credit_period integer,
    due_date date,
    bank_name character varying(200),
    iban character varying(50),
    vendor_vat_number character varying(50),
    bill_vat_number character varying(50),
    vat_numbers_match boolean,
    vat_mismatch_reason text,
    branch_manager_user_id uuid,
    shelf_stocker_user_ids uuid[] DEFAULT '{}'::uuid[],
    accountant_user_id uuid,
    purchasing_manager_user_id uuid,
    expired_return_amount numeric(12,2) DEFAULT 0,
    near_expiry_return_amount numeric(12,2) DEFAULT 0,
    over_stock_return_amount numeric(12,2) DEFAULT 0,
    damage_return_amount numeric(12,2) DEFAULT 0,
    total_return_amount numeric(12,2) DEFAULT 0,
    final_bill_amount numeric(12,2) DEFAULT 0,
    expired_erp_document_type character varying(10),
    expired_erp_document_number character varying(100),
    expired_vendor_document_number character varying(100),
    near_expiry_erp_document_type character varying(10),
    near_expiry_erp_document_number character varying(100),
    near_expiry_vendor_document_number character varying(100),
    over_stock_erp_document_type character varying(10),
    over_stock_erp_document_number character varying(100),
    over_stock_vendor_document_number character varying(100),
    damage_erp_document_type character varying(10),
    damage_erp_document_number character varying(100),
    damage_vendor_document_number character varying(100),
    has_expired_returns boolean DEFAULT false,
    has_near_expiry_returns boolean DEFAULT false,
    has_over_stock_returns boolean DEFAULT false,
    has_damage_returns boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    inventory_manager_user_id uuid,
    night_supervisor_user_ids uuid[] DEFAULT '{}'::uuid[],
    warehouse_handler_user_ids uuid[] DEFAULT '{}'::uuid[],
    certificate_url text,
    certificate_generated_at timestamp with time zone,
    certificate_file_name text,
    original_bill_url text,
    erp_purchase_invoice_reference character varying(255),
    updated_at timestamp with time zone DEFAULT now(),
    pr_excel_file_url text,
    erp_purchase_invoice_uploaded boolean DEFAULT false,
    pr_excel_file_uploaded boolean DEFAULT false,
    original_bill_uploaded boolean DEFAULT false,
    CONSTRAINT check_credit_period_positive CHECK (((credit_period IS NULL) OR (credit_period >= 0))),
    CONSTRAINT check_damage_return_amount CHECK ((damage_return_amount >= (0)::numeric)),
    CONSTRAINT check_due_date_after_bill_date CHECK (((due_date IS NULL) OR (bill_date IS NULL) OR (due_date >= bill_date))),
    CONSTRAINT check_expired_return_amount CHECK ((expired_return_amount >= (0)::numeric)),
    CONSTRAINT check_final_bill_amount CHECK ((final_bill_amount >= (0)::numeric)),
    CONSTRAINT check_near_expiry_return_amount CHECK ((near_expiry_return_amount >= (0)::numeric)),
    CONSTRAINT check_over_stock_return_amount CHECK ((over_stock_return_amount >= (0)::numeric)),
    CONSTRAINT check_return_not_exceed_bill CHECK ((total_return_amount <= bill_amount)),
    CONSTRAINT check_total_return_amount CHECK ((total_return_amount >= (0)::numeric)),
    CONSTRAINT check_vat_mismatch_reason CHECK (((vat_numbers_match IS NULL) OR (vat_numbers_match = true) OR ((vat_numbers_match = false) AND (vat_mismatch_reason IS NOT NULL) AND (length(TRIM(BOTH FROM vat_mismatch_reason)) > 0))))
);

--

CREATE TABLE IF NOT EXISTS public.vendors (
    erp_vendor_id integer NOT NULL,
    vendor_name text NOT NULL,
    salesman_name text,
    salesman_contact text,
    supervisor_name text,
    supervisor_contact text,
    vendor_contact_number text,
    payment_method text,
    credit_period integer,
    bank_name text,
    iban text,
    status text DEFAULT 'Active'::text,
    last_visit timestamp without time zone,
    categories text[],
    delivery_modes text[],
    place text,
    location_link text,
    return_expired_products text,
    return_expired_products_note text,
    return_near_expiry_products text,
    return_near_expiry_products_note text,
    return_over_stock text,
    return_over_stock_note text,
    return_damage_products text,
    return_damage_products_note text,
    no_return boolean DEFAULT false,
    no_return_note text,
    vat_applicable text DEFAULT 'VAT Applicable'::text,
    vat_number text,
    no_vat_note text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    branch_id bigint NOT NULL,
    payment_priority text DEFAULT 'Normal'::text,
    CONSTRAINT vendors_payment_priority_check CHECK ((payment_priority = ANY (ARRAY['Most'::text, 'Medium'::text, 'Normal'::text, 'Low'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.receiving_task_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_type character varying(50) NOT NULL,
    title_template text NOT NULL,
    description_template text NOT NULL,
    require_erp_reference boolean DEFAULT false NOT NULL,
    require_original_bill_upload boolean DEFAULT false NOT NULL,
    require_task_finished_mark boolean DEFAULT true NOT NULL,
    priority character varying(20) DEFAULT 'high'::character varying NOT NULL,
    deadline_hours integer DEFAULT 24 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    depends_on_role_types text[] DEFAULT '{}'::text[],
    require_photo_upload boolean DEFAULT false,
    CONSTRAINT receiving_task_templates_deadline_hours_check CHECK (((deadline_hours > 0) AND (deadline_hours <= 168))),
    CONSTRAINT receiving_task_templates_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('medium'::character varying)::text, ('high'::character varying)::text, ('urgent'::character varying)::text]))),
    CONSTRAINT receiving_task_templates_role_type_check CHECK (((role_type)::text = ANY (ARRAY[('branch_manager'::character varying)::text, ('purchase_manager'::character varying)::text, ('inventory_manager'::character varying)::text, ('night_supervisor'::character varying)::text, ('warehouse_handler'::character varying)::text, ('shelf_stocker'::character varying)::text, ('accountant'::character varying)::text])))
);

--

CREATE TABLE IF NOT EXISTS public.receiving_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    receiving_record_id uuid NOT NULL,
    role_type character varying(50) NOT NULL,
    assigned_user_id uuid,
    requires_erp_reference boolean DEFAULT false,
    requires_original_bill_upload boolean DEFAULT false,
    requires_reassignment boolean DEFAULT false,
    requires_task_finished_mark boolean DEFAULT true,
    erp_reference_number character varying(255),
    original_bill_uploaded boolean DEFAULT false,
    original_bill_file_path text,
    task_completed boolean DEFAULT false,
    completed_at timestamp with time zone,
    clearance_certificate_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    template_id uuid,
    task_status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    title text,
    description text,
    priority character varying(20) DEFAULT 'high'::character varying,
    due_date timestamp with time zone,
    completed_by_user_id uuid,
    completion_photo_url text,
    completion_notes text,
    rule_effective_date timestamp with time zone,
    CONSTRAINT receiving_tasks_role_type_check CHECK (((role_type)::text = ANY (ARRAY[('branch_manager'::character varying)::text, ('purchase_manager'::character varying)::text, ('inventory_manager'::character varying)::text, ('night_supervisor'::character varying)::text, ('warehouse_handler'::character varying)::text, ('shelf_stocker'::character varying)::text, ('accountant'::character varying)::text]))),
    CONSTRAINT receiving_tasks_task_status_check CHECK (((task_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('in_progress'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text])))
);

--

CREATE TABLE IF NOT EXISTS public.receiving_user_defaults (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.recurring_assignment_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    repeat_type text NOT NULL,
    repeat_interval integer DEFAULT 1 NOT NULL,
    repeat_on_days integer[],
    repeat_on_date integer,
    repeat_on_month integer,
    execute_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    timezone text DEFAULT 'UTC'::text,
    start_date date NOT NULL,
    end_date date,
    max_occurrences integer,
    is_active boolean DEFAULT true,
    last_executed_at timestamp with time zone,
    next_execution_at timestamp with time zone NOT NULL,
    executions_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by text NOT NULL,
    CONSTRAINT chk_max_occurrences_positive CHECK (((max_occurrences IS NULL) OR (max_occurrences > 0))),
    CONSTRAINT chk_next_execution_after_start CHECK (((next_execution_at)::date >= start_date)),
    CONSTRAINT chk_repeat_interval_positive CHECK ((repeat_interval > 0)),
    CONSTRAINT chk_schedule_bounds CHECK (((end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT recurring_assignment_schedules_repeat_type_check CHECK ((repeat_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly'::text, 'yearly'::text, 'custom'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.recurring_schedule_check_log (
    id integer NOT NULL,
    check_date date DEFAULT CURRENT_DATE NOT NULL,
    schedules_checked integer DEFAULT 0,
    notifications_sent integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.regular_shift (
    id text NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    working_hours numeric(5,2) DEFAULT 0
);

--

CREATE TABLE IF NOT EXISTS public.requesters (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_id character varying(50) NOT NULL,
    requester_name character varying(255) NOT NULL,
    contact_number character varying(20),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    created_by uuid,
    updated_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.security_code_scroll_texts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    text_content text NOT NULL,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);

--

CREATE TABLE IF NOT EXISTS public.shelf_paper_fonts (
    name character varying(255) NOT NULL,
    font_url text NOT NULL,
    file_name character varying(255),
    file_size integer,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    id character varying(20) DEFAULT ('F'::text || (nextval('public.shelf_paper_fonts_id_seq'::regclass))::text) NOT NULL,
    original_file_name character varying(500)
);

--

CREATE TABLE IF NOT EXISTS public.shelf_paper_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    template_image_url text NOT NULL,
    field_configuration jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb
);

--

CREATE TABLE IF NOT EXISTS public.sidebar_buttons (
    id bigint NOT NULL,
    main_section_id bigint NOT NULL,
    subsection_id bigint NOT NULL,
    button_name_en character varying(255) NOT NULL,
    button_name_ar character varying(255) NOT NULL,
    button_code character varying(100) NOT NULL,
    icon character varying(50),
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.social_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id bigint NOT NULL,
    facebook text,
    whatsapp text,
    instagram text,
    tiktok text,
    snapchat text,
    website text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    location_link text,
    facebook_clicks bigint DEFAULT 0,
    whatsapp_clicks bigint DEFAULT 0,
    instagram_clicks bigint DEFAULT 0,
    tiktok_clicks bigint DEFAULT 0,
    snapchat_clicks bigint DEFAULT 0,
    website_clicks bigint DEFAULT 0,
    location_link_clicks bigint DEFAULT 0
);

--

CREATE TABLE IF NOT EXISTS public.special_shift_date_wise (
    id text NOT NULL,
    employee_id text NOT NULL,
    shift_date date NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0,
    is_shift_overlapping_next_day boolean DEFAULT false,
    working_hours numeric(5,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.special_shift_weekday (
    id text NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT special_shift_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);

--

CREATE TABLE IF NOT EXISTS public.system_api_keys (
    id integer NOT NULL,
    service_name character varying(100) NOT NULL,
    api_key text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.task_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    assignment_type text NOT NULL,
    assigned_to_user_id uuid,
    assigned_to_branch_id bigint,
    assigned_by uuid NOT NULL,
    assigned_by_name text,
    assigned_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'assigned'::text,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    schedule_date date,
    schedule_time time without time zone,
    deadline_date date,
    deadline_time time without time zone,
    deadline_datetime timestamp with time zone,
    is_reassignable boolean DEFAULT true,
    is_recurring boolean DEFAULT false,
    recurring_pattern jsonb,
    notes text,
    priority_override text,
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    reassigned_from uuid,
    reassignment_reason text,
    reassigned_at timestamp with time zone,
    CONSTRAINT chk_deadline_consistency CHECK ((((deadline_date IS NULL) AND (deadline_time IS NULL)) OR (deadline_date IS NOT NULL))),
    CONSTRAINT chk_priority_override_valid CHECK (((priority_override IS NULL) OR (priority_override = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'urgent'::text])))),
    CONSTRAINT chk_schedule_consistency CHECK ((((schedule_date IS NULL) AND (schedule_time IS NULL)) OR (schedule_date IS NOT NULL)))
);

--

CREATE TABLE IF NOT EXISTS public.task_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    file_name text NOT NULL,
    file_size bigint NOT NULL,
    file_type text NOT NULL,
    file_url text NOT NULL,
    image_type text NOT NULL,
    uploaded_by text NOT NULL,
    uploaded_by_name text,
    created_at timestamp with time zone DEFAULT now(),
    image_width integer,
    image_height integer,
    file_path text,
    attachment_type text DEFAULT 'task_creation'::text,
    CONSTRAINT task_images_attachment_type_check CHECK ((attachment_type = ANY (ARRAY['task_creation'::text, 'task_completion'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.task_completions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    completed_by text NOT NULL,
    completed_by_name text,
    completed_by_branch_id uuid,
    task_finished_completed boolean DEFAULT false,
    photo_uploaded_completed boolean DEFAULT false,
    erp_reference_completed boolean DEFAULT false,
    erp_reference_number text,
    completion_notes text,
    verified_by text,
    verified_at timestamp with time zone,
    verification_notes text,
    completed_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    completion_photo_url text,
    CONSTRAINT chk_photo_url_consistency CHECK (((photo_uploaded_completed = false) OR (completion_photo_url IS NOT NULL)))
);

--

CREATE TABLE IF NOT EXISTS public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    require_task_finished boolean DEFAULT false,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    can_escalate boolean DEFAULT false,
    can_reassign boolean DEFAULT false,
    created_by text NOT NULL,
    created_by_name text,
    created_by_role text,
    status text DEFAULT 'draft'::text,
    priority text DEFAULT 'medium'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    due_date date,
    due_time time without time zone,
    due_datetime timestamp with time zone,
    search_vector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, ((title || ' '::text) || COALESCE(description, ''::text)))) STORED,
    metadata jsonb,
    CONSTRAINT tasks_priority_check CHECK ((priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.task_reminder_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_assignment_id uuid,
    quick_task_assignment_id uuid,
    task_title text NOT NULL,
    assigned_to_user_id uuid,
    deadline timestamp with time zone NOT NULL,
    hours_overdue numeric,
    reminder_sent_at timestamp with time zone DEFAULT now(),
    notification_id uuid,
    status text DEFAULT 'sent'::text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT check_single_assignment CHECK ((((task_assignment_id IS NOT NULL) AND (quick_task_assignment_id IS NULL)) OR ((task_assignment_id IS NULL) AND (quick_task_assignment_id IS NOT NULL))))
);

--

CREATE TABLE IF NOT EXISTS public.user_audit_logs (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    target_user_id uuid,
    action character varying(100) NOT NULL,
    table_name character varying(100),
    record_id uuid,
    old_values jsonb,
    new_values jsonb,
    ip_address inet,
    user_agent text,
    performed_by uuid,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.user_device_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    device_id character varying(100) NOT NULL,
    session_token character varying(255) NOT NULL,
    device_type character varying(20) NOT NULL,
    browser_name character varying(50),
    user_agent text,
    ip_address inet,
    is_active boolean DEFAULT true,
    login_at timestamp with time zone DEFAULT now(),
    last_activity timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '24:00:00'::interval),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_device_sessions_device_type_check CHECK (((device_type)::text = ANY (ARRAY[('mobile'::character varying)::text, ('desktop'::character varying)::text])))
);

--

CREATE TABLE IF NOT EXISTS public.user_favorite_buttons (
    id text NOT NULL,
    employee_id text,
    user_id uuid NOT NULL,
    favorite_config jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

--

CREATE TABLE IF NOT EXISTS public.user_mobile_theme_assignments (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    theme_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    color_overrides jsonb
);

--

CREATE TABLE IF NOT EXISTS public.user_password_history (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    password_hash character varying(255) NOT NULL,
    salt character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.user_sessions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    session_token character varying(255) NOT NULL,
    login_method character varying(20) NOT NULL,
    ip_address inet,
    user_agent text,
    is_active boolean DEFAULT true,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    ended_at timestamp with time zone,
    CONSTRAINT user_sessions_login_method_check CHECK (((login_method)::text = ANY (ARRAY[('quick_access'::character varying)::text, ('username_password'::character varying)::text])))
);

--

CREATE TABLE IF NOT EXISTS public.user_theme_assignments (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    theme_id integer NOT NULL,
    assigned_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.user_voice_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    locale text NOT NULL,
    voice_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_voice_preferences_locale_check CHECK ((locale = ANY (ARRAY['en'::text, 'ar'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.variation_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    action_type text NOT NULL,
    variation_group_id uuid,
    affected_barcodes text[],
    parent_barcode text,
    group_name_en text,
    group_name_ar text,
    user_id uuid,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    details jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT variation_audit_log_action_type_check CHECK ((action_type = ANY (ARRAY['create_group'::text, 'edit_group'::text, 'delete_group'::text, 'add_variation'::text, 'remove_variation'::text, 'reorder_variations'::text, 'change_parent'::text, 'update_image_override'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.vendor_payment_schedule (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    receiving_record_id uuid,
    bill_number character varying(255),
    vendor_id character varying(255),
    vendor_name character varying(255),
    branch_id integer,
    branch_name character varying(255),
    bill_date date,
    bill_amount numeric(15,2),
    final_bill_amount numeric(15,2),
    payment_method character varying(100),
    bank_name character varying(255),
    iban character varying(255),
    due_date date,
    credit_period integer,
    vat_number character varying(100),
    scheduled_date timestamp without time zone DEFAULT now(),
    paid_date timestamp without time zone,
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    original_due_date date,
    original_bill_amount numeric(15,2),
    original_final_amount numeric(15,2),
    is_paid boolean DEFAULT false,
    payment_reference character varying(255),
    task_id uuid,
    task_assignment_id uuid,
    receiver_user_id uuid,
    accountant_user_id uuid,
    verification_status text DEFAULT 'pending'::text,
    verified_by uuid,
    verified_date timestamp with time zone,
    transaction_date timestamp with time zone,
    original_bill_url text,
    created_by uuid,
    pr_excel_verified boolean DEFAULT false,
    pr_excel_verified_by uuid,
    pr_excel_verified_date timestamp with time zone,
    discount_amount numeric(15,2) DEFAULT 0,
    discount_notes text,
    grr_amount numeric(15,2) DEFAULT 0,
    grr_reference_number text,
    grr_notes text,
    pri_amount numeric(15,2) DEFAULT 0,
    pri_reference_number text,
    pri_notes text,
    last_adjustment_date timestamp with time zone,
    last_adjusted_by uuid,
    adjustment_history jsonb DEFAULT '[]'::jsonb,
    approval_status text DEFAULT 'pending'::text NOT NULL,
    approval_requested_by uuid,
    approval_requested_at timestamp with time zone,
    approved_by uuid,
    approved_at timestamp with time zone,
    approval_notes text,
    assigned_approver_id uuid,
    CONSTRAINT check_discount_amount_positive CHECK ((discount_amount >= (0)::numeric)),
    CONSTRAINT check_grr_amount_positive CHECK ((grr_amount >= (0)::numeric)),
    CONSTRAINT check_pri_amount_positive CHECK ((pri_amount >= (0)::numeric)),
    CONSTRAINT check_total_deductions_valid CHECK ((((COALESCE(discount_amount, (0)::numeric) + COALESCE(grr_amount, (0)::numeric)) + COALESCE(pri_amount, (0)::numeric)) <= COALESCE(original_final_amount, final_bill_amount, bill_amount))),
    CONSTRAINT vendor_payment_approval_status_check CHECK ((approval_status = ANY (ARRAY['pending'::text, 'sent_for_approval'::text, 'approved'::text, 'rejected'::text])))
);

--

CREATE TABLE IF NOT EXISTS public.view_offer (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_name character varying(255) NOT NULL,
    branch_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    file_url text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    start_time time without time zone DEFAULT '00:00:00'::time without time zone,
    end_time time without time zone DEFAULT '23:59:00'::time without time zone,
    thumbnail_url text,
    view_button_count integer DEFAULT 0,
    page_visit_count integer DEFAULT 0
);

--

CREATE TABLE IF NOT EXISTS public.wa_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone_number character varying(20) NOT NULL,
    display_name text,
    waba_id text,
    phone_number_id text,
    access_token text,
    quality_rating character varying(10) DEFAULT 'GREEN'::character varying,
    status character varying(20) DEFAULT 'connected'::character varying,
    is_default boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true,
    branch_id uuid,
    payment_pending numeric(12,2) DEFAULT 0,
    payment_currency text DEFAULT 'USD'::text,
    last_payment_date timestamp without time zone,
    meta_business_account_id text,
    meta_access_token text
);

--

CREATE TABLE IF NOT EXISTS public.wa_ai_bot_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    is_enabled boolean DEFAULT false,
    tone character varying(20) DEFAULT 'friendly'::character varying,
    default_language character varying(10) DEFAULT 'auto'::character varying,
    max_replies_per_conversation integer DEFAULT 10,
    handoff_keywords text[] DEFAULT '{}'::text[],
    training_data jsonb DEFAULT '[]'::jsonb,
    custom_instructions text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    token_limit integer DEFAULT 500000,
    tokens_used integer DEFAULT 0,
    prompt_tokens_used integer DEFAULT 0,
    completion_tokens_used integer DEFAULT 0,
    total_requests integer DEFAULT 0,
    training_qa jsonb DEFAULT '[]'::jsonb,
    bot_rules text DEFAULT ''::text,
    human_support_enabled boolean DEFAULT false,
    human_support_start_time time without time zone DEFAULT '12:00:00'::time without time zone,
    human_support_end_time time without time zone DEFAULT '20:00:00'::time without time zone
);

--

CREATE TABLE IF NOT EXISTS public.wa_auto_reply_triggers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text,
    trigger_words_en text[] DEFAULT '{}'::text[],
    trigger_words_ar text[] DEFAULT '{}'::text[],
    match_type character varying(20) DEFAULT 'contains'::character varying,
    reply_type character varying(20) DEFAULT 'text'::character varying,
    reply_text text,
    reply_media_url text,
    reply_template_id uuid,
    reply_buttons jsonb DEFAULT '[]'::jsonb,
    follow_up_trigger_id uuid,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    trigger_words text[] DEFAULT ARRAY[]::text[],
    response_type character varying(20) DEFAULT 'text'::character varying,
    response_content text,
    response_media_url text,
    response_template_name text,
    response_buttons jsonb DEFAULT '[]'::jsonb,
    follow_up_delay_seconds integer DEFAULT 0,
    follow_up_content text,
    priority integer DEFAULT 0
);

--

CREATE TABLE IF NOT EXISTS public.wa_bot_flows (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text NOT NULL,
    trigger_words_en text[] DEFAULT ARRAY[]::text[],
    trigger_words_ar text[] DEFAULT ARRAY[]::text[],
    match_type character varying(20) DEFAULT 'contains'::character varying,
    nodes jsonb DEFAULT '[]'::jsonb,
    edges jsonb DEFAULT '[]'::jsonb,
    is_active boolean DEFAULT true,
    priority integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.wa_broadcast_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    broadcast_id uuid,
    customer_id uuid,
    phone_number character varying(20) NOT NULL,
    customer_name text,
    whatsapp_message_id text,
    status character varying(20) DEFAULT 'pending'::character varying,
    error_details text,
    sent_at timestamp with time zone
);

--

CREATE TABLE IF NOT EXISTS public.wa_broadcasts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text,
    template_id uuid,
    recipient_filter character varying(20) DEFAULT 'all'::character varying,
    recipient_group_id uuid,
    total_recipients integer DEFAULT 0,
    sent_count integer DEFAULT 0,
    delivered_count integer DEFAULT 0,
    read_count integer DEFAULT 0,
    failed_count integer DEFAULT 0,
    status character varying(20) DEFAULT 'draft'::character varying,
    scheduled_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.wa_catalog_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid NOT NULL,
    catalog_id uuid,
    customer_phone text NOT NULL,
    customer_name text,
    order_status text DEFAULT 'pending'::text,
    items jsonb DEFAULT '[]'::jsonb,
    subtotal numeric(12,2) DEFAULT 0,
    tax numeric(12,2) DEFAULT 0,
    shipping numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'SAR'::text,
    notes text,
    meta_order_id text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.wa_catalog_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    catalog_id uuid NOT NULL,
    wa_account_id uuid NOT NULL,
    meta_product_id text,
    retailer_id text,
    name text NOT NULL,
    description text,
    price numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'SAR'::text,
    sale_price numeric(12,2),
    image_url text,
    additional_images text[] DEFAULT '{}'::text[],
    url text,
    category text,
    availability text DEFAULT 'in stock'::text,
    condition text DEFAULT 'new'::text,
    brand text,
    sku text,
    quantity integer DEFAULT 0,
    is_hidden boolean DEFAULT false,
    status text DEFAULT 'active'::text,
    synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.wa_catalogs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid NOT NULL,
    meta_catalog_id text,
    name text NOT NULL,
    description text,
    status text DEFAULT 'active'::text,
    product_count integer DEFAULT 0,
    synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.wa_contact_group_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    group_id uuid,
    customer_id uuid,
    added_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.wa_contact_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    customer_count integer DEFAULT 0,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.wa_conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    customer_id uuid,
    customer_phone character varying(20) NOT NULL,
    customer_name text,
    last_message_at timestamp with time zone,
    last_message_preview text,
    unread_count integer DEFAULT 0,
    is_bot_handling boolean DEFAULT false,
    bot_type character varying(20),
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    branch_id uuid,
    handled_by character varying(20) DEFAULT 'bot'::character varying,
    window_expires_at timestamp with time zone,
    needs_human boolean DEFAULT false,
    is_sos boolean DEFAULT false
);

--

CREATE TABLE IF NOT EXISTS public.wa_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid,
    wa_account_id uuid,
    whatsapp_message_id text,
    direction character varying(10) DEFAULT 'outbound'::character varying NOT NULL,
    message_type character varying(20) DEFAULT 'text'::character varying,
    content text,
    media_url text,
    media_mime_type character varying(50),
    template_name character varying(100),
    template_language character varying(10),
    status character varying(20) DEFAULT 'sent'::character varying,
    sent_by character varying(20) DEFAULT 'user'::character varying,
    sent_by_user_id uuid,
    error_details text,
    created_at timestamp with time zone DEFAULT now(),
    delivered_at timestamp with time zone,
    read_at timestamp with time zone,
    metadata jsonb
);

--

CREATE TABLE IF NOT EXISTS public.wa_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    business_name text,
    business_description text,
    business_address text,
    business_email text,
    business_website text,
    business_category text,
    profile_picture_url text,
    about_text text,
    webhook_url text,
    webhook_verify_token text,
    webhook_active boolean DEFAULT false,
    business_hours jsonb DEFAULT '{}'::jsonb,
    outside_hours_message text,
    default_language character varying(10) DEFAULT 'en'::character varying,
    notify_new_message boolean DEFAULT true,
    notify_bot_escalation boolean DEFAULT true,
    notify_broadcast_complete boolean DEFAULT true,
    notify_template_status boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    auto_reply_enabled boolean DEFAULT false
);

--

CREATE TABLE IF NOT EXISTS public.wa_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    meta_template_id text,
    name character varying(100) NOT NULL,
    category character varying(20) DEFAULT 'UTILITY'::character varying,
    language character varying(10) DEFAULT 'en'::character varying,
    status character varying(20) DEFAULT 'PENDING'::character varying,
    header_type character varying(20) DEFAULT 'none'::character varying,
    header_content text,
    body_text text,
    footer_text text,
    buttons jsonb DEFAULT '[]'::jsonb,
    meta_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

--

CREATE TABLE IF NOT EXISTS public.warning_main_category (
    id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.warning_sub_category (
    id character varying(10) NOT NULL,
    main_category_id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.warning_violation (
    id character varying(10) NOT NULL,
    sub_category_id character varying(10) NOT NULL,
    main_category_id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

--

CREATE TABLE IF NOT EXISTS public.whatsapp_message_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone_number character varying(20) NOT NULL,
    message_type character varying(50) DEFAULT 'access_code'::character varying NOT NULL,
    template_name character varying(100),
    template_language character varying(10),
    whatsapp_message_id text,
    status character varying(20) DEFAULT 'sent'::character varying,
    customer_name text,
    error_details text,
    created_at timestamp with time zone DEFAULT now()
);