CREATE TABLE public.whatsapp_message_log (
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


--
-- Name: ai_chat_guide id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_chat_guide ALTER COLUMN id SET DEFAULT nextval('public.ai_chat_guide_id_seq'::regclass);


--
-- Name: approval_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions ALTER COLUMN id SET DEFAULT nextval('public.approval_permissions_id_seq'::regclass);


--
-- Name: approver_branch_access id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_branch_access ALTER COLUMN id SET DEFAULT nextval('public.approver_branch_access_id_seq'::regclass);


--
-- Name: approver_visibility_config id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config ALTER COLUMN id SET DEFAULT nextval('public.approver_visibility_config_id_seq'::regclass);


--
-- Name: asset_main_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_main_categories ALTER COLUMN id SET DEFAULT nextval('public.asset_main_categories_id_seq'::regclass);


--
-- Name: asset_sub_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_sub_categories ALTER COLUMN id SET DEFAULT nextval('public.asset_sub_categories_id_seq'::regclass);


--
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- Name: bank_reconciliations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations ALTER COLUMN id SET DEFAULT nextval('public.bank_reconciliations_id_seq'::regclass);


--
-- Name: bogo_offer_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules ALTER COLUMN id SET DEFAULT nextval('public.bogo_offer_rules_id_seq'::regclass);


--
-- Name: branches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);


--
-- Name: break_reasons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_reasons ALTER COLUMN id SET DEFAULT nextval('public.break_reasons_id_seq'::regclass);


--
-- Name: denomination_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_types ALTER COLUMN id SET DEFAULT nextval('public.denomination_types_id_seq'::regclass);


--
-- Name: desktop_themes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.desktop_themes ALTER COLUMN id SET DEFAULT nextval('public.desktop_themes_id_seq'::regclass);


--
-- Name: employee_checklist_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments ALTER COLUMN id SET DEFAULT nextval('public.employee_checklist_assignments_id_seq'::regclass);


--
-- Name: erp_sync_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_sync_logs ALTER COLUMN id SET DEFAULT nextval('public.erp_sync_logs_id_seq'::regclass);


--
-- Name: erp_synced_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_synced_products ALTER COLUMN id SET DEFAULT nextval('public.erp_synced_products_id_seq'::regclass);


--
-- Name: expense_parent_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_parent_categories ALTER COLUMN id SET DEFAULT nextval('public.expense_parent_categories_id_seq'::regclass);


--
-- Name: expense_requisitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions ALTER COLUMN id SET DEFAULT nextval('public.expense_requisitions_id_seq'::regclass);


--
-- Name: expense_scheduler id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_scheduler ALTER COLUMN id SET DEFAULT nextval('public.expense_scheduler_id_seq'::regclass);


--
-- Name: expense_sub_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sub_categories ALTER COLUMN id SET DEFAULT nextval('public.expense_sub_categories_id_seq'::regclass);


--
-- Name: frontend_builds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frontend_builds ALTER COLUMN id SET DEFAULT nextval('public.frontend_builds_id_seq'::regclass);


--
-- Name: hr_analysed_attendance_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_analysed_attendance_data ALTER COLUMN id SET DEFAULT nextval('public.hr_analysed_attendance_data_id_seq'::regclass);


--
-- Name: mobile_themes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile_themes ALTER COLUMN id SET DEFAULT nextval('public.mobile_themes_id_seq'::regclass);


--
-- Name: multi_shift_date_wise id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_date_wise ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_date_wise_id_seq'::regclass);


--
-- Name: multi_shift_regular id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_regular ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_regular_id_seq'::regclass);


--
-- Name: multi_shift_weekday id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_weekday ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_weekday_id_seq'::regclass);


--
-- Name: non_approved_payment_scheduler id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler ALTER COLUMN id SET DEFAULT nextval('public.non_approved_payment_scheduler_id_seq'::regclass);


--
-- Name: offer_bundles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_bundles ALTER COLUMN id SET DEFAULT nextval('public.offer_bundles_id_seq'::regclass);


--
-- Name: offer_cart_tiers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_cart_tiers ALTER COLUMN id SET DEFAULT nextval('public.offer_cart_tiers_id_seq'::regclass);


--
-- Name: offer_usage_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_usage_logs ALTER COLUMN id SET DEFAULT nextval('public.offer_usage_logs_id_seq'::regclass);


--
-- Name: offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers ALTER COLUMN id SET DEFAULT nextval('public.offers_id_seq'::regclass);


--
-- Name: recurring_schedule_check_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_schedule_check_log ALTER COLUMN id SET DEFAULT nextval('public.recurring_schedule_check_log_id_seq'::regclass);


--
-- Name: system_api_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_api_keys ALTER COLUMN id SET DEFAULT nextval('public.system_api_keys_id_seq'::regclass);


--
-- Name: user_mobile_theme_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mobile_theme_assignments ALTER COLUMN id SET DEFAULT nextval('public.user_mobile_theme_assignments_id_seq'::regclass);


