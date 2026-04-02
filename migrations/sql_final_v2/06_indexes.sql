--

CREATE INDEX IF NOT EXISTS idx_access_code_otp_expires ON public.access_code_otp USING btree (expires_at);

--

CREATE INDEX IF NOT EXISTS idx_access_code_otp_user ON public.access_code_otp USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_analysed_att_branch ON public.hr_analysed_attendance_data USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_analysed_att_date ON public.hr_analysed_attendance_data USING btree (shift_date);

--

CREATE INDEX IF NOT EXISTS idx_analysed_att_emp_date ON public.hr_analysed_attendance_data USING btree (employee_id, shift_date);

--

CREATE INDEX IF NOT EXISTS idx_analysed_att_employee_id ON public.hr_analysed_attendance_data USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_analysed_att_status ON public.hr_analysed_attendance_data USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_app_icons_category ON public.app_icons USING btree (category);

--

CREATE INDEX IF NOT EXISTS idx_app_icons_key ON public.app_icons USING btree (icon_key);

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_add_missing_punches ON public.approval_permissions USING btree (can_add_missing_punches) WHERE ((can_add_missing_punches = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_customer_incidents ON public.approval_permissions USING btree (can_receive_customer_incidents) WHERE ((can_receive_customer_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_employee_incidents ON public.approval_permissions USING btree (can_receive_employee_incidents) WHERE ((can_receive_employee_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_finance_incidents ON public.approval_permissions USING btree (can_receive_finance_incidents) WHERE ((can_receive_finance_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_government_incidents ON public.approval_permissions USING btree (can_receive_government_incidents) WHERE ((can_receive_government_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_is_active ON public.approval_permissions USING btree (is_active) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_leave_requests ON public.approval_permissions USING btree (can_approve_leave_requests) WHERE ((can_approve_leave_requests = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_maintenance_incidents ON public.approval_permissions USING btree (can_receive_maintenance_incidents) WHERE ((can_receive_maintenance_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_multiple_bill ON public.approval_permissions USING btree (can_approve_multiple_bill) WHERE ((can_approve_multiple_bill = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_other_incidents ON public.approval_permissions USING btree (can_receive_other_incidents) WHERE ((can_receive_other_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_pos_incidents ON public.approval_permissions USING btree (can_receive_pos_incidents) WHERE ((can_receive_pos_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_purchase_vouchers ON public.approval_permissions USING btree (can_approve_purchase_vouchers) WHERE ((can_approve_purchase_vouchers = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_recurring_bill ON public.approval_permissions USING btree (can_approve_recurring_bill) WHERE ((can_approve_recurring_bill = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_requisitions ON public.approval_permissions USING btree (can_approve_requisitions) WHERE ((can_approve_requisitions = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_single_bill ON public.approval_permissions USING btree (can_approve_single_bill) WHERE ((can_approve_single_bill = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_user_id ON public.approval_permissions USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_vehicle_incidents ON public.approval_permissions USING btree (can_receive_vehicle_incidents) WHERE ((can_receive_vehicle_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_vendor_incidents ON public.approval_permissions USING btree (can_receive_vendor_incidents) WHERE ((can_receive_vendor_incidents = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approval_permissions_vendor_payments ON public.approval_permissions USING btree (can_approve_vendor_payments) WHERE ((can_approve_vendor_payments = true) AND (is_active = true));

--

CREATE INDEX IF NOT EXISTS idx_approver_branch_access_active ON public.approver_branch_access USING btree (is_active) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_approver_branch_access_branch_id ON public.approver_branch_access USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_approver_branch_access_user_branch ON public.approver_branch_access USING btree (user_id, branch_id);

--

CREATE INDEX IF NOT EXISTS idx_approver_branch_access_user_id ON public.approver_branch_access USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_approver_visibility_active ON public.approver_visibility_config USING btree (is_active) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_approver_visibility_type ON public.approver_visibility_config USING btree (visibility_type);

--

CREATE INDEX IF NOT EXISTS idx_approver_visibility_user_id ON public.approver_visibility_config USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_asset_main_categories_group_code ON public.asset_main_categories USING btree (group_code);

--

CREATE INDEX IF NOT EXISTS idx_asset_main_categories_name_en ON public.asset_main_categories USING btree (name_en);

--

CREATE INDEX IF NOT EXISTS idx_asset_sub_categories_category_id ON public.asset_sub_categories USING btree (category_id);

--

CREATE INDEX IF NOT EXISTS idx_asset_sub_categories_group_code ON public.asset_sub_categories USING btree (group_code);

--

CREATE INDEX IF NOT EXISTS idx_assets_asset_id ON public.assets USING btree (asset_id);

--

CREATE INDEX IF NOT EXISTS idx_assets_branch_id ON public.assets USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_assets_sub_category_id ON public.assets USING btree (sub_category_id);

--

CREATE INDEX IF NOT EXISTS idx_bank_reconciliations_branch_id ON public.bank_reconciliations USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_bank_reconciliations_created_at ON public.bank_reconciliations USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_bank_reconciliations_operation_id ON public.bank_reconciliations USING btree (operation_id);

--

CREATE INDEX IF NOT EXISTS idx_biometric_connections_active ON public.biometric_connections USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_biometric_connections_branch ON public.biometric_connections USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_biometric_connections_device ON public.biometric_connections USING btree (device_id);

--

CREATE INDEX IF NOT EXISTS idx_biometric_connections_terminal ON public.biometric_connections USING btree (terminal_sn);

--

CREATE INDEX IF NOT EXISTS idx_bogo_offer_rules_buy_product ON public.bogo_offer_rules USING btree (buy_product_id);

--

CREATE INDEX IF NOT EXISTS idx_bogo_offer_rules_buy_product_id ON public.bogo_offer_rules USING btree (buy_product_id);

--

CREATE INDEX IF NOT EXISTS idx_bogo_offer_rules_get_product ON public.bogo_offer_rules USING btree (get_product_id);

--

CREATE INDEX IF NOT EXISTS idx_bogo_offer_rules_get_product_id ON public.bogo_offer_rules USING btree (get_product_id);

--

CREATE INDEX IF NOT EXISTS idx_bogo_offer_rules_offer_id ON public.bogo_offer_rules USING btree (offer_id);

--

CREATE INDEX IF NOT EXISTS idx_box_operations_active ON public.box_operations USING btree (branch_id, status) WHERE ((status)::text = 'in_use'::text);

--

CREATE INDEX IF NOT EXISTS idx_box_operations_box ON public.box_operations USING btree (box_number);

--

CREATE INDEX IF NOT EXISTS idx_box_operations_branch ON public.box_operations USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_box_operations_denomination ON public.box_operations USING btree (denomination_record_id);

--

CREATE INDEX IF NOT EXISTS idx_box_operations_pos_before_url ON public.box_operations USING btree (pos_before_url);

--

CREATE INDEX IF NOT EXISTS idx_box_operations_start_time ON public.box_operations USING btree (start_time DESC);

--

CREATE INDEX IF NOT EXISTS idx_box_operations_status ON public.box_operations USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_box_operations_user ON public.box_operations USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_branch_default_positions_branch_id ON public.branch_default_positions USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_branch_delivery_receivers_branch ON public.branch_default_delivery_receivers USING btree (branch_id) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_branch_delivery_receivers_user ON public.branch_default_delivery_receivers USING btree (user_id) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_branches_active ON public.branches USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_branches_main ON public.branches USING btree (is_main_branch);

--

CREATE INDEX IF NOT EXISTS idx_branches_name_ar ON public.branches USING btree (name_ar);

--

CREATE INDEX IF NOT EXISTS idx_branches_name_en ON public.branches USING btree (name_en);

--

CREATE INDEX IF NOT EXISTS idx_branches_vat_number ON public.branches USING btree (vat_number) WHERE (vat_number IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_break_register_employee ON public.break_register USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_break_register_start ON public.break_register USING btree (start_time DESC);

--

CREATE INDEX IF NOT EXISTS idx_break_register_user_status ON public.break_register USING btree (user_id, status);

--

CREATE INDEX IF NOT EXISTS idx_button_main_sections_active ON public.button_main_sections USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_button_permissions_button ON public.button_permissions USING btree (button_id);

--

CREATE INDEX IF NOT EXISTS idx_button_permissions_user ON public.button_permissions USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_button_sub_sections_active ON public.button_sub_sections USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_button_sub_sections_main ON public.button_sub_sections USING btree (main_section_id);

--

CREATE INDEX IF NOT EXISTS idx_campaigns_active ON public.coupon_campaigns USING btree (is_active) WHERE (deleted_at IS NULL);

--

CREATE INDEX IF NOT EXISTS idx_campaigns_code ON public.coupon_campaigns USING btree (campaign_code);

--

CREATE INDEX IF NOT EXISTS idx_campaigns_validity ON public.coupon_campaigns USING btree (validity_start_date, validity_end_date);

--

CREATE INDEX IF NOT EXISTS idx_checklist_operations_submission_type_en ON public.hr_checklist_operations USING btree (submission_type_en);

--

CREATE INDEX IF NOT EXISTS idx_coupon_claims_branch ON public.coupon_claims USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_coupon_claims_campaign ON public.coupon_claims USING btree (campaign_id);

--

CREATE INDEX IF NOT EXISTS idx_coupon_claims_customer_campaign ON public.coupon_claims USING btree (campaign_id, customer_mobile);

--

CREATE INDEX IF NOT EXISTS idx_coupon_claims_date ON public.coupon_claims USING btree (claimed_at);

--

CREATE INDEX IF NOT EXISTS idx_coupon_claims_mobile ON public.coupon_claims USING btree (customer_mobile);

--

CREATE INDEX IF NOT EXISTS idx_coupon_claims_product ON public.coupon_claims USING btree (product_id);

--

CREATE INDEX IF NOT EXISTS idx_coupon_products_barcode ON public.coupon_products USING btree (special_barcode);

--

CREATE INDEX IF NOT EXISTS idx_coupon_products_campaign ON public.coupon_products USING btree (campaign_id);

--

CREATE INDEX IF NOT EXISTS idx_coupon_products_stock ON public.coupon_products USING btree (stock_remaining) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_customer_access_code_history_created_at ON public.customer_access_code_history USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_customer_access_code_history_customer_id ON public.customer_access_code_history USING btree (customer_id);

--

CREATE INDEX IF NOT EXISTS idx_customer_access_code_history_generated_by ON public.customer_access_code_history USING btree (generated_by);

--

CREATE INDEX IF NOT EXISTS idx_customer_app_media_active ON public.customer_app_media USING btree (is_active) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_customer_app_media_display_order ON public.customer_app_media USING btree (display_order);

--

CREATE INDEX IF NOT EXISTS idx_customer_app_media_expiry ON public.customer_app_media USING btree (expiry_date) WHERE (expiry_date IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_customer_app_media_type ON public.customer_app_media USING btree (media_type);

--

CREATE INDEX IF NOT EXISTS idx_customer_product_requests_branch ON public.customer_product_requests USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_customer_product_requests_requester ON public.customer_product_requests USING btree (requester_user_id);

--

CREATE INDEX IF NOT EXISTS idx_customer_product_requests_status ON public.customer_product_requests USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_customer_product_requests_target ON public.customer_product_requests USING btree (target_user_id);

--

CREATE INDEX IF NOT EXISTS idx_customer_recovery_requests_created_at ON public.customer_recovery_requests USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_customer_recovery_requests_customer_id ON public.customer_recovery_requests USING btree (customer_id);

--

CREATE INDEX IF NOT EXISTS idx_customer_recovery_requests_processed_by ON public.customer_recovery_requests USING btree (processed_by);

--

CREATE INDEX IF NOT EXISTS idx_customer_recovery_requests_request_type ON public.customer_recovery_requests USING btree (request_type);

--

CREATE INDEX IF NOT EXISTS idx_customer_recovery_requests_verification_status ON public.customer_recovery_requests USING btree (verification_status);

--

CREATE INDEX IF NOT EXISTS idx_customer_recovery_requests_whatsapp ON public.customer_recovery_requests USING btree (whatsapp_number);

--

CREATE INDEX IF NOT EXISTS idx_customers_access_code ON public.customers USING btree (access_code) WHERE (access_code IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_customers_approved_by ON public.customers USING btree (approved_by);

--

CREATE INDEX IF NOT EXISTS idx_customers_is_deleted ON public.customers USING btree (is_deleted) WHERE (is_deleted = true);

--

CREATE INDEX IF NOT EXISTS idx_customers_registration_status ON public.customers USING btree (registration_status);

--

CREATE INDEX IF NOT EXISTS idx_customers_whatsapp ON public.customers USING btree (whatsapp_number) WHERE (whatsapp_number IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_day_off_approval_requested_by ON public.day_off USING btree (approval_requested_by);

--

CREATE INDEX IF NOT EXISTS idx_day_off_approval_status ON public.day_off USING btree (approval_status);

--

CREATE INDEX IF NOT EXISTS idx_day_off_date ON public.day_off USING btree (day_off_date);

--

CREATE INDEX IF NOT EXISTS idx_day_off_description ON public.day_off USING btree (description);

--

CREATE INDEX IF NOT EXISTS idx_day_off_employee_id ON public.day_off USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_day_off_reason_id ON public.day_off USING btree (day_off_reason_id);

--

CREATE INDEX IF NOT EXISTS idx_day_off_reasons_deductible ON public.day_off_reasons USING btree (is_deductible);

--

CREATE INDEX IF NOT EXISTS idx_day_off_reasons_document_mandatory ON public.day_off_reasons USING btree (is_document_mandatory);

--

CREATE INDEX IF NOT EXISTS idx_day_off_weekday_employee_id ON public.day_off_weekday USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_day_off_weekday_weekday ON public.day_off_weekday USING btree (weekday);

--

CREATE INDEX IF NOT EXISTS idx_default_incident_users_type ON public.default_incident_users USING btree (incident_type_id);

--

CREATE INDEX IF NOT EXISTS idx_default_incident_users_user ON public.default_incident_users USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_deleted_bundle_offers_deleted_at ON public.deleted_bundle_offers USING btree (deleted_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_deleted_bundle_offers_deleted_by ON public.deleted_bundle_offers USING btree (deleted_by);

--

CREATE INDEX IF NOT EXISTS idx_deleted_bundle_offers_original_id ON public.deleted_bundle_offers USING btree (original_offer_id);

--

CREATE INDEX IF NOT EXISTS idx_delivery_tiers_active ON public.delivery_fee_tiers USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_delivery_tiers_branch_order ON public.delivery_fee_tiers USING btree (branch_id, tier_order);

--

CREATE INDEX IF NOT EXISTS idx_delivery_tiers_branch_order_amount ON public.delivery_fee_tiers USING btree (branch_id, min_order_amount, max_order_amount) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_delivery_tiers_order ON public.delivery_fee_tiers USING btree (tier_order);

--

CREATE INDEX IF NOT EXISTS idx_delivery_tiers_order_amount ON public.delivery_fee_tiers USING btree (min_order_amount, max_order_amount);

--

CREATE INDEX IF NOT EXISTS idx_denomination_audit_action ON public.denomination_audit_log USING btree (action);

--

CREATE INDEX IF NOT EXISTS idx_denomination_audit_branch ON public.denomination_audit_log USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_denomination_audit_created ON public.denomination_audit_log USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_denomination_audit_record ON public.denomination_audit_log USING btree (record_id);

--

CREATE INDEX IF NOT EXISTS idx_denomination_audit_user ON public.denomination_audit_log USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_denomination_records_branch ON public.denomination_records USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_denomination_records_branch_created ON public.denomination_records USING btree (branch_id, created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_denomination_records_branch_type ON public.denomination_records USING btree (branch_id, record_type);

--

CREATE INDEX IF NOT EXISTS idx_denomination_records_created_at ON public.denomination_records USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_denomination_records_history ON public.denomination_records USING btree (branch_id, record_type, created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_denomination_records_petty_cash_operation ON public.denomination_records USING gin (petty_cash_operation);

--

CREATE INDEX IF NOT EXISTS idx_denomination_records_type ON public.denomination_records USING btree (record_type);

--

CREATE INDEX IF NOT EXISTS idx_denomination_records_user ON public.denomination_records USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_denomination_transactions_branch_id ON public.denomination_transactions USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_denomination_transactions_branch_section ON public.denomination_transactions USING btree (branch_id, section);

--

CREATE INDEX IF NOT EXISTS idx_denomination_transactions_created_at ON public.denomination_transactions USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_denomination_transactions_section ON public.denomination_transactions USING btree (section);

--

CREATE INDEX IF NOT EXISTS idx_denomination_transactions_type ON public.denomination_transactions USING btree (transaction_type);

--

CREATE INDEX IF NOT EXISTS idx_denomination_types_active ON public.denomination_types USING btree (is_active, sort_order);

--

CREATE INDEX IF NOT EXISTS idx_denomination_user_preferences_user_id ON public.denomination_user_preferences USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_desktop_themes_is_default ON public.desktop_themes USING btree (is_default);

--

CREATE INDEX IF NOT EXISTS idx_eligible_customers_campaign ON public.coupon_eligible_customers USING btree (campaign_id);

--

CREATE INDEX IF NOT EXISTS idx_eligible_customers_mobile ON public.coupon_eligible_customers USING btree (mobile_number);

--

CREATE INDEX IF NOT EXISTS idx_employee_checklist_assignments_assigned_to_user_id ON public.employee_checklist_assignments USING btree (assigned_to_user_id);

--

CREATE INDEX IF NOT EXISTS idx_employee_checklist_assignments_branch_id ON public.employee_checklist_assignments USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_employee_checklist_assignments_checklist_id ON public.employee_checklist_assignments USING btree (checklist_id);

--

CREATE INDEX IF NOT EXISTS idx_employee_checklist_assignments_deleted_at ON public.employee_checklist_assignments USING btree (deleted_at);

--

CREATE INDEX IF NOT EXISTS idx_employee_checklist_assignments_employee_id ON public.employee_checklist_assignments USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_employment_status ON public.hr_employee_master USING btree (employment_status);

--

CREATE INDEX IF NOT EXISTS idx_employment_status_effective_date ON public.hr_employee_master USING btree (employment_status_effective_date);

--

CREATE INDEX IF NOT EXISTS idx_eoh_employee_id ON public.employee_official_holidays USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_eoh_holiday_id ON public.employee_official_holidays USING btree (official_holiday_id);

--

CREATE INDEX IF NOT EXISTS idx_erp_connections_branch_id ON public.erp_connections USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_erp_connections_device_id ON public.erp_connections USING btree (device_id);

--

CREATE INDEX IF NOT EXISTS idx_erp_connections_erp_branch_id ON public.erp_connections USING btree (erp_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_erp_connections_is_active ON public.erp_connections USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_erp_daily_sales_branch_date ON public.erp_daily_sales USING btree (branch_id, sale_date);

--

CREATE INDEX IF NOT EXISTS idx_erp_daily_sales_branch_id ON public.erp_daily_sales USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_erp_daily_sales_sale_date ON public.erp_daily_sales USING btree (sale_date);

--

CREATE INDEX IF NOT EXISTS idx_erp_sync_logs_created_at ON public.erp_sync_logs USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_erp_synced_products_barcode ON public.erp_synced_products USING btree (barcode);

--

CREATE INDEX IF NOT EXISTS idx_erp_synced_products_expiry_dates ON public.erp_synced_products USING gin (expiry_dates);

--

CREATE INDEX IF NOT EXISTS idx_erp_synced_products_expiry_hidden ON public.erp_synced_products USING btree (expiry_hidden) WHERE (expiry_hidden = true);

--

CREATE INDEX IF NOT EXISTS idx_erp_synced_products_in_process ON public.erp_synced_products USING gin (in_process);

--

CREATE INDEX IF NOT EXISTS idx_erp_synced_products_managed_by ON public.erp_synced_products USING gin (managed_by);

--

CREATE INDEX IF NOT EXISTS idx_erp_synced_products_parent_barcode ON public.erp_synced_products USING btree (parent_barcode);

--

CREATE INDEX IF NOT EXISTS idx_erp_synced_products_product_name_en ON public.erp_synced_products USING btree (product_name_en);

--

CREATE INDEX IF NOT EXISTS idx_expense_parent_categories_is_active ON public.expense_parent_categories USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_expense_requisitions_due_date ON public.expense_requisitions USING btree (due_date);

--

CREATE INDEX IF NOT EXISTS idx_expense_requisitions_is_active ON public.expense_requisitions USING btree (is_active) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_expense_requisitions_remaining_balance ON public.expense_requisitions USING btree (remaining_balance);

--

CREATE INDEX IF NOT EXISTS idx_expense_requisitions_requester_ref ON public.expense_requisitions USING btree (requester_ref_id);

--

CREATE INDEX IF NOT EXISTS idx_expense_requisitions_status_active ON public.expense_requisitions USING btree (status, is_active);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_approver_id ON public.expense_scheduler USING btree (approver_id) WHERE (approver_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_branch_id ON public.expense_scheduler USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_category_id ON public.expense_scheduler USING btree (expense_category_id);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_co_user_id ON public.expense_scheduler USING btree (co_user_id);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_created_at ON public.expense_scheduler USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_created_by ON public.expense_scheduler USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_credit_period ON public.expense_scheduler USING btree (credit_period);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_due_date ON public.expense_scheduler USING btree (due_date);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_due_date_paid ON public.expense_scheduler USING btree (due_date, is_paid);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_is_paid ON public.expense_scheduler USING btree (is_paid);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_payment_reference ON public.expense_scheduler USING btree (payment_reference) WHERE (payment_reference IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_recurring_type ON public.expense_scheduler USING btree (recurring_type) WHERE (recurring_type IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_requisition_id ON public.expense_scheduler USING btree (requisition_id);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_schedule_type ON public.expense_scheduler USING btree (schedule_type);

--

CREATE INDEX IF NOT EXISTS idx_expense_scheduler_status ON public.expense_scheduler USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_expense_sub_categories_is_active ON public.expense_sub_categories USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_expense_sub_categories_parent ON public.expense_sub_categories USING btree (parent_category_id);

--

CREATE INDEX IF NOT EXISTS idx_fine_payments_payment_date ON public.employee_fine_payments USING btree (payment_date);

--

CREATE INDEX IF NOT EXISTS idx_fine_payments_processed_by ON public.employee_fine_payments USING btree (processed_by);

--

CREATE INDEX IF NOT EXISTS idx_fine_payments_warning_id ON public.employee_fine_payments USING btree (warning_id);

--

CREATE INDEX IF NOT EXISTS idx_fingerprint_transactions_processed ON public.hr_fingerprint_transactions USING btree (processed);

--

CREATE INDEX IF NOT EXISTS idx_flyer_offer_products_barcode ON public.flyer_offer_products USING btree (product_barcode);

--

CREATE INDEX IF NOT EXISTS idx_flyer_offer_products_offer_id ON public.flyer_offer_products USING btree (offer_id);

--

CREATE INDEX IF NOT EXISTS idx_flyer_offer_products_page ON public.flyer_offer_products USING btree (offer_id, page_number, page_order);

--

CREATE INDEX IF NOT EXISTS idx_flyer_offers_dates ON public.flyer_offers USING btree (start_date, end_date);

--

CREATE INDEX IF NOT EXISTS idx_flyer_offers_is_active ON public.flyer_offers USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_flyer_offers_offer_name ON public.flyer_offers USING btree (offer_name);

--

CREATE INDEX IF NOT EXISTS idx_flyer_offers_offer_name_id ON public.flyer_offers USING btree (offer_name_id);

--

CREATE INDEX IF NOT EXISTS idx_flyer_offers_template_id ON public.flyer_offers USING btree (template_id);

--

CREATE INDEX IF NOT EXISTS idx_flyer_templates_category ON public.flyer_templates USING btree (category) WHERE (deleted_at IS NULL);

--

CREATE INDEX IF NOT EXISTS idx_flyer_templates_created_at ON public.flyer_templates USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_flyer_templates_created_by ON public.flyer_templates USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_flyer_templates_is_active ON public.flyer_templates USING btree (is_active) WHERE (deleted_at IS NULL);

--

CREATE INDEX IF NOT EXISTS idx_flyer_templates_is_default ON public.flyer_templates USING btree (is_default) WHERE ((is_default = true) AND (deleted_at IS NULL));

--

CREATE INDEX IF NOT EXISTS idx_flyer_templates_tags ON public.flyer_templates USING gin (tags);

--

CREATE INDEX IF NOT EXISTS idx_hr_assignments_branch_id ON public.hr_position_assignments USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_assignments_employee_id ON public.hr_position_assignments USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_basic_salary_employee_id ON public.hr_basic_salary USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_operations_box ON public.hr_checklist_operations USING btree (box_operation_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_operations_box_number ON public.hr_checklist_operations USING btree (box_number);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_operations_branch ON public.hr_checklist_operations USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_operations_checklist ON public.hr_checklist_operations USING btree (checklist_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_operations_created ON public.hr_checklist_operations USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_operations_date ON public.hr_checklist_operations USING btree (operation_date DESC);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_operations_employee ON public.hr_checklist_operations USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_operations_user ON public.hr_checklist_operations USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklist_questions_created ON public.hr_checklist_questions USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_hr_checklists_created ON public.hr_checklists USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_driving_licence_expiry ON public.hr_employee_master USING btree (driving_licence_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_health_card_expiry ON public.hr_employee_master USING btree (health_card_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_id_expiry ON public.hr_employee_master USING btree (id_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_bank_name ON public.hr_employee_master USING btree (bank_name);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_branch_id ON public.hr_employee_master USING btree (current_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_date_of_birth ON public.hr_employee_master USING btree (date_of_birth);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_driving_licence_expiry_date ON public.hr_employee_master USING btree (driving_licence_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_employee_mapping ON public.hr_employee_master USING gin (employee_id_mapping);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_health_card_expiry_date ON public.hr_employee_master USING btree (health_card_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_health_educational_renewal_date ON public.hr_employee_master USING btree (health_educational_renewal_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_id_expiry_date ON public.hr_employee_master USING btree (id_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_insurance_company_id ON public.hr_employee_master USING btree (insurance_company_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_insurance_expiry_date ON public.hr_employee_master USING btree (insurance_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_join_date ON public.hr_employee_master USING btree (join_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_nationality_id ON public.hr_employee_master USING btree (nationality_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_permitted_early_leave_hours ON public.hr_employee_master USING btree (permitted_early_leave_hours);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_position_id ON public.hr_employee_master USING btree (current_position_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_probation_period_expiry_date ON public.hr_employee_master USING btree (probation_period_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_user_id ON public.hr_employee_master USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_employee_master_work_permit_expiry_date ON public.hr_employee_master USING btree (work_permit_expiry_date);

--

CREATE INDEX IF NOT EXISTS idx_hr_employees_branch_id ON public.hr_employees USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_employees_employee_id ON public.hr_employees USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_employees_employee_id_branch_id ON public.hr_employees USING btree (employee_id, branch_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_employees_updated_at ON public.hr_employees USING btree (updated_at);

--

CREATE INDEX IF NOT EXISTS idx_hr_fingerprint_branch_id ON public.hr_fingerprint_transactions USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_fingerprint_date ON public.hr_fingerprint_transactions USING btree (date);

--

CREATE INDEX IF NOT EXISTS idx_hr_fingerprint_employee_id ON public.hr_fingerprint_transactions USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_hr_fingerprint_punch_state ON public.hr_fingerprint_transactions USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_hr_insurance_companies_name_ar ON public.hr_insurance_companies USING btree (name_ar);

--

CREATE INDEX IF NOT EXISTS idx_hr_insurance_companies_name_en ON public.hr_insurance_companies USING btree (name_en);

--

CREATE INDEX IF NOT EXISTS idx_hr_position_template_mgr1 ON public.hr_position_reporting_template USING btree (manager_position_1);

--

CREATE INDEX IF NOT EXISTS idx_hr_position_template_mgr2 ON public.hr_position_reporting_template USING btree (manager_position_2);

--

CREATE INDEX IF NOT EXISTS idx_hr_position_template_mgr3 ON public.hr_position_reporting_template USING btree (manager_position_3);

--

CREATE INDEX IF NOT EXISTS idx_hr_position_template_mgr4 ON public.hr_position_reporting_template USING btree (manager_position_4);

--

CREATE INDEX IF NOT EXISTS idx_hr_position_template_mgr5 ON public.hr_position_reporting_template USING btree (manager_position_5);

--

CREATE INDEX IF NOT EXISTS idx_hr_position_template_subordinate ON public.hr_position_reporting_template USING btree (subordinate_position_id);

--

CREATE INDEX IF NOT EXISTS idx_incident_actions_action_type ON public.incident_actions USING btree (action_type);

--

CREATE INDEX IF NOT EXISTS idx_incident_actions_employee_id ON public.incident_actions USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_incident_actions_has_fine ON public.incident_actions USING btree (has_fine);

--

CREATE INDEX IF NOT EXISTS idx_incident_actions_incident_id ON public.incident_actions USING btree (incident_id);

--

CREATE INDEX IF NOT EXISTS idx_incident_actions_is_paid ON public.incident_actions USING btree (is_paid);

--

CREATE INDEX IF NOT EXISTS idx_incident_types_is_active ON public.incident_types USING btree (is_active) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_incidents_attachments ON public.incidents USING gin (attachments);

--

CREATE INDEX IF NOT EXISTS idx_incidents_branch_id ON public.incidents USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_incidents_created_at ON public.incidents USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_incidents_employee_id ON public.incidents USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_incidents_incident_type_id ON public.incidents USING btree (incident_type_id);

--

CREATE INDEX IF NOT EXISTS idx_incidents_related_party ON public.incidents USING gin (related_party) WHERE (related_party IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_incidents_reports_to_user_ids ON public.incidents USING gin (reports_to_user_ids);

--

CREATE INDEX IF NOT EXISTS idx_incidents_resolution_report ON public.incidents USING gin (resolution_report) WHERE (resolution_report IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_incidents_resolution_status ON public.incidents USING btree (resolution_status);

--

CREATE INDEX IF NOT EXISTS idx_incidents_violation_id ON public.incidents USING btree (violation_id);

--

CREATE INDEX IF NOT EXISTS idx_interface_permissions_cashier ON public.interface_permissions USING btree (cashier_enabled) WHERE (cashier_enabled = true);

--

CREATE INDEX IF NOT EXISTS idx_interface_permissions_customer ON public.interface_permissions USING btree (customer_enabled);

--

CREATE INDEX IF NOT EXISTS idx_interface_permissions_desktop ON public.interface_permissions USING btree (desktop_enabled);

--

CREATE INDEX IF NOT EXISTS idx_interface_permissions_mobile ON public.interface_permissions USING btree (mobile_enabled);

--

CREATE INDEX IF NOT EXISTS idx_interface_permissions_updated_by ON public.interface_permissions USING btree (updated_by);

--

CREATE INDEX IF NOT EXISTS idx_interface_permissions_user_id ON public.interface_permissions USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_issue_types_name ON public.purchase_voucher_issue_types USING btree (type_name);

--

CREATE INDEX IF NOT EXISTS idx_lease_rent_properties_created_by ON public.lease_rent_properties USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_lease_rent_properties_is_leased ON public.lease_rent_properties USING btree (is_leased);

--

CREATE INDEX IF NOT EXISTS idx_lease_rent_properties_is_rented ON public.lease_rent_properties USING btree (is_rented);

--

CREATE INDEX IF NOT EXISTS idx_lease_rent_property_spaces_created_by ON public.lease_rent_property_spaces USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_lease_rent_property_spaces_property_id ON public.lease_rent_property_spaces USING btree (property_id);

--

CREATE INDEX IF NOT EXISTS idx_lrlp_collection_incharge ON public.lease_rent_lease_parties USING btree (collection_incharge_id);

--

CREATE INDEX IF NOT EXISTS idx_lrlp_contract_dates ON public.lease_rent_lease_parties USING btree (contract_start_date, contract_end_date);

--

CREATE INDEX IF NOT EXISTS idx_lrlp_payment_mode ON public.lease_rent_lease_parties USING btree (payment_mode);

--

CREATE INDEX IF NOT EXISTS idx_lrlp_property_id ON public.lease_rent_lease_parties USING btree (property_id);

--

CREATE INDEX IF NOT EXISTS idx_lrlp_property_space_id ON public.lease_rent_lease_parties USING btree (property_space_id);

--

CREATE INDEX IF NOT EXISTS idx_lrrp_collection_incharge ON public.lease_rent_rent_parties USING btree (collection_incharge_id);

--

CREATE INDEX IF NOT EXISTS idx_lrrp_contract_dates ON public.lease_rent_rent_parties USING btree (contract_start_date, contract_end_date);

--

CREATE INDEX IF NOT EXISTS idx_lrrp_payment_mode ON public.lease_rent_rent_parties USING btree (payment_mode);

--

CREATE INDEX IF NOT EXISTS idx_lrrp_property_id ON public.lease_rent_rent_parties USING btree (property_id);

--

CREATE INDEX IF NOT EXISTS idx_lrrp_property_space_id ON public.lease_rent_rent_parties USING btree (property_space_id);

--

CREATE INDEX IF NOT EXISTS idx_mobile_themes_is_default ON public.mobile_themes USING btree (is_default);

--

CREATE INDEX IF NOT EXISTS idx_multi_shift_date_wise_dates ON public.multi_shift_date_wise USING btree (date_from, date_to);

--

CREATE INDEX IF NOT EXISTS idx_multi_shift_date_wise_employee_id ON public.multi_shift_date_wise USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_multi_shift_regular_employee_id ON public.multi_shift_regular USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_multi_shift_weekday_employee_id ON public.multi_shift_weekday USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_multi_shift_weekday_weekday ON public.multi_shift_weekday USING btree (weekday);

--

CREATE INDEX IF NOT EXISTS idx_mv_expiry_barcode ON public.mv_expiry_products USING btree (barcode);

--

CREATE INDEX IF NOT EXISTS idx_mv_expiry_branch ON public.mv_expiry_products USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_mv_expiry_days ON public.mv_expiry_products USING btree (days_left);

--

CREATE INDEX IF NOT EXISTS idx_mv_expiry_hidden ON public.mv_expiry_products USING btree (expiry_hidden);

--

CREATE INDEX IF NOT EXISTS idx_near_expiry_reports_branch ON public.near_expiry_reports USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_near_expiry_reports_created ON public.near_expiry_reports USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_near_expiry_reports_reporter ON public.near_expiry_reports USING btree (reporter_user_id);

--

CREATE INDEX IF NOT EXISTS idx_near_expiry_reports_status ON public.near_expiry_reports USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_near_expiry_reports_target ON public.near_expiry_reports USING btree (target_user_id);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_approval_status ON public.non_approved_payment_scheduler USING btree (approval_status);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_approver_id ON public.non_approved_payment_scheduler USING btree (approver_id);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_branch_id ON public.non_approved_payment_scheduler USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_category_id ON public.non_approved_payment_scheduler USING btree (expense_category_id);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_co_user_id ON public.non_approved_payment_scheduler USING btree (co_user_id) WHERE (co_user_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_created_at ON public.non_approved_payment_scheduler USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_created_by ON public.non_approved_payment_scheduler USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_expense_scheduler_id ON public.non_approved_payment_scheduler USING btree (expense_scheduler_id) WHERE (expense_scheduler_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_non_approved_scheduler_schedule_type ON public.non_approved_payment_scheduler USING btree (schedule_type);

--

CREATE INDEX IF NOT EXISTS idx_notification_attachments_notification_id ON public.notification_attachments USING btree (notification_id);

--

CREATE INDEX IF NOT EXISTS idx_notification_attachments_uploaded_by ON public.notification_attachments USING btree (uploaded_by);

--

CREATE INDEX IF NOT EXISTS idx_notification_read_states_notification_id ON public.notification_read_states USING btree (notification_id);

--

CREATE INDEX IF NOT EXISTS idx_notification_read_states_notification_user ON public.notification_read_states USING btree (notification_id, user_id);

--

CREATE INDEX IF NOT EXISTS idx_notification_read_states_user_id ON public.notification_read_states USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_notification_recipients_delivery_status ON public.notification_recipients USING btree (delivery_status) WHERE ((delivery_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('failed'::character varying)::text]));

--

CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_offer_bundles_offer_id ON public.offer_bundles USING btree (offer_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_cart_tiers_amount_range ON public.offer_cart_tiers USING btree (min_amount, max_amount);

--

CREATE INDEX IF NOT EXISTS idx_offer_cart_tiers_offer_id ON public.offer_cart_tiers USING btree (offer_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_products_active_lookup ON public.offer_products USING btree (offer_id, product_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_products_is_variation ON public.offer_products USING btree (is_part_of_variation_group) WHERE (is_part_of_variation_group = true);

--

CREATE INDEX IF NOT EXISTS idx_offer_products_offer_id ON public.offer_products USING btree (offer_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_products_product_id ON public.offer_products USING btree (product_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_products_variation_group_id ON public.offer_products USING btree (variation_group_id) WHERE (variation_group_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_offer_products_variation_parent ON public.offer_products USING btree (variation_parent_barcode) WHERE (variation_parent_barcode IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_offer_usage_logs_customer_id ON public.offer_usage_logs USING btree (customer_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_usage_logs_offer_id ON public.offer_usage_logs USING btree (offer_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_usage_logs_order_id ON public.offer_usage_logs USING btree (order_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_usage_logs_order_offer ON public.offer_usage_logs USING btree (order_id, offer_id);

--

CREATE INDEX IF NOT EXISTS idx_offer_usage_logs_used_at ON public.offer_usage_logs USING btree (used_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_offers_branch_id ON public.offers USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_offers_date_range ON public.offers USING btree (start_date, end_date);

--

CREATE INDEX IF NOT EXISTS idx_offers_is_active ON public.offers USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_offers_service_type ON public.offers USING btree (service_type);

--

CREATE INDEX IF NOT EXISTS idx_offers_type ON public.offers USING btree (type);

--

CREATE INDEX IF NOT EXISTS idx_official_holidays_date ON public.official_holidays USING btree (holiday_date);

--

CREATE INDEX IF NOT EXISTS idx_order_audit_logs_action_type ON public.order_audit_logs USING btree (action_type);

--

CREATE INDEX IF NOT EXISTS idx_order_audit_logs_assigned_user ON public.order_audit_logs USING btree (assigned_user_id);

--

CREATE INDEX IF NOT EXISTS idx_order_audit_logs_created_at ON public.order_audit_logs USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_order_audit_logs_order_action ON public.order_audit_logs USING btree (order_id, action_type);

--

CREATE INDEX IF NOT EXISTS idx_order_audit_logs_order_created ON public.order_audit_logs USING btree (order_id, created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_order_audit_logs_order_id ON public.order_audit_logs USING btree (order_id);

--

CREATE INDEX IF NOT EXISTS idx_order_audit_logs_performed_by ON public.order_audit_logs USING btree (performed_by);

--

CREATE INDEX IF NOT EXISTS idx_order_items_bundle_id ON public.order_items USING btree (bundle_id);

--

CREATE INDEX IF NOT EXISTS idx_order_items_item_type ON public.order_items USING btree (item_type);

--

CREATE INDEX IF NOT EXISTS idx_order_items_offer_id ON public.order_items USING btree (offer_id);

--

CREATE INDEX IF NOT EXISTS idx_order_items_order_bundle ON public.order_items USING btree (order_id, bundle_id);

--

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON public.order_items USING btree (order_id);

--

CREATE INDEX IF NOT EXISTS idx_order_items_order_product ON public.order_items USING btree (order_id, product_id);

--

CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON public.order_items USING btree (product_id);

--

CREATE INDEX IF NOT EXISTS idx_order_items_unit_id ON public.order_items USING btree (unit_id);

--

CREATE INDEX IF NOT EXISTS idx_orders_branch_id ON public.orders USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_orders_branch_status ON public.orders USING btree (branch_id, order_status);

--

CREATE INDEX IF NOT EXISTS idx_orders_created_at ON public.orders USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON public.orders USING btree (customer_id);

--

CREATE INDEX IF NOT EXISTS idx_orders_customer_status ON public.orders USING btree (customer_id, order_status);

--

CREATE INDEX IF NOT EXISTS idx_orders_delivery_person_id ON public.orders USING btree (delivery_person_id);

--

CREATE INDEX IF NOT EXISTS idx_orders_fulfillment_method ON public.orders USING btree (fulfillment_method);

--

CREATE INDEX IF NOT EXISTS idx_orders_order_number ON public.orders USING btree (order_number);

--

CREATE INDEX IF NOT EXISTS idx_orders_order_status ON public.orders USING btree (order_status);

--

CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON public.orders USING btree (payment_status);

--

CREATE INDEX IF NOT EXISTS idx_orders_picker_id ON public.orders USING btree (picker_id);

--

CREATE INDEX IF NOT EXISTS idx_orders_status_created ON public.orders USING btree (order_status, created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_password_history_user_created ON public.user_password_history USING btree (user_id, created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_payment_entries_party ON public.lease_rent_payment_entries USING btree (party_type, party_id, period_num, column_name);

--

CREATE INDEX IF NOT EXISTS idx_payments_party ON public.lease_rent_payments USING btree (party_type, party_id);

--

CREATE INDEX IF NOT EXISTS idx_pos_deduction_transfers_applied ON public.pos_deduction_transfers USING btree (applied);

--

CREATE INDEX IF NOT EXISTS idx_pos_deduction_transfers_branch ON public.pos_deduction_transfers USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_pos_deduction_transfers_cashier ON public.pos_deduction_transfers USING btree (cashier_user_id);

--

CREATE INDEX IF NOT EXISTS idx_pos_deduction_transfers_date_closed ON public.pos_deduction_transfers USING btree (date_closed_box);

--

CREATE INDEX IF NOT EXISTS idx_privilege_cards_branch_branch_id ON public.privilege_cards_branch USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_privilege_cards_branch_card_number ON public.privilege_cards_branch USING btree (card_number);

--

CREATE INDEX IF NOT EXISTS idx_privilege_cards_branch_composite ON public.privilege_cards_branch USING btree (branch_id, card_number);

--

CREATE INDEX IF NOT EXISTS idx_privilege_cards_master_card_number ON public.privilege_cards_master USING btree (card_number);

--

CREATE INDEX IF NOT EXISTS idx_processed_fingerprint_branch_id ON public.processed_fingerprint_transactions USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_processed_fingerprint_center_id ON public.processed_fingerprint_transactions USING btree (center_id);

--

CREATE INDEX IF NOT EXISTS idx_processed_fingerprint_employee_id ON public.processed_fingerprint_transactions USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_processed_fingerprint_punch_date ON public.processed_fingerprint_transactions USING btree (punch_date);

--

CREATE INDEX IF NOT EXISTS idx_product_categories_display_order ON public.product_categories USING btree (display_order);

--

CREATE INDEX IF NOT EXISTS idx_product_categories_is_active ON public.product_categories USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_product_request_bt_created ON public.product_request_bt USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_product_request_bt_from_branch ON public.product_request_bt USING btree (from_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_bt_requester ON public.product_request_bt USING btree (requester_user_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_bt_status ON public.product_request_bt USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_product_request_bt_target ON public.product_request_bt USING btree (target_user_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_bt_to_branch ON public.product_request_bt USING btree (to_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_po_branch ON public.product_request_po USING btree (from_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_po_created ON public.product_request_po USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_product_request_po_requester ON public.product_request_po USING btree (requester_user_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_po_status ON public.product_request_po USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_product_request_po_target ON public.product_request_po USING btree (target_user_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_st_branch ON public.product_request_st USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_st_created ON public.product_request_st USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_product_request_st_requester ON public.product_request_st USING btree (requester_user_id);

--

CREATE INDEX IF NOT EXISTS idx_product_request_st_status ON public.product_request_st USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_product_request_st_target ON public.product_request_st USING btree (target_user_id);

--

CREATE INDEX IF NOT EXISTS idx_product_units_is_active ON public.product_units USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_products_barcode ON public.products USING btree (barcode);

--

CREATE INDEX IF NOT EXISTS idx_products_category_id ON public.products USING btree (category_id);

--

CREATE INDEX IF NOT EXISTS idx_products_created_at ON public.products USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_products_is_active ON public.products USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_products_is_customer_product ON public.products USING btree (is_customer_product);

--

CREATE INDEX IF NOT EXISTS idx_products_is_variation ON public.products USING btree (is_variation);

--

CREATE INDEX IF NOT EXISTS idx_products_parent_product_barcode ON public.products USING btree (parent_product_barcode);

--

CREATE INDEX IF NOT EXISTS idx_products_unit_id ON public.products USING btree (unit_id);

--

CREATE INDEX IF NOT EXISTS idx_purchase_voucher_items_pv_id ON public.purchase_voucher_items USING btree (purchase_voucher_id);

--

CREATE INDEX IF NOT EXISTS idx_purchase_voucher_items_status ON public.purchase_voucher_items USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_purchase_vouchers_created_at ON public.purchase_vouchers USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_purchase_vouchers_status ON public.purchase_vouchers USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_push_subscriptions_active ON public.push_subscriptions USING btree (user_id, is_active) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_push_subscriptions_customer_active ON public.push_subscriptions USING btree (customer_id, is_active) WHERE ((is_active = true) AND (customer_id IS NOT NULL));

--

CREATE INDEX IF NOT EXISTS idx_push_subscriptions_customer_id ON public.push_subscriptions USING btree (customer_id) WHERE (customer_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_push_subscriptions_user_id ON public.push_subscriptions USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_pvi_approver_id ON public.purchase_voucher_items USING btree (approver_id);

--

CREATE INDEX IF NOT EXISTS idx_pvi_close_bill_number ON public.purchase_voucher_items USING btree (close_bill_number);

--

CREATE INDEX IF NOT EXISTS idx_pvi_created_at ON public.purchase_voucher_items USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_pvi_issued_by ON public.purchase_voucher_items USING btree (issued_by);

--

CREATE INDEX IF NOT EXISTS idx_pvi_issued_to ON public.purchase_voucher_items USING btree (issued_to);

--

CREATE INDEX IF NOT EXISTS idx_pvi_pending_stock_location ON public.purchase_voucher_items USING btree (pending_stock_location);

--

CREATE INDEX IF NOT EXISTS idx_pvi_pending_stock_person ON public.purchase_voucher_items USING btree (pending_stock_person);

--

CREATE INDEX IF NOT EXISTS idx_pvi_purchase_voucher_id ON public.purchase_voucher_items USING btree (purchase_voucher_id);

--

CREATE INDEX IF NOT EXISTS idx_pvi_status ON public.purchase_voucher_items USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_pvi_stock_location ON public.purchase_voucher_items USING btree (stock_location);

--

CREATE INDEX IF NOT EXISTS idx_pvi_stock_person ON public.purchase_voucher_items USING btree (stock_person);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_assignments_assignment_id_status ON public.quick_task_assignments USING btree (quick_task_id, status);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_assignments_created_at ON public.quick_task_assignments USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_assignments_require_erp_reference ON public.quick_task_assignments USING btree (require_erp_reference) WHERE (require_erp_reference = true);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_assignments_require_photo_upload ON public.quick_task_assignments USING btree (require_photo_upload) WHERE (require_photo_upload = true);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_assignments_require_task_finished ON public.quick_task_assignments USING btree (require_task_finished);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_assignments_status ON public.quick_task_assignments USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_assignments_task ON public.quick_task_assignments USING btree (quick_task_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_assignments_user ON public.quick_task_assignments USING btree (assigned_to_user_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_comments_created_by ON public.quick_task_comments USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_comments_task ON public.quick_task_comments USING btree (quick_task_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_completions_assignment ON public.quick_task_completions USING btree (assignment_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_completions_completed_by ON public.quick_task_completions USING btree (completed_by_user_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_completions_created_at ON public.quick_task_completions USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_completions_status ON public.quick_task_completions USING btree (completion_status);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_completions_task ON public.quick_task_completions USING btree (quick_task_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_completions_verified_by ON public.quick_task_completions USING btree (verified_by_user_id) WHERE (verified_by_user_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_files_task ON public.quick_task_files USING btree (quick_task_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_files_uploaded_by ON public.quick_task_files USING btree (uploaded_by);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_user_preferences_branch ON public.quick_task_user_preferences USING btree (default_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_task_user_preferences_user ON public.quick_task_user_preferences USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_assigned_by ON public.quick_tasks USING btree (assigned_by);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_branch ON public.quick_tasks USING btree (assigned_to_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_created_at ON public.quick_tasks USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_deadline ON public.quick_tasks USING btree (deadline_datetime);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_incident_id ON public.quick_tasks USING btree (incident_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_issue_type ON public.quick_tasks USING btree (issue_type);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_order_id ON public.quick_tasks USING btree (order_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_priority ON public.quick_tasks USING btree (priority);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_product_request_id ON public.quick_tasks USING btree (product_request_id);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_product_request_type ON public.quick_tasks USING btree (product_request_type);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_require_erp_reference ON public.quick_tasks USING btree (require_erp_reference) WHERE (require_erp_reference = true);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_require_photo_upload ON public.quick_tasks USING btree (require_photo_upload) WHERE (require_photo_upload = true);

--

CREATE INDEX IF NOT EXISTS idx_quick_tasks_status ON public.quick_tasks USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_accountant_user_id ON public.receiving_records USING btree (accountant_user_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_bank_name ON public.receiving_records USING btree (bank_name);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_bill_amount ON public.receiving_records USING btree (bill_amount);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_bill_date ON public.receiving_records USING btree (bill_date);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_bill_number ON public.receiving_records USING btree (bill_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_bill_vat_number ON public.receiving_records USING btree (bill_vat_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_branch_id ON public.receiving_records USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_branch_manager_user_id ON public.receiving_records USING btree (branch_manager_user_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_created_at ON public.receiving_records USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_credit_period ON public.receiving_records USING btree (credit_period);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_damage_erp_document_number ON public.receiving_records USING btree (damage_erp_document_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_damage_vendor_document_number ON public.receiving_records USING btree (damage_vendor_document_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_due_date ON public.receiving_records USING btree (due_date);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_erp_purchase_invoice_reference ON public.receiving_records USING btree (erp_purchase_invoice_reference);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_erp_purchase_invoice_uploaded ON public.receiving_records USING btree (erp_purchase_invoice_uploaded);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_expired_erp_document_number ON public.receiving_records USING btree (expired_erp_document_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_expired_vendor_document_number ON public.receiving_records USING btree (expired_vendor_document_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_final_bill_amount ON public.receiving_records USING btree (final_bill_amount);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_iban ON public.receiving_records USING btree (iban);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_inventory_manager_user_id ON public.receiving_records USING btree (inventory_manager_user_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_near_expiry_erp_document_number ON public.receiving_records USING btree (near_expiry_erp_document_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_near_expiry_vendor_document_number ON public.receiving_records USING btree (near_expiry_vendor_document_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_night_supervisor_user_ids ON public.receiving_records USING gin (night_supervisor_user_ids);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_original_bill_uploaded ON public.receiving_records USING btree (original_bill_uploaded);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_original_bill_url ON public.receiving_records USING btree (original_bill_url);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_over_stock_erp_document_number ON public.receiving_records USING btree (over_stock_erp_document_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_over_stock_vendor_document_number ON public.receiving_records USING btree (over_stock_vendor_document_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_payment_method ON public.receiving_records USING btree (payment_method);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_pr_excel_file_uploaded ON public.receiving_records USING btree (pr_excel_file_uploaded);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_pr_excel_file_url ON public.receiving_records USING btree (pr_excel_file_url) WHERE (pr_excel_file_url IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_purchasing_manager_user_id ON public.receiving_records USING btree (purchasing_manager_user_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_shelf_stocker_user_ids ON public.receiving_records USING gin (shelf_stocker_user_ids);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_total_return_amount ON public.receiving_records USING btree (total_return_amount);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_updated_at ON public.receiving_records USING btree (updated_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_user_id ON public.receiving_records USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_vat_numbers_match ON public.receiving_records USING btree (vat_numbers_match);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_vendor_id ON public.receiving_records USING btree (vendor_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_vendor_vat_number ON public.receiving_records USING btree (vendor_vat_number);

--

CREATE INDEX IF NOT EXISTS idx_receiving_records_warehouse_handler_user_ids ON public.receiving_records USING gin (warehouse_handler_user_ids);

--

CREATE INDEX IF NOT EXISTS idx_receiving_task_templates_priority ON public.receiving_task_templates USING btree (priority);

--

CREATE INDEX IF NOT EXISTS idx_receiving_task_templates_role_type ON public.receiving_task_templates USING btree (role_type);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_assigned_user_id ON public.receiving_tasks USING btree (assigned_user_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_completion_photo_url ON public.receiving_tasks USING btree (completion_photo_url) WHERE (completion_photo_url IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_created_at ON public.receiving_tasks USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_receiving_record_id ON public.receiving_tasks USING btree (receiving_record_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_record_role ON public.receiving_tasks USING btree (receiving_record_id, role_type);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_role_type ON public.receiving_tasks USING btree (role_type);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_status_role ON public.receiving_tasks USING btree (task_status, role_type);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_task_completed ON public.receiving_tasks USING btree (task_completed);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_task_status ON public.receiving_tasks USING btree (task_status);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_template_id ON public.receiving_tasks USING btree (template_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_user_role ON public.receiving_tasks USING btree (assigned_user_id, role_type);

--

CREATE INDEX IF NOT EXISTS idx_receiving_tasks_user_status ON public.receiving_tasks USING btree (assigned_user_id, task_status);

--

CREATE INDEX IF NOT EXISTS idx_receiving_user_defaults_branch_id ON public.receiving_user_defaults USING btree (default_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_receiving_user_defaults_user_id ON public.receiving_user_defaults USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_recurring_schedules_active ON public.recurring_assignment_schedules USING btree (is_active, repeat_type);

--

CREATE INDEX IF NOT EXISTS idx_recurring_schedules_assignment_id ON public.recurring_assignment_schedules USING btree (assignment_id);

--

CREATE INDEX IF NOT EXISTS idx_recurring_schedules_next_execution ON public.recurring_assignment_schedules USING btree (next_execution_at, is_active) WHERE (is_active = true);

--

CREATE INDEX IF NOT EXISTS idx_regular_shift_created_at ON public.regular_shift USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_regular_shift_updated_at ON public.regular_shift USING btree (updated_at);

--

CREATE INDEX IF NOT EXISTS idx_requesters_name ON public.requesters USING btree (requester_name);

--

CREATE INDEX IF NOT EXISTS idx_requesters_requester_id ON public.requesters USING btree (requester_id);

--

CREATE INDEX IF NOT EXISTS idx_requisitions_branch ON public.expense_requisitions USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_requisitions_created_at ON public.expense_requisitions USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_requisitions_number ON public.expense_requisitions USING btree (requisition_number);

--

CREATE INDEX IF NOT EXISTS idx_requisitions_status ON public.expense_requisitions USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_shelf_paper_fonts_created_by ON public.shelf_paper_fonts USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_shelf_paper_fonts_name ON public.shelf_paper_fonts USING btree (name);

--

CREATE INDEX IF NOT EXISTS idx_shelf_paper_templates_created_at ON public.shelf_paper_templates USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_shelf_paper_templates_created_by ON public.shelf_paper_templates USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_shelf_paper_templates_is_active ON public.shelf_paper_templates USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_sidebar_buttons_active ON public.sidebar_buttons USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_sidebar_buttons_main ON public.sidebar_buttons USING btree (main_section_id);

--

CREATE INDEX IF NOT EXISTS idx_sidebar_buttons_sub ON public.sidebar_buttons USING btree (subsection_id);

--

CREATE INDEX IF NOT EXISTS idx_social_links_branch_id ON public.social_links USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_special_changes_dates ON public.lease_rent_special_changes USING btree (effective_from, effective_until);

--

CREATE INDEX IF NOT EXISTS idx_special_changes_party ON public.lease_rent_special_changes USING btree (party_type, party_id);

--

CREATE INDEX IF NOT EXISTS idx_special_shift_date_wise_date ON public.special_shift_date_wise USING btree (shift_date);

--

CREATE INDEX IF NOT EXISTS idx_special_shift_date_wise_employee_id ON public.special_shift_date_wise USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_special_shift_weekday_created_at ON public.special_shift_weekday USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_special_shift_weekday_employee_id ON public.special_shift_weekday USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_special_shift_weekday_weekday ON public.special_shift_weekday USING btree (weekday);

--

CREATE INDEX IF NOT EXISTS idx_system_api_keys_service_name ON public.system_api_keys USING btree (service_name);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_assigned_by ON public.task_assignments USING btree (assigned_by);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_assigned_to_branch_id ON public.task_assignments USING btree (assigned_to_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_assigned_to_user_id ON public.task_assignments USING btree (assigned_to_user_id);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_assignment_type ON public.task_assignments USING btree (assignment_type);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_deadline_datetime ON public.task_assignments USING btree (deadline_datetime) WHERE (deadline_datetime IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_overdue ON public.task_assignments USING btree (deadline_datetime, status) WHERE ((deadline_datetime IS NOT NULL) AND (status <> ALL (ARRAY['completed'::text, 'cancelled'::text])));

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_reassignable ON public.task_assignments USING btree (is_reassignable, status) WHERE (is_reassignable = true);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_recurring ON public.task_assignments USING btree (is_recurring, status) WHERE (is_recurring = true);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_schedule_date ON public.task_assignments USING btree (schedule_date) WHERE (schedule_date IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_status ON public.task_assignments USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_task_assignments_task_id ON public.task_assignments USING btree (task_id);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_assignment_id ON public.task_completions USING btree (assignment_id);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_completed_at ON public.task_completions USING btree (completed_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_completed_by ON public.task_completions USING btree (completed_by);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_completed_by_branch_id ON public.task_completions USING btree (completed_by_branch_id);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_erp_reference ON public.task_completions USING btree (erp_reference_completed);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_photo_uploaded ON public.task_completions USING btree (photo_uploaded_completed);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_photo_url ON public.task_completions USING btree (completion_photo_url) WHERE (completion_photo_url IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_task_finished ON public.task_completions USING btree (task_finished_completed);

--

CREATE INDEX IF NOT EXISTS idx_task_completions_task_id ON public.task_completions USING btree (task_id);

--

CREATE INDEX IF NOT EXISTS idx_task_images_attachment_type ON public.task_images USING btree (attachment_type);

--

CREATE INDEX IF NOT EXISTS idx_task_images_image_type ON public.task_images USING btree (image_type);

--

CREATE INDEX IF NOT EXISTS idx_task_images_task_id ON public.task_images USING btree (task_id);

--

CREATE INDEX IF NOT EXISTS idx_task_images_uploaded_by ON public.task_images USING btree (uploaded_by);

--

CREATE INDEX IF NOT EXISTS idx_task_reminder_logs_quick_task ON public.task_reminder_logs USING btree (quick_task_assignment_id) WHERE (quick_task_assignment_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_task_reminder_logs_sent_at ON public.task_reminder_logs USING btree (reminder_sent_at);

--

CREATE INDEX IF NOT EXISTS idx_task_reminder_logs_status ON public.task_reminder_logs USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_task_reminder_logs_task_assignment ON public.task_reminder_logs USING btree (task_assignment_id) WHERE (task_assignment_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_task_reminder_logs_user ON public.task_reminder_logs USING btree (assigned_to_user_id);

--

CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON public.tasks USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_tasks_created_by ON public.tasks USING btree (created_by);

--

CREATE INDEX IF NOT EXISTS idx_tasks_deleted_at ON public.tasks USING btree (deleted_at);

--

CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON public.tasks USING btree (due_date) WHERE (due_date IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_tasks_metadata ON public.tasks USING gin (metadata);

--

CREATE INDEX IF NOT EXISTS idx_tasks_search_vector ON public.tasks USING gin (search_vector);

--

CREATE INDEX IF NOT EXISTS idx_tasks_status ON public.tasks USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_user_audit_logs_action ON public.user_audit_logs USING btree (action);

--

CREATE INDEX IF NOT EXISTS idx_user_audit_logs_created_at ON public.user_audit_logs USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_user_audit_logs_user_id ON public.user_audit_logs USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_user_device_sessions_active ON public.user_device_sessions USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_user_device_sessions_device_id ON public.user_device_sessions USING btree (device_id);

--

CREATE INDEX IF NOT EXISTS idx_user_device_sessions_expires_at ON public.user_device_sessions USING btree (expires_at);

--

CREATE INDEX IF NOT EXISTS idx_user_device_sessions_last_activity ON public.user_device_sessions USING btree (last_activity);

--

CREATE INDEX IF NOT EXISTS idx_user_device_sessions_user_id ON public.user_device_sessions USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_user_favorite_buttons_employee_id ON public.user_favorite_buttons USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_user_favorite_buttons_user_id ON public.user_favorite_buttons USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_user_mobile_theme_assignments_theme_id ON public.user_mobile_theme_assignments USING btree (theme_id);

--

CREATE INDEX IF NOT EXISTS idx_user_mobile_theme_assignments_user_id ON public.user_mobile_theme_assignments USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_user_sessions_active ON public.user_sessions USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_user_sessions_token ON public.user_sessions USING btree (session_token);

--

CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON public.user_sessions USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_user_theme_assignments_theme_id ON public.user_theme_assignments USING btree (theme_id);

--

CREATE INDEX IF NOT EXISTS idx_user_theme_assignments_user_id ON public.user_theme_assignments USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_user_theme_overrides ON public.user_mobile_theme_assignments USING btree (user_id) WHERE (color_overrides IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_user_voice_preferences_user_id ON public.user_voice_preferences USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_users_ai_translation_enabled ON public.users USING btree (ai_translation_enabled);

--

CREATE INDEX IF NOT EXISTS idx_users_branch_id ON public.users USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_users_branch_lookup ON public.users USING btree (branch_id) WHERE (branch_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_users_created_at ON public.users USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_users_employee_id ON public.users USING btree (employee_id);

--

CREATE INDEX IF NOT EXISTS idx_users_employee_lookup ON public.users USING btree (employee_id) WHERE (employee_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_users_is_admin ON public.users USING btree (is_admin);

--

CREATE INDEX IF NOT EXISTS idx_users_is_master_admin ON public.users USING btree (is_master_admin);

--

CREATE INDEX IF NOT EXISTS idx_users_last_login ON public.users USING btree (last_login_at);

--

CREATE INDEX IF NOT EXISTS idx_users_position_lookup ON public.users USING btree (position_id) WHERE (position_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_users_username ON public.users USING btree (username);

--

CREATE INDEX IF NOT EXISTS idx_variation_audit_log_action_type ON public.variation_audit_log USING btree (action_type);

--

CREATE INDEX IF NOT EXISTS idx_variation_audit_log_parent_barcode ON public.variation_audit_log USING btree (parent_barcode) WHERE (parent_barcode IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_variation_audit_log_timestamp ON public.variation_audit_log USING btree ("timestamp" DESC);

--

CREATE INDEX IF NOT EXISTS idx_variation_audit_log_user_id ON public.variation_audit_log USING btree (user_id);

--

CREATE INDEX IF NOT EXISTS idx_variation_audit_log_variation_group_id ON public.variation_audit_log USING btree (variation_group_id) WHERE (variation_group_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_approval_requested_by ON public.vendor_payment_schedule USING btree (approval_requested_by);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_approval_status ON public.vendor_payment_schedule USING btree (approval_status) WHERE (approval_status = 'sent_for_approval'::text);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_approved_by ON public.vendor_payment_schedule USING btree (approved_by);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_assigned_approver ON public.vendor_payment_schedule USING btree (assigned_approver_id);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_accountant_user_id ON public.vendor_payment_schedule USING btree (accountant_user_id);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_adjustments ON public.vendor_payment_schedule USING btree (last_adjustment_date) WHERE (last_adjustment_date IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_branch_id ON public.vendor_payment_schedule USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_due_date ON public.vendor_payment_schedule USING btree (due_date);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_due_date_paid ON public.vendor_payment_schedule USING btree (due_date, is_paid);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_grr_ref ON public.vendor_payment_schedule USING btree (grr_reference_number) WHERE (grr_reference_number IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_is_paid ON public.vendor_payment_schedule USING btree (is_paid);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_paid_date ON public.vendor_payment_schedule USING btree (paid_date);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_pr_excel_verified ON public.vendor_payment_schedule USING btree (pr_excel_verified);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_pr_excel_verified_by ON public.vendor_payment_schedule USING btree (pr_excel_verified_by);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_pri_ref ON public.vendor_payment_schedule USING btree (pri_reference_number) WHERE (pri_reference_number IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_receiving_record_id ON public.vendor_payment_schedule USING btree (receiving_record_id);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_task_id ON public.vendor_payment_schedule USING btree (task_id);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_vendor_id ON public.vendor_payment_schedule USING btree (vendor_id);

--

CREATE INDEX IF NOT EXISTS idx_vendor_payment_schedule_verification_status ON public.vendor_payment_schedule USING btree (verification_status);

--

CREATE INDEX IF NOT EXISTS idx_vendors_branch_id ON public.vendors USING btree (branch_id) WHERE (branch_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_vendors_branch_status ON public.vendors USING btree (branch_id, status) WHERE (branch_id IS NOT NULL);

--

CREATE INDEX IF NOT EXISTS idx_vendors_created_at ON public.vendors USING btree (created_at);

--

CREATE INDEX IF NOT EXISTS idx_vendors_erp_vendor_id ON public.vendors USING btree (erp_vendor_id);

--

CREATE INDEX IF NOT EXISTS idx_vendors_payment_method ON public.vendors USING gin (to_tsvector('english'::regconfig, payment_method));

--

CREATE INDEX IF NOT EXISTS idx_vendors_payment_priority ON public.vendors USING btree (payment_priority);

--

CREATE INDEX IF NOT EXISTS idx_vendors_status ON public.vendors USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_vendors_vat_applicable ON public.vendors USING btree (vat_applicable);

--

CREATE INDEX IF NOT EXISTS idx_vendors_vendor_name ON public.vendors USING btree (vendor_name);

--

CREATE INDEX IF NOT EXISTS idx_view_offer_branch_id ON public.view_offer USING btree (branch_id);

--

CREATE INDEX IF NOT EXISTS idx_view_offer_dates ON public.view_offer USING btree (start_date, end_date);

--

CREATE INDEX IF NOT EXISTS idx_view_offer_datetime ON public.view_offer USING btree (start_date, start_time, end_date, end_time);

--

CREATE INDEX IF NOT EXISTS idx_wa_auto_reply_account ON public.wa_auto_reply_triggers USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_auto_reply_active ON public.wa_auto_reply_triggers USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_wa_auto_reply_order ON public.wa_auto_reply_triggers USING btree (sort_order);

--

CREATE INDEX IF NOT EXISTS idx_wa_bot_flows_account ON public.wa_bot_flows USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_bot_flows_active ON public.wa_bot_flows USING btree (is_active);

--

CREATE INDEX IF NOT EXISTS idx_wa_broadcast_recip_broadcast ON public.wa_broadcast_recipients USING btree (broadcast_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_broadcast_recip_status ON public.wa_broadcast_recipients USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_wa_broadcasts_account ON public.wa_broadcasts USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_broadcasts_created ON public.wa_broadcasts USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_wa_broadcasts_status ON public.wa_broadcasts USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_wa_catalog_orders_account ON public.wa_catalog_orders USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_catalog_orders_status ON public.wa_catalog_orders USING btree (order_status);

--

CREATE INDEX IF NOT EXISTS idx_wa_catalog_products_account ON public.wa_catalog_products USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_catalog_products_catalog ON public.wa_catalog_products USING btree (catalog_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_catalog_products_sku ON public.wa_catalog_products USING btree (sku);

--

CREATE INDEX IF NOT EXISTS idx_wa_catalogs_account ON public.wa_catalogs USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_conv_account_status_lastmsg ON public.wa_conversations USING btree (wa_account_id, status, last_message_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_wa_conversations_account ON public.wa_conversations USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_conversations_customer ON public.wa_conversations USING btree (customer_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_conversations_last_msg ON public.wa_conversations USING btree (last_message_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_wa_conversations_phone ON public.wa_conversations USING btree (customer_phone);

--

CREATE INDEX IF NOT EXISTS idx_wa_conversations_sos ON public.wa_conversations USING btree (is_sos) WHERE (is_sos = true);

--

CREATE INDEX IF NOT EXISTS idx_wa_group_members_customer ON public.wa_contact_group_members USING btree (customer_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_group_members_group ON public.wa_contact_group_members USING btree (group_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_messages_account ON public.wa_messages USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_messages_conv_created ON public.wa_messages USING btree (conversation_id, created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_wa_messages_conversation ON public.wa_messages USING btree (conversation_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_messages_created ON public.wa_messages USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_wa_messages_direction ON public.wa_messages USING btree (direction);

--

CREATE INDEX IF NOT EXISTS idx_wa_messages_wa_id ON public.wa_messages USING btree (whatsapp_message_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_settings_account ON public.wa_settings USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_templates_account ON public.wa_templates USING btree (wa_account_id);

--

CREATE INDEX IF NOT EXISTS idx_wa_templates_name ON public.wa_templates USING btree (name);

--

CREATE INDEX IF NOT EXISTS idx_wa_templates_status ON public.wa_templates USING btree (status);

--

CREATE INDEX IF NOT EXISTS idx_warning_main_category_name_en ON public.warning_main_category USING btree (name_en);

--

CREATE INDEX IF NOT EXISTS idx_warning_sub_category_main_id ON public.warning_sub_category USING btree (main_category_id);

--

CREATE INDEX IF NOT EXISTS idx_warning_sub_category_name_en ON public.warning_sub_category USING btree (name_en);

--

CREATE INDEX IF NOT EXISTS idx_warning_violation_main_id ON public.warning_violation USING btree (main_category_id);

--

CREATE INDEX IF NOT EXISTS idx_warning_violation_name_en ON public.warning_violation USING btree (name_en);

--

CREATE INDEX IF NOT EXISTS idx_warning_violation_sub_id ON public.warning_violation USING btree (sub_category_id);

--

CREATE INDEX IF NOT EXISTS idx_whatsapp_log_created ON public.whatsapp_message_log USING btree (created_at DESC);

--

CREATE INDEX IF NOT EXISTS idx_whatsapp_log_phone ON public.whatsapp_message_log USING btree (phone_number);