Owner: supabase_admin
--

ALTER TABLE ONLY public.access_code_otp
    ADD CONSTRAINT access_code_otp_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.ai_chat_guide
    ADD CONSTRAINT ai_chat_guide_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_icon_key_key UNIQUE (icon_key);

Owner: supabase_admin
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_user_id_key UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_user_id_branch_id_key UNIQUE (user_id, branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_user_id_key UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.asset_sub_categories
    ADD CONSTRAINT asset_items_group_code_name_en_key UNIQUE (group_code, name_en);

Owner: supabase_admin
--

ALTER TABLE ONLY public.asset_sub_categories
    ADD CONSTRAINT asset_items_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_group_code_key UNIQUE (group_code);

Owner: supabase_admin
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_name_en_key UNIQUE (name_en);

Owner: supabase_admin
--

ALTER TABLE ONLY public.asset_main_categories
    ADD CONSTRAINT asset_main_categories_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_asset_id_key UNIQUE (asset_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT biometric_connections_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_delivery_receivers
    ADD CONSTRAINT branch_default_delivery_receivers_branch_id_user_id_key UNIQUE (branch_id, user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_delivery_receivers
    ADD CONSTRAINT branch_default_delivery_receivers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_id_key UNIQUE (branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_sync_config
    ADD CONSTRAINT branch_sync_config_branch_id_key UNIQUE (branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_sync_config
    ADD CONSTRAINT branch_sync_config_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.break_reasons
    ADD CONSTRAINT break_reasons_name_en_unique UNIQUE (name_en);

Owner: supabase_admin
--

ALTER TABLE ONLY public.break_reasons
    ADD CONSTRAINT break_reasons_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.break_register
    ADD CONSTRAINT break_register_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.break_security_seed
    ADD CONSTRAINT break_security_seed_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_main_sections
    ADD CONSTRAINT button_main_sections_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_main_sections
    ADD CONSTRAINT button_main_sections_section_code_key UNIQUE (section_code);

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT button_permissions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT button_permissions_user_id_button_id_key UNIQUE (user_id, button_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_sub_sections
    ADD CONSTRAINT button_sub_sections_main_section_id_subsection_code_key UNIQUE (main_section_id, subsection_code);

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_sub_sections
    ADD CONSTRAINT button_sub_sections_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_campaigns
    ADD CONSTRAINT coupon_campaigns_campaign_code_key UNIQUE (campaign_code);

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_campaigns
    ADD CONSTRAINT coupon_campaigns_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT coupon_eligible_customers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_campaign_barcode_unique UNIQUE (campaign_id, special_barcode);

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_app_media
    ADD CONSTRAINT customer_app_media_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_recovery_requests
    ADD CONSTRAINT customer_recovery_requests_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_access_code_key UNIQUE (access_code);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_whatsapp_number_unique UNIQUE (whatsapp_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off_reasons
    ADD CONSTRAINT day_off_reasons_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off_reasons
    ADD CONSTRAINT day_off_reasons_reason_en_reason_ar_key UNIQUE (reason_en, reason_ar);

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT day_off_weekday_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.default_incident_users
    ADD CONSTRAINT default_incident_users_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.default_incident_users
    ADD CONSTRAINT default_incident_users_user_id_incident_type_id_key UNIQUE (user_id, incident_type_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_original_offer_id_key UNIQUE (original_offer_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.delivery_service_settings
    ADD CONSTRAINT delivery_service_settings_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_audit_log
    ADD CONSTRAINT denomination_audit_log_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_types
    ADD CONSTRAINT denomination_types_code_key UNIQUE (code);

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_types
    ADD CONSTRAINT denomination_types_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_user_id_key UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.desktop_themes
    ADD CONSTRAINT desktop_themes_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.edge_functions_cache
    ADD CONSTRAINT edge_functions_cache_pkey PRIMARY KEY (func_name);

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_fine_payments
    ADD CONSTRAINT employee_fine_payments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_official_holidays
    ADD CONSTRAINT employee_official_holidays_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_connections
    ADD CONSTRAINT erp_connections_branch_id_key UNIQUE (branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_connections
    ADD CONSTRAINT erp_connections_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_branch_id_sale_date_key UNIQUE (branch_id, sale_date);

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_sync_logs
    ADD CONSTRAINT erp_sync_logs_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_synced_products
    ADD CONSTRAINT erp_synced_products_barcode_key UNIQUE (barcode);

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_synced_products
    ADD CONSTRAINT erp_synced_products_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_parent_categories
    ADD CONSTRAINT expense_parent_categories_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_requisition_number_key UNIQUE (requisition_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT expense_scheduler_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_sub_categories
    ADD CONSTRAINT expense_sub_categories_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_offer_id_product_barcode_key UNIQUE (offer_id, product_barcode);

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_template_id_key UNIQUE (template_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_pkey1 PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_name_unique UNIQUE (name);

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.frontend_builds
    ADD CONSTRAINT frontend_builds_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_analysed_attendance_data
    ADD CONSTRAINT hr_analysed_attendance_data_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_basic_salary
    ADD CONSTRAINT hr_basic_salary_pkey PRIMARY KEY (employee_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_checklist_questions
    ADD CONSTRAINT hr_checklist_questions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_checklists
    ADD CONSTRAINT hr_checklists_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_departments
    ADD CONSTRAINT hr_departments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_user_id_key UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_employee_id_branch_id_unique UNIQUE (employee_id, branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_fingerprint_transactions
    ADD CONSTRAINT hr_fingerprint_transactions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_insurance_companies
    ADD CONSTRAINT hr_insurance_companies_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_levels
    ADD CONSTRAINT hr_levels_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_subordinate_position_id_key UNIQUE (subordinate_position_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_positions
    ADD CONSTRAINT hr_positions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incident_actions
    ADD CONSTRAINT incident_actions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_incident_type_ar_key UNIQUE (incident_type_ar);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_incident_type_en_key UNIQUE (incident_type_en);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.interface_permissions
    ADD CONSTRAINT interface_permissions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.interface_permissions
    ADD CONSTRAINT interface_permissions_user_unique UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_payment_entries
    ADD CONSTRAINT lease_rent_payment_entries_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_payments
    ADD CONSTRAINT lease_rent_payments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_payments
    ADD CONSTRAINT lease_rent_payments_unique_period UNIQUE (party_type, party_id, period_num);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_properties
    ADD CONSTRAINT lease_rent_property_spaces_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT lease_rent_property_spaces_pkey1 PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_special_changes
    ADD CONSTRAINT lease_rent_special_changes_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_name_key UNIQUE (name);

Owner: supabase_admin
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_date_wise
    ADD CONSTRAINT multi_shift_date_wise_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_regular
    ADD CONSTRAINT multi_shift_regular_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_weekday
    ADD CONSTRAINT multi_shift_weekday_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.nationalities
    ADD CONSTRAINT nationalities_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT non_approved_payment_scheduler_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_attachments
    ADD CONSTRAINT notification_attachments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_read_states
    ADD CONSTRAINT notification_read_states_notification_id_user_id_key UNIQUE (notification_id, user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_read_states
    ADD CONSTRAINT notification_read_states_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_bundles
    ADD CONSTRAINT offer_bundles_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_cart_tiers
    ADD CONSTRAINT offer_cart_tiers_offer_id_min_amount_key UNIQUE (offer_id, min_amount);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_cart_tiers
    ADD CONSTRAINT offer_cart_tiers_offer_id_tier_number_key UNIQUE (offer_id, tier_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_cart_tiers
    ADD CONSTRAINT offer_cart_tiers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_names
    ADD CONSTRAINT offer_names_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT offer_products_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.official_holidays
    ADD CONSTRAINT official_holidays_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_employee_id_overtime_date_key UNIQUE (employee_id, overtime_date);

Owner: supabase_admin
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_pkey PRIMARY KEY (id, box_number, date_closed_box);

Owner: supabase_admin
--

ALTER TABLE ONLY public.privilege_cards_branch
    ADD CONSTRAINT privilege_cards_branch_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.privilege_cards_branch
    ADD CONSTRAINT privilege_cards_branch_privilege_card_id_branch_id_key UNIQUE (privilege_card_id, branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.privilege_cards_master
    ADD CONSTRAINT privilege_cards_master_card_number_key UNIQUE (card_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.privilege_cards_master
    ADD CONSTRAINT privilege_cards_master_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.processed_fingerprint_transactions
    ADD CONSTRAINT processed_fingerprint_transactions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_st
    ADD CONSTRAINT product_request_st_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_units
    ADD CONSTRAINT product_units_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_issue_types
    ADD CONSTRAINT purchase_voucher_issue_types_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_issue_types
    ADD CONSTRAINT purchase_voucher_issue_types_type_name_key UNIQUE (type_name);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_purchase_voucher_id_serial_number_key UNIQUE (purchase_voucher_id, serial_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_vouchers
    ADD CONSTRAINT purchase_vouchers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT push_subscriptions_endpoint_key UNIQUE (endpoint);

Owner: supabase_admin
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT push_subscriptions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_quick_task_id_assigned_to_user_id_key UNIQUE (quick_task_id, assigned_to_user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_assignment_unique UNIQUE (assignment_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_user_id_key UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_task_templates
    ADD CONSTRAINT receiving_task_templates_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_task_templates
    ADD CONSTRAINT receiving_task_templates_role_type_unique UNIQUE (role_type);

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_user_id_key UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.recurring_assignment_schedules
    ADD CONSTRAINT recurring_assignment_schedules_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.recurring_schedule_check_log
    ADD CONSTRAINT recurring_schedule_check_log_check_date_key UNIQUE (check_date);

Owner: supabase_admin
--

ALTER TABLE ONLY public.recurring_schedule_check_log
    ADD CONSTRAINT recurring_schedule_check_log_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.regular_shift
    ADD CONSTRAINT regular_shift_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.requesters
    ADD CONSTRAINT requesters_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.requesters
    ADD CONSTRAINT requesters_requester_id_key UNIQUE (requester_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.security_code_scroll_texts
    ADD CONSTRAINT security_code_scroll_texts_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.shelf_paper_fonts
    ADD CONSTRAINT shelf_paper_fonts_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.shelf_paper_templates
    ADD CONSTRAINT shelf_paper_templates_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT sidebar_buttons_main_section_id_subsection_id_button_code_key UNIQUE (main_section_id, subsection_id, button_code);

Owner: supabase_admin
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT sidebar_buttons_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT social_links_branch_id_key UNIQUE (branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT social_links_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT special_shift_date_wise_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_employee_id_weekday_key UNIQUE (employee_id, weekday);

Owner: supabase_admin
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.system_api_keys
    ADD CONSTRAINT system_api_keys_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.system_api_keys
    ADD CONSTRAINT system_api_keys_service_name_key UNIQUE (service_name);

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_task_id_assignment_type_assigned_to_user_i_key UNIQUE (task_id, assignment_type, assigned_to_user_id, assigned_to_branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_images
    ADD CONSTRAINT task_images_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT unique_branch_device UNIQUE (branch_id, device_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT unique_customer_campaign UNIQUE (campaign_id, mobile_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT unique_employee_date UNIQUE (employee_id, shift_date);

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT unique_employee_day_off UNIQUE (employee_id, day_off_date);

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_official_holidays
    ADD CONSTRAINT unique_employee_official_holiday UNIQUE (employee_id, official_holiday_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_analysed_attendance_data
    ADD CONSTRAINT unique_employee_shift_date UNIQUE (employee_id, shift_date);

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT unique_employee_weekday_dayoff UNIQUE (employee_id, weekday);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_fingerprint_transactions
    ADD CONSTRAINT unique_fingerprint_transaction UNIQUE (employee_id, date, "time", status, branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT unique_notification_recipient UNIQUE (notification_id, user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT unique_offer_product UNIQUE (offer_id, product_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.official_holidays
    ADD CONSTRAINT unique_official_holiday_date UNIQUE (holiday_date);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT unique_property_space_number UNIQUE (property_id, space_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_app_media
    ADD CONSTRAINT unique_slot_per_type UNIQUE (media_type, slot_number);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_favorite_buttons
    ADD CONSTRAINT unique_user_favorite UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_device_sessions
    ADD CONSTRAINT user_device_sessions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_device_sessions
    ADD CONSTRAINT user_device_sessions_user_id_device_id_key UNIQUE (user_id, device_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_favorite_buttons
    ADD CONSTRAINT user_favorite_buttons_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_user_id_key UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_password_history
    ADD CONSTRAINT user_password_history_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_session_token_key UNIQUE (session_token);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_user_id_key UNIQUE (user_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_voice_preferences
    ADD CONSTRAINT user_voice_preferences_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_voice_preferences
    ADD CONSTRAINT user_voice_preferences_user_id_locale_key UNIQUE (user_id, locale);

Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_quick_access_code_key UNIQUE (quick_access_code);

Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);

Owner: supabase_admin
--

ALTER TABLE ONLY public.variation_audit_log
    ADD CONSTRAINT variation_audit_log_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_erp_vendor_branch_unique UNIQUE (erp_vendor_id, branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (erp_vendor_id, branch_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.view_offer
    ADD CONSTRAINT view_offer_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_accounts
    ADD CONSTRAINT wa_accounts_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_ai_bot_config
    ADD CONSTRAINT wa_ai_bot_config_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_bot_flows
    ADD CONSTRAINT wa_bot_flows_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_catalogs
    ADD CONSTRAINT wa_catalogs_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_group_id_customer_id_key UNIQUE (group_id, customer_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_contact_groups
    ADD CONSTRAINT wa_contact_groups_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_conversations
    ADD CONSTRAINT wa_conversations_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_settings
    ADD CONSTRAINT wa_settings_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_settings
    ADD CONSTRAINT wa_settings_wa_account_id_unique UNIQUE (wa_account_id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_templates
    ADD CONSTRAINT wa_templates_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.warning_main_category
    ADD CONSTRAINT warning_main_category_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.warning_sub_category
    ADD CONSTRAINT warning_sub_category_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.whatsapp_message_log
    ADD CONSTRAINT whatsapp_message_log_pkey PRIMARY KEY (id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.access_code_otp
    ADD CONSTRAINT access_code_otp_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.ai_chat_guide
    ADD CONSTRAINT ai_chat_guide_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.asset_sub_categories
    ADD CONSTRAINT asset_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.asset_main_categories(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.asset_sub_categories(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_operation_id_fkey FOREIGN KEY (operation_id) REFERENCES public.box_operations(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT biometric_connections_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_buy_product_id_fkey FOREIGN KEY (buy_product_id) REFERENCES public.products(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_get_product_id_fkey FOREIGN KEY (get_product_id) REFERENCES public.products(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_denomination_record_id_fkey FOREIGN KEY (denomination_record_id) REFERENCES public.denomination_records(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_delivery_receivers
    ADD CONSTRAINT branch_default_delivery_receivers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_delivery_receivers
    ADD CONSTRAINT branch_default_delivery_receivers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_accountant_user_id_fkey FOREIGN KEY (accountant_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_manager_user_id_fkey FOREIGN KEY (branch_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_inventory_manager_user_id_fkey FOREIGN KEY (inventory_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_purchasing_manager_user_id_fkey FOREIGN KEY (purchasing_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_warehouse_handler_user_id_fkey FOREIGN KEY (warehouse_handler_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.branch_sync_config
    ADD CONSTRAINT branch_sync_config_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.break_register
    ADD CONSTRAINT break_register_reason_id_fkey FOREIGN KEY (reason_id) REFERENCES public.break_reasons(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_campaigns
    ADD CONSTRAINT coupon_campaigns_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.coupon_campaigns(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_claimed_by_user_fkey FOREIGN KEY (claimed_by_user) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.coupon_products(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT coupon_eligible_customers_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.coupon_campaigns(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT coupon_eligible_customers_imported_by_fkey FOREIGN KEY (imported_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.coupon_campaigns(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_product_id_fkey FOREIGN KEY (flyer_product_id) REFERENCES public.products(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_generated_by_fkey FOREIGN KEY (generated_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_app_media
    ADD CONSTRAINT customer_app_media_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_recovery_requests
    ADD CONSTRAINT customer_recovery_requests_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.customer_recovery_requests
    ADD CONSTRAINT customer_recovery_requests_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_approval_approved_by_fkey FOREIGN KEY (approval_approved_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_approval_requested_by_fkey FOREIGN KEY (approval_requested_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_day_off_reason_id_fkey FOREIGN KEY (day_off_reason_id) REFERENCES public.day_off_reasons(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT day_off_weekday_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.default_incident_users
    ADD CONSTRAINT default_incident_users_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.default_incident_users
    ADD CONSTRAINT default_incident_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.delivery_service_settings
    ADD CONSTRAINT delivery_service_settings_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.desktop_themes
    ADD CONSTRAINT desktop_themes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.hr_checklists(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_fine_payments
    ADD CONSTRAINT employee_fine_payments_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_official_holidays
    ADD CONSTRAINT employee_official_holidays_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_official_holidays
    ADD CONSTRAINT employee_official_holidays_official_holiday_id_fkey FOREIGN KEY (official_holiday_id) REFERENCES public.official_holidays(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_connections
    ADD CONSTRAINT erp_connections_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_expense_category_id_fkey FOREIGN KEY (expense_category_id) REFERENCES public.expense_sub_categories(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_internal_user_id_fkey FOREIGN KEY (internal_user_id) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_requester_ref_id_fkey FOREIGN KEY (requester_ref_id) REFERENCES public.requesters(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_sub_categories
    ADD CONSTRAINT expense_sub_categories_parent_category_id_fkey FOREIGN KEY (parent_category_id) REFERENCES public.expense_parent_categories(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_analysed_attendance_data
    ADD CONSTRAINT fk_analysed_employee FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT fk_button FOREIGN KEY (button_id) REFERENCES public.sidebar_buttons(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT fk_expense_requisitions_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_approver FOREIGN KEY (approver_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_category FOREIGN KEY (expense_category_id) REFERENCES public.expense_sub_categories(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_co_user FOREIGN KEY (co_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_created_by FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_requisition FOREIGN KEY (requisition_id) REFERENCES public.expense_requisitions(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_sub_sections
    ADD CONSTRAINT fk_main_section FOREIGN KEY (main_section_id) REFERENCES public.button_main_sections(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT fk_main_section FOREIGN KEY (main_section_id) REFERENCES public.button_main_sections(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_approved_by FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_approver FOREIGN KEY (approver_id) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_category FOREIGN KEY (expense_category_id) REFERENCES public.expense_sub_categories(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_co_user FOREIGN KEY (co_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_created_by FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_expense_scheduler FOREIGN KEY (expense_scheduler_id) REFERENCES public.expense_scheduler(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT fk_notification_recipients_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT fk_push_sub_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.recurring_assignment_schedules
    ADD CONSTRAINT fk_recurring_schedules_assignment FOREIGN KEY (assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT fk_social_links_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT fk_sub_section FOREIGN KEY (subsection_id) REFERENCES public.button_sub_sections(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT fk_task_assignments_reassigned_from FOREIGN KEY (reassigned_from) REFERENCES public.task_assignments(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.flyer_offers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_product_barcode_fkey FOREIGN KEY (product_barcode) REFERENCES public.products(barcode) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_offer_name_id_fkey FOREIGN KEY (offer_name_id) REFERENCES public.offer_names(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_created_by_fkey1 FOREIGN KEY (created_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_modified_by_fkey1 FOREIGN KEY (modified_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.product_units(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.frontend_builds
    ADD CONSTRAINT frontend_builds_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_basic_salary
    ADD CONSTRAINT hr_basic_salary_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_box_operation_id_fkey FOREIGN KEY (box_operation_id) REFERENCES public.box_operations(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.hr_checklists(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_current_branch_id_fkey FOREIGN KEY (current_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_current_position_id_fkey FOREIGN KEY (current_position_id) REFERENCES public.hr_positions(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_nationality_id_fkey FOREIGN KEY (nationality_id) REFERENCES public.nationalities(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_fingerprint_transactions
    ADD CONSTRAINT hr_fingerprint_transactions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.hr_departments(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employees(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_level_id_fkey FOREIGN KEY (level_id) REFERENCES public.hr_levels(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.hr_positions(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_1_fkey FOREIGN KEY (manager_position_1) REFERENCES public.hr_positions(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_2_fkey FOREIGN KEY (manager_position_2) REFERENCES public.hr_positions(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_3_fkey FOREIGN KEY (manager_position_3) REFERENCES public.hr_positions(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_4_fkey FOREIGN KEY (manager_position_4) REFERENCES public.hr_positions(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_5_fkey FOREIGN KEY (manager_position_5) REFERENCES public.hr_positions(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_subordinate_position_id_fkey FOREIGN KEY (subordinate_position_id) REFERENCES public.hr_positions(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_positions
    ADD CONSTRAINT hr_positions_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.hr_departments(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_positions
    ADD CONSTRAINT hr_positions_level_id_fkey FOREIGN KEY (level_id) REFERENCES public.hr_levels(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incident_actions
    ADD CONSTRAINT incident_actions_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.incident_actions
    ADD CONSTRAINT incident_actions_incident_type_id_fkey FOREIGN KEY (incident_type_id) REFERENCES public.incident_types(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_incident_type_id_fkey FOREIGN KEY (incident_type_id) REFERENCES public.incident_types(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_violation_id_fkey FOREIGN KEY (violation_id) REFERENCES public.warning_violation(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.interface_permissions
    ADD CONSTRAINT interface_permissions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.interface_permissions
    ADD CONSTRAINT interface_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.lease_rent_properties(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_property_space_id_fkey FOREIGN KEY (property_space_id) REFERENCES public.lease_rent_property_spaces(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_payments
    ADD CONSTRAINT lease_rent_payments_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_properties
    ADD CONSTRAINT lease_rent_property_spaces_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT lease_rent_property_spaces_created_by_fkey1 FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT lease_rent_property_spaces_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.lease_rent_properties(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.lease_rent_properties(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_property_space_id_fkey FOREIGN KEY (property_space_id) REFERENCES public.lease_rent_property_spaces(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.lease_rent_special_changes
    ADD CONSTRAINT lease_rent_special_changes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_date_wise
    ADD CONSTRAINT multi_shift_date_wise_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_regular
    ADD CONSTRAINT multi_shift_regular_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_weekday
    ADD CONSTRAINT multi_shift_weekday_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_reporter_user_id_fkey FOREIGN KEY (reporter_user_id) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_attachments
    ADD CONSTRAINT notification_attachments_notification_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_read_states
    ADD CONSTRAINT notification_read_states_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_notification_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_task_assignment_id_fkey FOREIGN KEY (task_assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_bundles
    ADD CONSTRAINT offer_bundles_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_cart_tiers
    ADD CONSTRAINT offer_cart_tiers_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT offer_products_added_by_fkey FOREIGN KEY (added_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT offer_products_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT offer_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_assigned_user_id_fkey FOREIGN KEY (assigned_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.product_units(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_cancelled_by_fkey FOREIGN KEY (cancelled_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_delivery_person_id_fkey FOREIGN KEY (delivery_person_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_picker_id_fkey FOREIGN KEY (picker_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_box_operation_id_fkey FOREIGN KEY (box_operation_id) REFERENCES public.box_operations(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_cashier_user_id_fkey FOREIGN KEY (cashier_user_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_closed_by_fkey FOREIGN KEY (closed_by) REFERENCES auth.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_id_fkey FOREIGN KEY (id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.processed_fingerprint_transactions
    ADD CONSTRAINT processed_fingerprint_transactions_center_id_fkey FOREIGN KEY (center_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_from_branch_id_fkey FOREIGN KEY (from_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_to_branch_id_fkey FOREIGN KEY (to_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_from_branch_id_fkey FOREIGN KEY (from_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_st
    ADD CONSTRAINT product_request_st_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_st
    ADD CONSTRAINT product_request_st_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_request_st
    ADD CONSTRAINT product_request_st_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.product_units
    ADD CONSTRAINT product_units_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pending_stock_location_fkey FOREIGN KEY (pending_stock_location) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pending_stock_person_fkey FOREIGN KEY (pending_stock_person) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_purchase_voucher_id_fkey FOREIGN KEY (purchase_voucher_id) REFERENCES public.purchase_vouchers(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_stock_location_fkey FOREIGN KEY (stock_location) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_stock_person_fkey FOREIGN KEY (stock_person) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_assigned_to_user_id_fkey FOREIGN KEY (assigned_to_user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.quick_task_assignments(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_completed_by_user_id_fkey FOREIGN KEY (completed_by_user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_verified_by_user_id_fkey FOREIGN KEY (verified_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_assigned_to_branch_id_fkey FOREIGN KEY (assigned_to_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_accountant_user_id_fkey FOREIGN KEY (accountant_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_branch_manager_user_id_fkey FOREIGN KEY (branch_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_inventory_manager_user_id_fkey FOREIGN KEY (inventory_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_purchasing_manager_user_id_fkey FOREIGN KEY (purchasing_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_vendor_fkey FOREIGN KEY (vendor_id, branch_id) REFERENCES public.vendors(erp_vendor_id, branch_id) ON DELETE RESTRICT;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_assigned_user_id_fkey FOREIGN KEY (assigned_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_receiving_record_id_fkey FOREIGN KEY (receiving_record_id) REFERENCES public.receiving_records(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.receiving_task_templates(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.regular_shift
    ADD CONSTRAINT regular_shift_id_fkey FOREIGN KEY (id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.security_code_scroll_texts
    ADD CONSTRAINT security_code_scroll_texts_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.shelf_paper_templates
    ADD CONSTRAINT shelf_paper_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT special_shift_date_wise_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_to_branch_id_fkey FOREIGN KEY (assigned_to_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_to_user_id_fkey FOREIGN KEY (assigned_to_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_images
    ADD CONSTRAINT task_images_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_assigned_to_user_id_fkey FOREIGN KEY (assigned_to_user_id) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_quick_task_assignment_id_fkey FOREIGN KEY (quick_task_assignment_id) REFERENCES public.quick_task_assignments(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_task_assignment_id_fkey FOREIGN KEY (task_assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_device_sessions
    ADD CONSTRAINT user_device_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_theme_id_fkey FOREIGN KEY (theme_id) REFERENCES public.mobile_themes(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_password_history
    ADD CONSTRAINT user_password_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_theme_id_fkey FOREIGN KEY (theme_id) REFERENCES public.desktop_themes(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employees(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_locked_by_fkey FOREIGN KEY (locked_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.variation_audit_log
    ADD CONSTRAINT variation_audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_approval_requested_by_fkey FOREIGN KEY (approval_requested_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_assigned_approver_fkey FOREIGN KEY (assigned_approver_id) REFERENCES public.users(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_pr_excel_verified_by_fkey FOREIGN KEY (pr_excel_verified_by) REFERENCES public.users(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_receiving_record_id_fkey FOREIGN KEY (receiving_record_id) REFERENCES public.receiving_records(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_task_assignment_id_fkey FOREIGN KEY (task_assignment_id) REFERENCES public.task_assignments(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.view_offer
    ADD CONSTRAINT view_offer_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_follow_up_trigger_id_fkey FOREIGN KEY (follow_up_trigger_id) REFERENCES public.wa_auto_reply_triggers(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_reply_template_id_fkey FOREIGN KEY (reply_template_id) REFERENCES public.wa_templates(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_bot_flows
    ADD CONSTRAINT wa_bot_flows_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_broadcast_id_fkey FOREIGN KEY (broadcast_id) REFERENCES public.wa_broadcasts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_recipient_group_id_fkey FOREIGN KEY (recipient_group_id) REFERENCES public.wa_contact_groups(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.wa_templates(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.wa_catalogs(id);

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.wa_catalogs(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_catalogs
    ADD CONSTRAINT wa_catalogs_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.wa_contact_groups(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_conversations
    ADD CONSTRAINT wa_conversations_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_conversations
    ADD CONSTRAINT wa_conversations_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.wa_conversations(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_settings
    ADD CONSTRAINT wa_settings_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.wa_templates
    ADD CONSTRAINT wa_templates_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.warning_sub_category
    ADD CONSTRAINT warning_sub_category_main_category_id_fkey FOREIGN KEY (main_category_id) REFERENCES public.warning_main_category(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_main_category_id_fkey FOREIGN KEY (main_category_id) REFERENCES public.warning_main_category(id) ON DELETE CASCADE;

Owner: supabase_admin
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.warning_sub_category(id) ON DELETE CASCADE;