--
-- Name: user_theme_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_theme_assignments ALTER COLUMN id SET DEFAULT nextval('public.user_theme_assignments_id_seq'::regclass);


--
-- Name: access_code_otp access_code_otp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_code_otp
    ADD CONSTRAINT access_code_otp_pkey PRIMARY KEY (id);


--
-- Name: ai_chat_guide ai_chat_guide_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_chat_guide
    ADD CONSTRAINT ai_chat_guide_pkey PRIMARY KEY (id);


--
-- Name: app_icons app_icons_icon_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_icon_key_key UNIQUE (icon_key);


--
-- Name: app_icons app_icons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_pkey PRIMARY KEY (id);


--
-- Name: approval_permissions approval_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_pkey PRIMARY KEY (id);


--
-- Name: approval_permissions approval_permissions_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_user_id_key UNIQUE (user_id);


--
-- Name: approver_branch_access approver_branch_access_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_pkey PRIMARY KEY (id);


--
-- Name: approver_branch_access approver_branch_access_user_id_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_user_id_branch_id_key UNIQUE (user_id, branch_id);


--
-- Name: approver_visibility_config approver_visibility_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_pkey PRIMARY KEY (id);


--
-- Name: approver_visibility_config approver_visibility_config_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_user_id_key UNIQUE (user_id);


--
-- Name: asset_sub_categories asset_items_group_code_name_en_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_sub_categories
    ADD CONSTRAINT asset_items_group_code_name_en_key UNIQUE (group_code, name_en);


--
-- Name: asset_sub_categories asset_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_sub_categories
    ADD CONSTRAINT asset_items_pkey PRIMARY KEY (id);


--
-- Name: asset_main_categories asset_main_categories_group_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_group_code_key UNIQUE (group_code);


--
-- Name: asset_main_categories asset_main_categories_name_en_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_name_en_key UNIQUE (name_en);


--
-- Name: asset_main_categories asset_main_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_pkey PRIMARY KEY (id);


--
-- Name: assets assets_asset_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_asset_id_key UNIQUE (asset_id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: bank_reconciliations bank_reconciliations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_pkey PRIMARY KEY (id);


--
-- Name: biometric_connections biometric_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT biometric_connections_pkey PRIMARY KEY (id);


--
-- Name: bogo_offer_rules bogo_offer_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_pkey PRIMARY KEY (id);


--
-- Name: box_operations box_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_pkey PRIMARY KEY (id);


--
-- Name: branch_default_delivery_receivers branch_default_delivery_receivers_branch_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_delivery_receivers
    ADD CONSTRAINT branch_default_delivery_receivers_branch_id_user_id_key UNIQUE (branch_id, user_id);


--
-- Name: branch_default_delivery_receivers branch_default_delivery_receivers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_delivery_receivers
    ADD CONSTRAINT branch_default_delivery_receivers_pkey PRIMARY KEY (id);


--
-- Name: branch_default_positions branch_default_positions_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_id_key UNIQUE (branch_id);


--
-- Name: branch_default_positions branch_default_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_pkey PRIMARY KEY (id);


--
-- Name: branch_sync_config branch_sync_config_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_sync_config
    ADD CONSTRAINT branch_sync_config_branch_id_key UNIQUE (branch_id);


--
-- Name: branch_sync_config branch_sync_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_sync_config
    ADD CONSTRAINT branch_sync_config_pkey PRIMARY KEY (id);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: break_reasons break_reasons_name_en_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_reasons
    ADD CONSTRAINT break_reasons_name_en_unique UNIQUE (name_en);


--
-- Name: break_reasons break_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_reasons
    ADD CONSTRAINT break_reasons_pkey PRIMARY KEY (id);


--
-- Name: break_register break_register_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_register
    ADD CONSTRAINT break_register_pkey PRIMARY KEY (id);


--
-- Name: break_security_seed break_security_seed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_security_seed
    ADD CONSTRAINT break_security_seed_pkey PRIMARY KEY (id);


--
-- Name: button_main_sections button_main_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_main_sections
    ADD CONSTRAINT button_main_sections_pkey PRIMARY KEY (id);


--
-- Name: button_main_sections button_main_sections_section_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_main_sections
    ADD CONSTRAINT button_main_sections_section_code_key UNIQUE (section_code);


--
-- Name: button_permissions button_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT button_permissions_pkey PRIMARY KEY (id);


--
-- Name: button_permissions button_permissions_user_id_button_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT button_permissions_user_id_button_id_key UNIQUE (user_id, button_id);


--
-- Name: button_sub_sections button_sub_sections_main_section_id_subsection_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_sub_sections
    ADD CONSTRAINT button_sub_sections_main_section_id_subsection_code_key UNIQUE (main_section_id, subsection_code);


--
-- Name: button_sub_sections button_sub_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_sub_sections
    ADD CONSTRAINT button_sub_sections_pkey PRIMARY KEY (id);


--
-- Name: coupon_campaigns coupon_campaigns_campaign_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_campaigns
    ADD CONSTRAINT coupon_campaigns_campaign_code_key UNIQUE (campaign_code);


--
-- Name: coupon_campaigns coupon_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_campaigns
    ADD CONSTRAINT coupon_campaigns_pkey PRIMARY KEY (id);


--
-- Name: coupon_claims coupon_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_pkey PRIMARY KEY (id);


--
-- Name: coupon_eligible_customers coupon_eligible_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT coupon_eligible_customers_pkey PRIMARY KEY (id);


--
-- Name: coupon_products coupon_products_campaign_barcode_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_campaign_barcode_unique UNIQUE (campaign_id, special_barcode);


--
-- Name: coupon_products coupon_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_pkey PRIMARY KEY (id);


--
-- Name: customer_access_code_history customer_access_code_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_pkey PRIMARY KEY (id);


--
-- Name: customer_app_media customer_app_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_app_media
    ADD CONSTRAINT customer_app_media_pkey PRIMARY KEY (id);


--
-- Name: customer_product_requests customer_product_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_pkey PRIMARY KEY (id);


--
-- Name: customer_recovery_requests customer_recovery_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_recovery_requests
    ADD CONSTRAINT customer_recovery_requests_pkey PRIMARY KEY (id);


--
-- Name: customers customers_access_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_access_code_key UNIQUE (access_code);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: customers customers_whatsapp_number_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_whatsapp_number_unique UNIQUE (whatsapp_number);


--
-- Name: day_off day_off_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_pkey PRIMARY KEY (id);


--
-- Name: day_off_reasons day_off_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_reasons
    ADD CONSTRAINT day_off_reasons_pkey PRIMARY KEY (id);


--
-- Name: day_off_reasons day_off_reasons_reason_en_reason_ar_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_reasons
    ADD CONSTRAINT day_off_reasons_reason_en_reason_ar_key UNIQUE (reason_en, reason_ar);


--
-- Name: day_off_weekday day_off_weekday_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT day_off_weekday_pkey PRIMARY KEY (id);


--
-- Name: default_incident_users default_incident_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.default_incident_users
    ADD CONSTRAINT default_incident_users_pkey PRIMARY KEY (id);


--
-- Name: default_incident_users default_incident_users_user_id_incident_type_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.default_incident_users
    ADD CONSTRAINT default_incident_users_user_id_incident_type_id_key UNIQUE (user_id, incident_type_id);


--
-- Name: deleted_bundle_offers deleted_bundle_offers_original_offer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_original_offer_id_key UNIQUE (original_offer_id);


--
-- Name: deleted_bundle_offers deleted_bundle_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_pkey PRIMARY KEY (id);


--
-- Name: delivery_fee_tiers delivery_fee_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_pkey PRIMARY KEY (id);


--
-- Name: delivery_service_settings delivery_service_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_service_settings
    ADD CONSTRAINT delivery_service_settings_pkey PRIMARY KEY (id);


--
-- Name: denomination_audit_log denomination_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_audit_log
    ADD CONSTRAINT denomination_audit_log_pkey PRIMARY KEY (id);


--
-- Name: denomination_records denomination_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_pkey PRIMARY KEY (id);


--
-- Name: denomination_transactions denomination_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_pkey PRIMARY KEY (id);


--
-- Name: denomination_types denomination_types_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_types
    ADD CONSTRAINT denomination_types_code_key UNIQUE (code);


--
-- Name: denomination_types denomination_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_types
    ADD CONSTRAINT denomination_types_pkey PRIMARY KEY (id);


--
-- Name: denomination_user_preferences denomination_user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_pkey PRIMARY KEY (id);


--
-- Name: denomination_user_preferences denomination_user_preferences_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_user_id_key UNIQUE (user_id);


--
-- Name: desktop_themes desktop_themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.desktop_themes
    ADD CONSTRAINT desktop_themes_pkey PRIMARY KEY (id);


--
-- Name: edge_functions_cache edge_functions_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edge_functions_cache
    ADD CONSTRAINT edge_functions_cache_pkey PRIMARY KEY (func_name);


--
-- Name: employee_checklist_assignments employee_checklist_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_pkey PRIMARY KEY (id);


--
-- Name: employee_fine_payments employee_fine_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_fine_payments
    ADD CONSTRAINT employee_fine_payments_pkey PRIMARY KEY (id);


--
-- Name: employee_official_holidays employee_official_holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_official_holidays
    ADD CONSTRAINT employee_official_holidays_pkey PRIMARY KEY (id);


--
-- Name: erp_connections erp_connections_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_connections
    ADD CONSTRAINT erp_connections_branch_id_key UNIQUE (branch_id);


--
-- Name: erp_connections erp_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_connections
    ADD CONSTRAINT erp_connections_pkey PRIMARY KEY (id);


--
-- Name: erp_daily_sales erp_daily_sales_branch_id_sale_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_branch_id_sale_date_key UNIQUE (branch_id, sale_date);


--
-- Name: erp_daily_sales erp_daily_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_pkey PRIMARY KEY (id);


--
-- Name: erp_sync_logs erp_sync_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_sync_logs
    ADD CONSTRAINT erp_sync_logs_pkey PRIMARY KEY (id);


--
-- Name: erp_synced_products erp_synced_products_barcode_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_synced_products
    ADD CONSTRAINT erp_synced_products_barcode_key UNIQUE (barcode);


--
-- Name: erp_synced_products erp_synced_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_synced_products
    ADD CONSTRAINT erp_synced_products_pkey PRIMARY KEY (id);


--
-- Name: expense_parent_categories expense_parent_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_parent_categories
    ADD CONSTRAINT expense_parent_categories_pkey PRIMARY KEY (id);


--
-- Name: expense_requisitions expense_requisitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_pkey PRIMARY KEY (id);


--
-- Name: expense_requisitions expense_requisitions_requisition_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_requisition_number_key UNIQUE (requisition_number);


--
-- Name: expense_scheduler expense_scheduler_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT expense_scheduler_pkey PRIMARY KEY (id);


--
-- Name: expense_sub_categories expense_sub_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sub_categories
    ADD CONSTRAINT expense_sub_categories_pkey PRIMARY KEY (id);


--
-- Name: flyer_offer_products flyer_offer_products_offer_id_product_barcode_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_offer_id_product_barcode_key UNIQUE (offer_id, product_barcode);


--
-- Name: flyer_offer_products flyer_offer_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_pkey PRIMARY KEY (id);


--
-- Name: flyer_offers flyer_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_pkey PRIMARY KEY (id);


--
-- Name: flyer_offers flyer_offers_template_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_template_id_key UNIQUE (template_id);


--
-- Name: products flyer_products_pkey1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_pkey1 PRIMARY KEY (id);


--
-- Name: flyer_templates flyer_templates_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_name_unique UNIQUE (name);


--
-- Name: flyer_templates flyer_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_pkey PRIMARY KEY (id);


--
-- Name: frontend_builds frontend_builds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frontend_builds
    ADD CONSTRAINT frontend_builds_pkey PRIMARY KEY (id);


--
-- Name: hr_analysed_attendance_data hr_analysed_attendance_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_analysed_attendance_data
    ADD CONSTRAINT hr_analysed_attendance_data_pkey PRIMARY KEY (id);


--
-- Name: hr_basic_salary hr_basic_salary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_basic_salary
    ADD CONSTRAINT hr_basic_salary_pkey PRIMARY KEY (employee_id);


--
-- Name: hr_checklist_operations hr_checklist_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_pkey PRIMARY KEY (id);


--
-- Name: hr_checklist_questions hr_checklist_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_questions
    ADD CONSTRAINT hr_checklist_questions_pkey PRIMARY KEY (id);


--
-- Name: hr_checklists hr_checklists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklists
    ADD CONSTRAINT hr_checklists_pkey PRIMARY KEY (id);


--
-- Name: hr_departments hr_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_departments
    ADD CONSTRAINT hr_departments_pkey PRIMARY KEY (id);


--
-- Name: hr_employee_master hr_employee_master_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_pkey PRIMARY KEY (id);


--
-- Name: hr_employee_master hr_employee_master_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_user_id_key UNIQUE (user_id);


--
-- Name: hr_employees hr_employees_employee_id_branch_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_employee_id_branch_id_unique UNIQUE (employee_id, branch_id);


--
-- Name: hr_employees hr_employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_pkey PRIMARY KEY (id);


--
-- Name: hr_fingerprint_transactions hr_fingerprint_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_fingerprint_transactions
    ADD CONSTRAINT hr_fingerprint_transactions_pkey PRIMARY KEY (id);


--
-- Name: hr_insurance_companies hr_insurance_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_insurance_companies
    ADD CONSTRAINT hr_insurance_companies_pkey PRIMARY KEY (id);


--
-- Name: hr_levels hr_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_levels
    ADD CONSTRAINT hr_levels_pkey PRIMARY KEY (id);


--
-- Name: hr_position_assignments hr_position_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_pkey PRIMARY KEY (id);


--
-- Name: hr_position_reporting_template hr_position_reporting_template_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_pkey PRIMARY KEY (id);


--
-- Name: hr_position_reporting_template hr_position_reporting_template_subordinate_position_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_subordinate_position_id_key UNIQUE (subordinate_position_id);


--
-- Name: hr_positions hr_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_positions
    ADD CONSTRAINT hr_positions_pkey PRIMARY KEY (id);


--
-- Name: incident_actions incident_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_actions
    ADD CONSTRAINT incident_actions_pkey PRIMARY KEY (id);


--
-- Name: incident_types incident_types_incident_type_ar_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_incident_type_ar_key UNIQUE (incident_type_ar);


--
-- Name: incident_types incident_types_incident_type_en_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_incident_type_en_key UNIQUE (incident_type_en);


--
-- Name: incident_types incident_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_pkey PRIMARY KEY (id);


--
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- Name: interface_permissions interface_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interface_permissions
    ADD CONSTRAINT interface_permissions_pkey PRIMARY KEY (id);


--
-- Name: interface_permissions interface_permissions_user_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interface_permissions
    ADD CONSTRAINT interface_permissions_user_unique UNIQUE (user_id);


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_pkey PRIMARY KEY (id);


--
-- Name: lease_rent_payment_entries lease_rent_payment_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_payment_entries
    ADD CONSTRAINT lease_rent_payment_entries_pkey PRIMARY KEY (id);


--
-- Name: lease_rent_payments lease_rent_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_payments
    ADD CONSTRAINT lease_rent_payments_pkey PRIMARY KEY (id);


--
-- Name: lease_rent_payments lease_rent_payments_unique_period; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_payments
    ADD CONSTRAINT lease_rent_payments_unique_period UNIQUE (party_type, party_id, period_num);


--
-- Name: lease_rent_properties lease_rent_property_spaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_properties
    ADD CONSTRAINT lease_rent_property_spaces_pkey PRIMARY KEY (id);


--
-- Name: lease_rent_property_spaces lease_rent_property_spaces_pkey1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT lease_rent_property_spaces_pkey1 PRIMARY KEY (id);


--
-- Name: lease_rent_rent_parties lease_rent_rent_parties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_pkey PRIMARY KEY (id);


--
-- Name: lease_rent_special_changes lease_rent_special_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_special_changes
    ADD CONSTRAINT lease_rent_special_changes_pkey PRIMARY KEY (id);


--
-- Name: mobile_themes mobile_themes_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_name_key UNIQUE (name);


--
-- Name: mobile_themes mobile_themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_pkey PRIMARY KEY (id);


--
-- Name: multi_shift_date_wise multi_shift_date_wise_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_date_wise
    ADD CONSTRAINT multi_shift_date_wise_pkey PRIMARY KEY (id);


--
-- Name: multi_shift_regular multi_shift_regular_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_regular
    ADD CONSTRAINT multi_shift_regular_pkey PRIMARY KEY (id);


--
-- Name: multi_shift_weekday multi_shift_weekday_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_weekday
    ADD CONSTRAINT multi_shift_weekday_pkey PRIMARY KEY (id);


--
-- Name: nationalities nationalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nationalities
    ADD CONSTRAINT nationalities_pkey PRIMARY KEY (id);


--
-- Name: near_expiry_reports near_expiry_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_pkey PRIMARY KEY (id);


--
-- Name: non_approved_payment_scheduler non_approved_payment_scheduler_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT non_approved_payment_scheduler_pkey PRIMARY KEY (id);


--
-- Name: notification_attachments notification_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_attachments
    ADD CONSTRAINT notification_attachments_pkey PRIMARY KEY (id);


--
-- Name: notification_read_states notification_read_states_notification_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_read_states
    ADD CONSTRAINT notification_read_states_notification_id_user_id_key UNIQUE (notification_id, user_id);


--
-- Name: notification_read_states notification_read_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_read_states
    ADD CONSTRAINT notification_read_states_pkey PRIMARY KEY (id);


--
-- Name: notification_recipients notification_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: offer_bundles offer_bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_bundles
    ADD CONSTRAINT offer_bundles_pkey PRIMARY KEY (id);


--
-- Name: offer_cart_tiers offer_cart_tiers_offer_id_min_amount_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_cart_tiers
    ADD CONSTRAINT offer_cart_tiers_offer_id_min_amount_key UNIQUE (offer_id, min_amount);


--
-- Name: offer_cart_tiers offer_cart_tiers_offer_id_tier_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_cart_tiers
    ADD CONSTRAINT offer_cart_tiers_offer_id_tier_number_key UNIQUE (offer_id, tier_number);


--
-- Name: offer_cart_tiers offer_cart_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_cart_tiers
    ADD CONSTRAINT offer_cart_tiers_pkey PRIMARY KEY (id);


--
-- Name: offer_names offer_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_names
    ADD CONSTRAINT offer_names_pkey PRIMARY KEY (id);


--
-- Name: offer_products offer_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT offer_products_pkey PRIMARY KEY (id);


--
-- Name: offer_usage_logs offer_usage_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_pkey PRIMARY KEY (id);


--
-- Name: offers offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: official_holidays official_holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.official_holidays
    ADD CONSTRAINT official_holidays_pkey PRIMARY KEY (id);


--
-- Name: order_audit_logs order_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: overtime_registrations overtime_registrations_employee_id_overtime_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_employee_id_overtime_date_key UNIQUE (employee_id, overtime_date);


--
-- Name: overtime_registrations overtime_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_pkey PRIMARY KEY (id);


--
-- Name: pos_deduction_transfers pos_deduction_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_pkey PRIMARY KEY (id, box_number, date_closed_box);


--
-- Name: privilege_cards_branch privilege_cards_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privilege_cards_branch
    ADD CONSTRAINT privilege_cards_branch_pkey PRIMARY KEY (id);


--
-- Name: privilege_cards_branch privilege_cards_branch_privilege_card_id_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privilege_cards_branch
    ADD CONSTRAINT privilege_cards_branch_privilege_card_id_branch_id_key UNIQUE (privilege_card_id, branch_id);


--
-- Name: privilege_cards_master privilege_cards_master_card_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privilege_cards_master
    ADD CONSTRAINT privilege_cards_master_card_number_key UNIQUE (card_number);


--
-- Name: privilege_cards_master privilege_cards_master_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.privilege_cards_master
    ADD CONSTRAINT privilege_cards_master_pkey PRIMARY KEY (id);


--
-- Name: processed_fingerprint_transactions processed_fingerprint_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processed_fingerprint_transactions
    ADD CONSTRAINT processed_fingerprint_transactions_pkey PRIMARY KEY (id);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: product_request_bt product_request_bt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_pkey PRIMARY KEY (id);


--
-- Name: product_request_po product_request_po_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_pkey PRIMARY KEY (id);


--
-- Name: product_request_st product_request_st_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_st
    ADD CONSTRAINT product_request_st_pkey PRIMARY KEY (id);


--
-- Name: product_units product_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_units
    ADD CONSTRAINT product_units_pkey PRIMARY KEY (id);


--
-- Name: purchase_voucher_issue_types purchase_voucher_issue_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_issue_types
    ADD CONSTRAINT purchase_voucher_issue_types_pkey PRIMARY KEY (id);


--
-- Name: purchase_voucher_issue_types purchase_voucher_issue_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_issue_types
    ADD CONSTRAINT purchase_voucher_issue_types_type_name_key UNIQUE (type_name);


--
-- Name: purchase_voucher_items purchase_voucher_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_voucher_items purchase_voucher_items_purchase_voucher_id_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_purchase_voucher_id_serial_number_key UNIQUE (purchase_voucher_id, serial_number);


--
-- Name: purchase_vouchers purchase_vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_vouchers
    ADD CONSTRAINT purchase_vouchers_pkey PRIMARY KEY (id);


--
-- Name: push_subscriptions push_subscriptions_endpoint_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT push_subscriptions_endpoint_key UNIQUE (endpoint);


--
-- Name: push_subscriptions push_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT push_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: quick_task_assignments quick_task_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_pkey PRIMARY KEY (id);


--
-- Name: quick_task_assignments quick_task_assignments_quick_task_id_assigned_to_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_quick_task_id_assigned_to_user_id_key UNIQUE (quick_task_id, assigned_to_user_id);


--
-- Name: quick_task_comments quick_task_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_pkey PRIMARY KEY (id);


--
-- Name: quick_task_completions quick_task_completions_assignment_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_assignment_unique UNIQUE (assignment_id);


--
-- Name: quick_task_completions quick_task_completions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_pkey PRIMARY KEY (id);


--
-- Name: quick_task_files quick_task_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_pkey PRIMARY KEY (id);


--
-- Name: quick_task_user_preferences quick_task_user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_pkey PRIMARY KEY (id);


--
-- Name: quick_task_user_preferences quick_task_user_preferences_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_user_id_key UNIQUE (user_id);


--
-- Name: quick_tasks quick_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_pkey PRIMARY KEY (id);


--
-- Name: receiving_records receiving_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_pkey PRIMARY KEY (id);


--
-- Name: receiving_task_templates receiving_task_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_task_templates
    ADD CONSTRAINT receiving_task_templates_pkey PRIMARY KEY (id);


--
-- Name: receiving_task_templates receiving_task_templates_role_type_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_task_templates
    ADD CONSTRAINT receiving_task_templates_role_type_unique UNIQUE (role_type);


--
-- Name: receiving_tasks receiving_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_pkey PRIMARY KEY (id);


--
-- Name: receiving_user_defaults receiving_user_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_pkey PRIMARY KEY (id);


--
-- Name: receiving_user_defaults receiving_user_defaults_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_user_id_key UNIQUE (user_id);


--
-- Name: recurring_assignment_schedules recurring_assignment_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_assignment_schedules
    ADD CONSTRAINT recurring_assignment_schedules_pkey PRIMARY KEY (id);


--
-- Name: recurring_schedule_check_log recurring_schedule_check_log_check_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_schedule_check_log
    ADD CONSTRAINT recurring_schedule_check_log_check_date_key UNIQUE (check_date);


--
-- Name: recurring_schedule_check_log recurring_schedule_check_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_schedule_check_log
    ADD CONSTRAINT recurring_schedule_check_log_pkey PRIMARY KEY (id);


--
-- Name: regular_shift regular_shift_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regular_shift
    ADD CONSTRAINT regular_shift_pkey PRIMARY KEY (id);


--
-- Name: requesters requesters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requesters
    ADD CONSTRAINT requesters_pkey PRIMARY KEY (id);


--
-- Name: requesters requesters_requester_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requesters
    ADD CONSTRAINT requesters_requester_id_key UNIQUE (requester_id);


--
-- Name: security_code_scroll_texts security_code_scroll_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_code_scroll_texts
    ADD CONSTRAINT security_code_scroll_texts_pkey PRIMARY KEY (id);


--
-- Name: shelf_paper_fonts shelf_paper_fonts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelf_paper_fonts
    ADD CONSTRAINT shelf_paper_fonts_pkey PRIMARY KEY (id);


--
-- Name: shelf_paper_templates shelf_paper_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelf_paper_templates
    ADD CONSTRAINT shelf_paper_templates_pkey PRIMARY KEY (id);


--
-- Name: sidebar_buttons sidebar_buttons_main_section_id_subsection_id_button_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT sidebar_buttons_main_section_id_subsection_id_button_code_key UNIQUE (main_section_id, subsection_id, button_code);


--
-- Name: sidebar_buttons sidebar_buttons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT sidebar_buttons_pkey PRIMARY KEY (id);


--
-- Name: social_links social_links_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT social_links_branch_id_key UNIQUE (branch_id);


--
-- Name: social_links social_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT social_links_pkey PRIMARY KEY (id);


--
-- Name: special_shift_date_wise special_shift_date_wise_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT special_shift_date_wise_pkey PRIMARY KEY (id);


--
-- Name: special_shift_weekday special_shift_weekday_employee_id_weekday_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_employee_id_weekday_key UNIQUE (employee_id, weekday);


--
-- Name: special_shift_weekday special_shift_weekday_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_pkey PRIMARY KEY (id);


--
-- Name: system_api_keys system_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_api_keys
    ADD CONSTRAINT system_api_keys_pkey PRIMARY KEY (id);


--
-- Name: system_api_keys system_api_keys_service_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_api_keys
    ADD CONSTRAINT system_api_keys_service_name_key UNIQUE (service_name);


--
-- Name: task_assignments task_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_pkey PRIMARY KEY (id);


--
-- Name: task_assignments task_assignments_task_id_assignment_type_assigned_to_user_i_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_task_id_assignment_type_assigned_to_user_i_key UNIQUE (task_id, assignment_type, assigned_to_user_id, assigned_to_branch_id);


--
-- Name: task_completions task_completions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_pkey PRIMARY KEY (id);


--
-- Name: task_images task_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_images
    ADD CONSTRAINT task_images_pkey PRIMARY KEY (id);


--
-- Name: task_reminder_logs task_reminder_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: biometric_connections unique_branch_device; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT unique_branch_device UNIQUE (branch_id, device_id);


--
-- Name: coupon_eligible_customers unique_customer_campaign; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT unique_customer_campaign UNIQUE (campaign_id, mobile_number);


--
-- Name: special_shift_date_wise unique_employee_date; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT unique_employee_date UNIQUE (employee_id, shift_date);


--
-- Name: day_off unique_employee_day_off; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT unique_employee_day_off UNIQUE (employee_id, day_off_date);


--
-- Name: employee_official_holidays unique_employee_official_holiday; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_official_holidays
    ADD CONSTRAINT unique_employee_official_holiday UNIQUE (employee_id, official_holiday_id);


--
-- Name: hr_analysed_attendance_data unique_employee_shift_date; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_analysed_attendance_data
    ADD CONSTRAINT unique_employee_shift_date UNIQUE (employee_id, shift_date);


--
-- Name: day_off_weekday unique_employee_weekday_dayoff; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT unique_employee_weekday_dayoff UNIQUE (employee_id, weekday);


--
-- Name: hr_fingerprint_transactions unique_fingerprint_transaction; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_fingerprint_transactions
    ADD CONSTRAINT unique_fingerprint_transaction UNIQUE (employee_id, date, "time", status, branch_id);


--
-- Name: notification_recipients unique_notification_recipient; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT unique_notification_recipient UNIQUE (notification_id, user_id);


--
-- Name: offer_products unique_offer_product; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT unique_offer_product UNIQUE (offer_id, product_id);


--
-- Name: official_holidays unique_official_holiday_date; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.official_holidays
    ADD CONSTRAINT unique_official_holiday_date UNIQUE (holiday_date);


--
-- Name: lease_rent_property_spaces unique_property_space_number; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT unique_property_space_number UNIQUE (property_id, space_number);


--
-- Name: customer_app_media unique_slot_per_type; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_app_media
    ADD CONSTRAINT unique_slot_per_type UNIQUE (media_type, slot_number);


--
-- Name: user_favorite_buttons unique_user_favorite; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_favorite_buttons
    ADD CONSTRAINT unique_user_favorite UNIQUE (user_id);


--
-- Name: user_audit_logs user_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: user_device_sessions user_device_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_device_sessions
    ADD CONSTRAINT user_device_sessions_pkey PRIMARY KEY (id);


--
-- Name: user_device_sessions user_device_sessions_user_id_device_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_device_sessions
    ADD CONSTRAINT user_device_sessions_user_id_device_id_key UNIQUE (user_id, device_id);


--
-- Name: user_favorite_buttons user_favorite_buttons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_favorite_buttons
    ADD CONSTRAINT user_favorite_buttons_pkey PRIMARY KEY (id);


--
-- Name: user_mobile_theme_assignments user_mobile_theme_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_pkey PRIMARY KEY (id);


--
-- Name: user_mobile_theme_assignments user_mobile_theme_assignments_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_user_id_key UNIQUE (user_id);


--
-- Name: user_password_history user_password_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_password_history
    ADD CONSTRAINT user_password_history_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_session_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_session_token_key UNIQUE (session_token);


--
-- Name: user_theme_assignments user_theme_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_pkey PRIMARY KEY (id);


--
-- Name: user_theme_assignments user_theme_assignments_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_user_id_key UNIQUE (user_id);


--
-- Name: user_voice_preferences user_voice_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_voice_preferences
    ADD CONSTRAINT user_voice_preferences_pkey PRIMARY KEY (id);


--
-- Name: user_voice_preferences user_voice_preferences_user_id_locale_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_voice_preferences
    ADD CONSTRAINT user_voice_preferences_user_id_locale_key UNIQUE (user_id, locale);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_quick_access_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_quick_access_code_key UNIQUE (quick_access_code);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: variation_audit_log variation_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variation_audit_log
    ADD CONSTRAINT variation_audit_log_pkey PRIMARY KEY (id);


--
-- Name: vendor_payment_schedule vendor_payment_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_erp_vendor_branch_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_erp_vendor_branch_unique UNIQUE (erp_vendor_id, branch_id);


--
-- Name: CONSTRAINT vendors_erp_vendor_branch_unique ON vendors; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT vendors_erp_vendor_branch_unique ON public.vendors IS 'Ensures ERP vendor ID is unique within each branch, allowing same vendor ID across different branches';


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (erp_vendor_id, branch_id);


--
-- Name: view_offer view_offer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.view_offer
    ADD CONSTRAINT view_offer_pkey PRIMARY KEY (id);


--
-- Name: wa_accounts wa_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_accounts
    ADD CONSTRAINT wa_accounts_pkey PRIMARY KEY (id);


--
-- Name: wa_ai_bot_config wa_ai_bot_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_ai_bot_config
    ADD CONSTRAINT wa_ai_bot_config_pkey PRIMARY KEY (id);


--
-- Name: wa_auto_reply_triggers wa_auto_reply_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_pkey PRIMARY KEY (id);


--
-- Name: wa_bot_flows wa_bot_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_bot_flows
    ADD CONSTRAINT wa_bot_flows_pkey PRIMARY KEY (id);


--
-- Name: wa_broadcast_recipients wa_broadcast_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_pkey PRIMARY KEY (id);


--
-- Name: wa_broadcasts wa_broadcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_pkey PRIMARY KEY (id);


--
-- Name: wa_catalog_orders wa_catalog_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_pkey PRIMARY KEY (id);


--
-- Name: wa_catalog_products wa_catalog_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_pkey PRIMARY KEY (id);


--
-- Name: wa_catalogs wa_catalogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalogs
    ADD CONSTRAINT wa_catalogs_pkey PRIMARY KEY (id);


--
-- Name: wa_contact_group_members wa_contact_group_members_group_id_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_group_id_customer_id_key UNIQUE (group_id, customer_id);


--
-- Name: wa_contact_group_members wa_contact_group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_pkey PRIMARY KEY (id);


--
-- Name: wa_contact_groups wa_contact_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_groups
    ADD CONSTRAINT wa_contact_groups_pkey PRIMARY KEY (id);


--
-- Name: wa_conversations wa_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_conversations
    ADD CONSTRAINT wa_conversations_pkey PRIMARY KEY (id);


--
-- Name: wa_messages wa_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_pkey PRIMARY KEY (id);


--
-- Name: wa_settings wa_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_settings
    ADD CONSTRAINT wa_settings_pkey PRIMARY KEY (id);


--
-- Name: wa_settings wa_settings_wa_account_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_settings
    ADD CONSTRAINT wa_settings_wa_account_id_unique UNIQUE (wa_account_id);


--
-- Name: wa_templates wa_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_templates
    ADD CONSTRAINT wa_templates_pkey PRIMARY KEY (id);


--
-- Name: warning_main_category warning_main_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_main_category
    ADD CONSTRAINT warning_main_category_pkey PRIMARY KEY (id);


--
-- Name: warning_sub_category warning_sub_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_sub_category
    ADD CONSTRAINT warning_sub_category_pkey PRIMARY KEY (id);


--
-- Name: warning_violation warning_violation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_message_log whatsapp_message_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_message_log
    ADD CONSTRAINT whatsapp_message_log_pkey PRIMARY KEY (id);


--
-- Name: idx_access_code_otp_expires; Type: INDEX; Schema: public; Owner: -
--

