CREATE TRIGGER warning_violation_timestamp_update BEFORE UPDATE ON public.warning_violation FOR EACH ROW EXECUTE FUNCTION public.update_warning_violation_timestamp();


--
-- Name: access_code_otp access_code_otp_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_code_otp
    ADD CONSTRAINT access_code_otp_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ai_chat_guide ai_chat_guide_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_chat_guide
    ADD CONSTRAINT ai_chat_guide_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: app_icons app_icons_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: approval_permissions approval_permissions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approval_permissions approval_permissions_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approval_permissions approval_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: approver_branch_access approver_branch_access_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: approver_branch_access approver_branch_access_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approver_branch_access approver_branch_access_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: approver_visibility_config approver_visibility_config_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approver_visibility_config approver_visibility_config_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: approver_visibility_config approver_visibility_config_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: asset_sub_categories asset_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_sub_categories
    ADD CONSTRAINT asset_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.asset_main_categories(id) ON DELETE CASCADE;


--
-- Name: assets assets_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: assets assets_sub_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.asset_sub_categories(id) ON DELETE RESTRICT;


--
-- Name: bank_reconciliations bank_reconciliations_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: bank_reconciliations bank_reconciliations_cashier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: bank_reconciliations bank_reconciliations_operation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_operation_id_fkey FOREIGN KEY (operation_id) REFERENCES public.box_operations(id) ON DELETE CASCADE;


--
-- Name: bank_reconciliations bank_reconciliations_supervisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_reconciliations
    ADD CONSTRAINT bank_reconciliations_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: biometric_connections biometric_connections_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.biometric_connections
    ADD CONSTRAINT biometric_connections_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: bogo_offer_rules bogo_offer_rules_buy_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_buy_product_id_fkey FOREIGN KEY (buy_product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: bogo_offer_rules bogo_offer_rules_get_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_get_product_id_fkey FOREIGN KEY (get_product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: bogo_offer_rules bogo_offer_rules_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bogo_offer_rules
    ADD CONSTRAINT bogo_offer_rules_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: box_operations box_operations_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: box_operations box_operations_denomination_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_denomination_record_id_fkey FOREIGN KEY (denomination_record_id) REFERENCES public.denomination_records(id) ON DELETE CASCADE;


--
-- Name: box_operations box_operations_supervisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: box_operations box_operations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.box_operations
    ADD CONSTRAINT box_operations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: branch_default_delivery_receivers branch_default_delivery_receivers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_delivery_receivers
    ADD CONSTRAINT branch_default_delivery_receivers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: branch_default_delivery_receivers branch_default_delivery_receivers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_delivery_receivers
    ADD CONSTRAINT branch_default_delivery_receivers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: branch_default_positions branch_default_positions_accountant_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_accountant_user_id_fkey FOREIGN KEY (accountant_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions branch_default_positions_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: branch_default_positions branch_default_positions_branch_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_manager_user_id_fkey FOREIGN KEY (branch_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions branch_default_positions_inventory_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_inventory_manager_user_id_fkey FOREIGN KEY (inventory_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions branch_default_positions_purchasing_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_purchasing_manager_user_id_fkey FOREIGN KEY (purchasing_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions branch_default_positions_warehouse_handler_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_warehouse_handler_user_id_fkey FOREIGN KEY (warehouse_handler_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_sync_config branch_sync_config_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_sync_config
    ADD CONSTRAINT branch_sync_config_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: break_register break_register_reason_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.break_register
    ADD CONSTRAINT break_register_reason_id_fkey FOREIGN KEY (reason_id) REFERENCES public.break_reasons(id);


--
-- Name: coupon_campaigns coupon_campaigns_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_campaigns
    ADD CONSTRAINT coupon_campaigns_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: coupon_claims coupon_claims_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: coupon_claims coupon_claims_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.coupon_campaigns(id) ON DELETE CASCADE;


--
-- Name: coupon_claims coupon_claims_claimed_by_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_claimed_by_user_fkey FOREIGN KEY (claimed_by_user) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: coupon_claims coupon_claims_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_claims
    ADD CONSTRAINT coupon_claims_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.coupon_products(id) ON DELETE SET NULL;


--
-- Name: coupon_eligible_customers coupon_eligible_customers_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT coupon_eligible_customers_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.coupon_campaigns(id) ON DELETE CASCADE;


--
-- Name: coupon_eligible_customers coupon_eligible_customers_imported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_eligible_customers
    ADD CONSTRAINT coupon_eligible_customers_imported_by_fkey FOREIGN KEY (imported_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: coupon_products coupon_products_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.coupon_campaigns(id) ON DELETE CASCADE;


--
-- Name: coupon_products coupon_products_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: coupon_products coupon_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupon_products
    ADD CONSTRAINT coupon_products_product_id_fkey FOREIGN KEY (flyer_product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: customer_access_code_history customer_access_code_history_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_access_code_history customer_access_code_history_generated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_access_code_history
    ADD CONSTRAINT customer_access_code_history_generated_by_fkey FOREIGN KEY (generated_by) REFERENCES public.users(id);


--
-- Name: customer_app_media customer_app_media_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_app_media
    ADD CONSTRAINT customer_app_media_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: customer_product_requests customer_product_requests_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: customer_product_requests customer_product_requests_requester_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: customer_product_requests customer_product_requests_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_product_requests
    ADD CONSTRAINT customer_product_requests_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: customer_recovery_requests customer_recovery_requests_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_recovery_requests
    ADD CONSTRAINT customer_recovery_requests_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_recovery_requests customer_recovery_requests_processed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_recovery_requests
    ADD CONSTRAINT customer_recovery_requests_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(id);


--
-- Name: customers customers_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: day_off day_off_approval_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_approval_approved_by_fkey FOREIGN KEY (approval_approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: day_off day_off_approval_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_approval_requested_by_fkey FOREIGN KEY (approval_requested_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: day_off day_off_day_off_reason_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_day_off_reason_id_fkey FOREIGN KEY (day_off_reason_id) REFERENCES public.day_off_reasons(id) ON DELETE SET NULL;


--
-- Name: day_off day_off_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off
    ADD CONSTRAINT day_off_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: day_off_weekday day_off_weekday_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_off_weekday
    ADD CONSTRAINT day_off_weekday_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: default_incident_users default_incident_users_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.default_incident_users
    ADD CONSTRAINT default_incident_users_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: default_incident_users default_incident_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.default_incident_users
    ADD CONSTRAINT default_incident_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: deleted_bundle_offers deleted_bundle_offers_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_bundle_offers
    ADD CONSTRAINT deleted_bundle_offers_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES public.users(id);


--
-- Name: delivery_fee_tiers delivery_fee_tiers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: delivery_fee_tiers delivery_fee_tiers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: delivery_fee_tiers delivery_fee_tiers_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_fee_tiers
    ADD CONSTRAINT delivery_fee_tiers_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: delivery_service_settings delivery_service_settings_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_service_settings
    ADD CONSTRAINT delivery_service_settings_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: denomination_records denomination_records_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: denomination_records denomination_records_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_records
    ADD CONSTRAINT denomination_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: denomination_transactions denomination_transactions_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: denomination_transactions denomination_transactions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_transactions
    ADD CONSTRAINT denomination_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: denomination_user_preferences denomination_user_preferences_default_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: denomination_user_preferences denomination_user_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.denomination_user_preferences
    ADD CONSTRAINT denomination_user_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: desktop_themes desktop_themes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.desktop_themes
    ADD CONSTRAINT desktop_themes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: employee_checklist_assignments employee_checklist_assignments_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: employee_checklist_assignments employee_checklist_assignments_checklist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.hr_checklists(id) ON DELETE CASCADE;


--
-- Name: employee_checklist_assignments employee_checklist_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_checklist_assignments
    ADD CONSTRAINT employee_checklist_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: employee_fine_payments employee_fine_payments_processed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_fine_payments
    ADD CONSTRAINT employee_fine_payments_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: employee_official_holidays employee_official_holidays_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_official_holidays
    ADD CONSTRAINT employee_official_holidays_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: employee_official_holidays employee_official_holidays_official_holiday_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_official_holidays
    ADD CONSTRAINT employee_official_holidays_official_holiday_id_fkey FOREIGN KEY (official_holiday_id) REFERENCES public.official_holidays(id) ON DELETE CASCADE;


--
-- Name: erp_connections erp_connections_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_connections
    ADD CONSTRAINT erp_connections_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: erp_daily_sales erp_daily_sales_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.erp_daily_sales
    ADD CONSTRAINT erp_daily_sales_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: expense_requisitions expense_requisitions_expense_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_expense_category_id_fkey FOREIGN KEY (expense_category_id) REFERENCES public.expense_sub_categories(id);


--
-- Name: expense_requisitions expense_requisitions_internal_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_internal_user_id_fkey FOREIGN KEY (internal_user_id) REFERENCES public.users(id);


--
-- Name: expense_requisitions expense_requisitions_requester_ref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT expense_requisitions_requester_ref_id_fkey FOREIGN KEY (requester_ref_id) REFERENCES public.requesters(id);


--
-- Name: expense_sub_categories expense_sub_categories_parent_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sub_categories
    ADD CONSTRAINT expense_sub_categories_parent_category_id_fkey FOREIGN KEY (parent_category_id) REFERENCES public.expense_parent_categories(id) ON DELETE CASCADE;


--
-- Name: hr_analysed_attendance_data fk_analysed_employee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_analysed_attendance_data
    ADD CONSTRAINT fk_analysed_employee FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: button_permissions fk_button; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT fk_button FOREIGN KEY (button_id) REFERENCES public.sidebar_buttons(id) ON DELETE CASCADE;


--
-- Name: expense_requisitions fk_expense_requisitions_branch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_requisitions
    ADD CONSTRAINT fk_expense_requisitions_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: CONSTRAINT fk_expense_requisitions_branch ON expense_requisitions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_expense_requisitions_branch ON public.expense_requisitions IS 'Links expense requisitions to their branch. ON DELETE RESTRICT prevents deletion of branches with existing requisitions.';


--
-- Name: expense_scheduler fk_expense_scheduler_approver; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_approver FOREIGN KEY (approver_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: expense_scheduler fk_expense_scheduler_branch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: expense_scheduler fk_expense_scheduler_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_category FOREIGN KEY (expense_category_id) REFERENCES public.expense_sub_categories(id) ON DELETE SET NULL;


--
-- Name: expense_scheduler fk_expense_scheduler_co_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_co_user FOREIGN KEY (co_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: expense_scheduler fk_expense_scheduler_created_by; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_created_by FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: expense_scheduler fk_expense_scheduler_requisition; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_scheduler
    ADD CONSTRAINT fk_expense_scheduler_requisition FOREIGN KEY (requisition_id) REFERENCES public.expense_requisitions(id) ON DELETE SET NULL;


--
-- Name: button_sub_sections fk_main_section; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_sub_sections
    ADD CONSTRAINT fk_main_section FOREIGN KEY (main_section_id) REFERENCES public.button_main_sections(id) ON DELETE CASCADE;


--
-- Name: sidebar_buttons fk_main_section; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT fk_main_section FOREIGN KEY (main_section_id) REFERENCES public.button_main_sections(id) ON DELETE CASCADE;


--
-- Name: non_approved_payment_scheduler fk_non_approved_scheduler_approved_by; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_approved_by FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: non_approved_payment_scheduler fk_non_approved_scheduler_approver; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_approver FOREIGN KEY (approver_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: non_approved_payment_scheduler fk_non_approved_scheduler_branch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: non_approved_payment_scheduler fk_non_approved_scheduler_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_category FOREIGN KEY (expense_category_id) REFERENCES public.expense_sub_categories(id) ON DELETE RESTRICT;


--
-- Name: non_approved_payment_scheduler fk_non_approved_scheduler_co_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_co_user FOREIGN KEY (co_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: non_approved_payment_scheduler fk_non_approved_scheduler_created_by; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_created_by FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: non_approved_payment_scheduler fk_non_approved_scheduler_expense_scheduler; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.non_approved_payment_scheduler
    ADD CONSTRAINT fk_non_approved_scheduler_expense_scheduler FOREIGN KEY (expense_scheduler_id) REFERENCES public.expense_scheduler(id) ON DELETE SET NULL;


--
-- Name: notification_recipients fk_notification_recipients_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT fk_notification_recipients_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: push_subscriptions fk_push_sub_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT fk_push_sub_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: recurring_assignment_schedules fk_recurring_schedules_assignment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_assignment_schedules
    ADD CONSTRAINT fk_recurring_schedules_assignment FOREIGN KEY (assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;


--
-- Name: social_links fk_social_links_branch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_links
    ADD CONSTRAINT fk_social_links_branch FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: sidebar_buttons fk_sub_section; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidebar_buttons
    ADD CONSTRAINT fk_sub_section FOREIGN KEY (subsection_id) REFERENCES public.button_sub_sections(id) ON DELETE CASCADE;


--
-- Name: task_assignments fk_task_assignments_reassigned_from; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT fk_task_assignments_reassigned_from FOREIGN KEY (reassigned_from) REFERENCES public.task_assignments(id) ON DELETE SET NULL;


--
-- Name: button_permissions fk_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: flyer_offer_products flyer_offer_products_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.flyer_offers(id) ON DELETE CASCADE;


--
-- Name: flyer_offer_products flyer_offer_products_product_barcode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offer_products
    ADD CONSTRAINT flyer_offer_products_product_barcode_fkey FOREIGN KEY (product_barcode) REFERENCES public.products(barcode) ON DELETE CASCADE;


--
-- Name: flyer_offers flyer_offers_offer_name_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_offers
    ADD CONSTRAINT flyer_offers_offer_name_id_fkey FOREIGN KEY (offer_name_id) REFERENCES public.offer_names(id) ON DELETE SET NULL;


--
-- Name: products flyer_products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE SET NULL;


--
-- Name: products flyer_products_created_by_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_created_by_fkey1 FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: products flyer_products_modified_by_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_modified_by_fkey1 FOREIGN KEY (modified_by) REFERENCES auth.users(id);


--
-- Name: products flyer_products_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT flyer_products_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.product_units(id) ON DELETE RESTRICT;


--
-- Name: flyer_templates flyer_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: flyer_templates flyer_templates_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyer_templates
    ADD CONSTRAINT flyer_templates_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: frontend_builds frontend_builds_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frontend_builds
    ADD CONSTRAINT frontend_builds_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES auth.users(id);


--
-- Name: hr_basic_salary hr_basic_salary_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_basic_salary
    ADD CONSTRAINT hr_basic_salary_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: hr_checklist_operations hr_checklist_operations_box_operation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_box_operation_id_fkey FOREIGN KEY (box_operation_id) REFERENCES public.box_operations(id) ON DELETE SET NULL;


--
-- Name: hr_checklist_operations hr_checklist_operations_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: hr_checklist_operations hr_checklist_operations_checklist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.hr_checklists(id) ON DELETE CASCADE;


--
-- Name: hr_checklist_operations hr_checklist_operations_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_checklist_operations
    ADD CONSTRAINT hr_checklist_operations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE SET NULL;


--
-- Name: hr_employee_master hr_employee_master_current_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_current_branch_id_fkey FOREIGN KEY (current_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: hr_employee_master hr_employee_master_current_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_current_position_id_fkey FOREIGN KEY (current_position_id) REFERENCES public.hr_positions(id) ON DELETE SET NULL;


--
-- Name: hr_employee_master hr_employee_master_nationality_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_nationality_id_fkey FOREIGN KEY (nationality_id) REFERENCES public.nationalities(id);


--
-- Name: hr_employee_master hr_employee_master_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employee_master
    ADD CONSTRAINT hr_employee_master_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: hr_employees hr_employees_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_employees
    ADD CONSTRAINT hr_employees_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: hr_fingerprint_transactions hr_fingerprint_transactions_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_fingerprint_transactions
    ADD CONSTRAINT hr_fingerprint_transactions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: hr_position_assignments hr_position_assignments_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: hr_position_assignments hr_position_assignments_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.hr_departments(id);


--
-- Name: hr_position_assignments hr_position_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employees(id);


--
-- Name: hr_position_assignments hr_position_assignments_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_level_id_fkey FOREIGN KEY (level_id) REFERENCES public.hr_levels(id);


--
-- Name: hr_position_assignments hr_position_assignments_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_assignments
    ADD CONSTRAINT hr_position_assignments_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.hr_positions(id);


--
-- Name: hr_position_reporting_template hr_position_reporting_template_manager_position_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_1_fkey FOREIGN KEY (manager_position_1) REFERENCES public.hr_positions(id);


--
-- Name: hr_position_reporting_template hr_position_reporting_template_manager_position_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_2_fkey FOREIGN KEY (manager_position_2) REFERENCES public.hr_positions(id);


--
-- Name: hr_position_reporting_template hr_position_reporting_template_manager_position_3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_3_fkey FOREIGN KEY (manager_position_3) REFERENCES public.hr_positions(id);


--
-- Name: hr_position_reporting_template hr_position_reporting_template_manager_position_4_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_4_fkey FOREIGN KEY (manager_position_4) REFERENCES public.hr_positions(id);


--
-- Name: hr_position_reporting_template hr_position_reporting_template_manager_position_5_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_manager_position_5_fkey FOREIGN KEY (manager_position_5) REFERENCES public.hr_positions(id);


--
-- Name: hr_position_reporting_template hr_position_reporting_template_subordinate_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_position_reporting_template
    ADD CONSTRAINT hr_position_reporting_template_subordinate_position_id_fkey FOREIGN KEY (subordinate_position_id) REFERENCES public.hr_positions(id);


--
-- Name: hr_positions hr_positions_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_positions
    ADD CONSTRAINT hr_positions_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.hr_departments(id);


--
-- Name: hr_positions hr_positions_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_positions
    ADD CONSTRAINT hr_positions_level_id_fkey FOREIGN KEY (level_id) REFERENCES public.hr_levels(id);


--
-- Name: incident_actions incident_actions_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_actions
    ADD CONSTRAINT incident_actions_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;


--
-- Name: incident_actions incident_actions_incident_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incident_actions
    ADD CONSTRAINT incident_actions_incident_type_id_fkey FOREIGN KEY (incident_type_id) REFERENCES public.incident_types(id);


--
-- Name: incidents incidents_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: incidents incidents_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id);


--
-- Name: incidents incidents_incident_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_incident_type_id_fkey FOREIGN KEY (incident_type_id) REFERENCES public.incident_types(id);


--
-- Name: incidents incidents_violation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_violation_id_fkey FOREIGN KEY (violation_id) REFERENCES public.warning_violation(id);


--
-- Name: interface_permissions interface_permissions_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interface_permissions
    ADD CONSTRAINT interface_permissions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: interface_permissions interface_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interface_permissions
    ADD CONSTRAINT interface_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.lease_rent_properties(id) ON DELETE CASCADE;


--
-- Name: lease_rent_lease_parties lease_rent_lease_parties_property_space_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_lease_parties
    ADD CONSTRAINT lease_rent_lease_parties_property_space_id_fkey FOREIGN KEY (property_space_id) REFERENCES public.lease_rent_property_spaces(id) ON DELETE SET NULL;


--
-- Name: lease_rent_payments lease_rent_payments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_payments
    ADD CONSTRAINT lease_rent_payments_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: lease_rent_properties lease_rent_property_spaces_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_properties
    ADD CONSTRAINT lease_rent_property_spaces_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lease_rent_property_spaces lease_rent_property_spaces_created_by_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT lease_rent_property_spaces_created_by_fkey1 FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lease_rent_property_spaces lease_rent_property_spaces_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_property_spaces
    ADD CONSTRAINT lease_rent_property_spaces_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.lease_rent_properties(id) ON DELETE CASCADE;


--
-- Name: lease_rent_rent_parties lease_rent_rent_parties_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lease_rent_rent_parties lease_rent_rent_parties_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.lease_rent_properties(id) ON DELETE CASCADE;


--
-- Name: lease_rent_rent_parties lease_rent_rent_parties_property_space_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_rent_parties
    ADD CONSTRAINT lease_rent_rent_parties_property_space_id_fkey FOREIGN KEY (property_space_id) REFERENCES public.lease_rent_property_spaces(id) ON DELETE SET NULL;


--
-- Name: lease_rent_special_changes lease_rent_special_changes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_rent_special_changes
    ADD CONSTRAINT lease_rent_special_changes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: mobile_themes mobile_themes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile_themes
    ADD CONSTRAINT mobile_themes_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: multi_shift_date_wise multi_shift_date_wise_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_date_wise
    ADD CONSTRAINT multi_shift_date_wise_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: multi_shift_regular multi_shift_regular_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_regular
    ADD CONSTRAINT multi_shift_regular_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: multi_shift_weekday multi_shift_weekday_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_shift_weekday
    ADD CONSTRAINT multi_shift_weekday_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: near_expiry_reports near_expiry_reports_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: near_expiry_reports near_expiry_reports_reporter_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_reporter_user_id_fkey FOREIGN KEY (reporter_user_id) REFERENCES public.users(id);


--
-- Name: near_expiry_reports near_expiry_reports_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.near_expiry_reports
    ADD CONSTRAINT near_expiry_reports_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id);


--
-- Name: notification_attachments notification_attachments_notification_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_attachments
    ADD CONSTRAINT notification_attachments_notification_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- Name: notification_read_states notification_read_states_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_read_states
    ADD CONSTRAINT notification_read_states_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- Name: notification_recipients notification_recipients_notification_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_notification_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_task_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_task_assignment_id_fkey FOREIGN KEY (task_assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: offer_bundles offer_bundles_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_bundles
    ADD CONSTRAINT offer_bundles_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: offer_cart_tiers offer_cart_tiers_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_cart_tiers
    ADD CONSTRAINT offer_cart_tiers_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: offer_products offer_products_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT offer_products_added_by_fkey FOREIGN KEY (added_by) REFERENCES public.users(id);


--
-- Name: offer_products offer_products_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT offer_products_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: offer_products offer_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_products
    ADD CONSTRAINT offer_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: offer_usage_logs offer_usage_logs_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: offer_usage_logs offer_usage_logs_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offer_usage_logs
    ADD CONSTRAINT offer_usage_logs_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: offers offers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: offers offers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: order_audit_logs order_audit_logs_assigned_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_assigned_user_id_fkey FOREIGN KEY (assigned_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: order_audit_logs order_audit_logs_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_audit_logs order_audit_logs_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_audit_logs
    ADD CONSTRAINT order_audit_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: order_items order_items_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE SET NULL;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: order_items order_items_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.product_units(id) ON DELETE SET NULL;


--
-- Name: orders orders_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: orders orders_cancelled_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_cancelled_by_fkey FOREIGN KEY (cancelled_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: orders orders_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE RESTRICT;


--
-- Name: orders orders_delivery_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_delivery_person_id_fkey FOREIGN KEY (delivery_person_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: orders orders_picker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_picker_id_fkey FOREIGN KEY (picker_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: orders orders_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: overtime_registrations overtime_registrations_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.overtime_registrations
    ADD CONSTRAINT overtime_registrations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: pos_deduction_transfers pos_deduction_transfers_box_operation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_box_operation_id_fkey FOREIGN KEY (box_operation_id) REFERENCES public.box_operations(id) ON DELETE CASCADE;


--
-- Name: pos_deduction_transfers pos_deduction_transfers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: pos_deduction_transfers pos_deduction_transfers_cashier_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_cashier_user_id_fkey FOREIGN KEY (cashier_user_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: pos_deduction_transfers pos_deduction_transfers_closed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_closed_by_fkey FOREIGN KEY (closed_by) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: pos_deduction_transfers pos_deduction_transfers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_deduction_transfers
    ADD CONSTRAINT pos_deduction_transfers_id_fkey FOREIGN KEY (id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: processed_fingerprint_transactions processed_fingerprint_transactions_center_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processed_fingerprint_transactions
    ADD CONSTRAINT processed_fingerprint_transactions_center_id_fkey FOREIGN KEY (center_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: product_categories product_categories_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: product_request_bt product_request_bt_from_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_from_branch_id_fkey FOREIGN KEY (from_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: product_request_bt product_request_bt_requester_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: product_request_bt product_request_bt_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: product_request_bt product_request_bt_to_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_bt
    ADD CONSTRAINT product_request_bt_to_branch_id_fkey FOREIGN KEY (to_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: product_request_po product_request_po_from_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_from_branch_id_fkey FOREIGN KEY (from_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: product_request_po product_request_po_requester_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: product_request_po product_request_po_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: product_request_st product_request_st_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_st
    ADD CONSTRAINT product_request_st_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: product_request_st product_request_st_requester_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_st
    ADD CONSTRAINT product_request_st_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: product_request_st product_request_st_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_st
    ADD CONSTRAINT product_request_st_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: product_units product_units_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_units
    ADD CONSTRAINT product_units_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_approver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES public.users(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_pending_stock_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pending_stock_location_fkey FOREIGN KEY (pending_stock_location) REFERENCES public.branches(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_pending_stock_person_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_pending_stock_person_fkey FOREIGN KEY (pending_stock_person) REFERENCES public.users(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_purchase_voucher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_purchase_voucher_id_fkey FOREIGN KEY (purchase_voucher_id) REFERENCES public.purchase_vouchers(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_stock_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_stock_location_fkey FOREIGN KEY (stock_location) REFERENCES public.branches(id);


--
-- Name: purchase_voucher_items purchase_voucher_items_stock_person_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_voucher_items
    ADD CONSTRAINT purchase_voucher_items_stock_person_fkey FOREIGN KEY (stock_person) REFERENCES public.users(id);


--
-- Name: quick_task_assignments quick_task_assignments_assigned_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_assigned_to_user_id_fkey FOREIGN KEY (assigned_to_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quick_task_assignments quick_task_assignments_quick_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_assignments
    ADD CONSTRAINT quick_task_assignments_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;


--
-- Name: quick_task_comments quick_task_comments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: quick_task_comments quick_task_comments_quick_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_comments
    ADD CONSTRAINT quick_task_comments_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;


--
-- Name: quick_task_completions quick_task_completions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.quick_task_assignments(id) ON DELETE CASCADE;


--
-- Name: quick_task_completions quick_task_completions_completed_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_completed_by_user_id_fkey FOREIGN KEY (completed_by_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quick_task_completions quick_task_completions_quick_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;


--
-- Name: quick_task_completions quick_task_completions_verified_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_completions
    ADD CONSTRAINT quick_task_completions_verified_by_user_id_fkey FOREIGN KEY (verified_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: quick_task_files quick_task_files_quick_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_quick_task_id_fkey FOREIGN KEY (quick_task_id) REFERENCES public.quick_tasks(id) ON DELETE CASCADE;


--
-- Name: quick_task_files quick_task_files_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_files
    ADD CONSTRAINT quick_task_files_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: quick_task_user_preferences quick_task_user_preferences_default_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: quick_task_user_preferences quick_task_user_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_task_user_preferences
    ADD CONSTRAINT quick_task_user_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quick_tasks quick_tasks_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quick_tasks quick_tasks_assigned_to_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_assigned_to_branch_id_fkey FOREIGN KEY (assigned_to_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: quick_tasks quick_tasks_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id);


--
-- Name: quick_tasks quick_tasks_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_tasks
    ADD CONSTRAINT quick_tasks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_accountant_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_accountant_user_id_fkey FOREIGN KEY (accountant_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: receiving_records receiving_records_branch_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_branch_manager_user_id_fkey FOREIGN KEY (branch_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_inventory_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_inventory_manager_user_id_fkey FOREIGN KEY (inventory_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_purchasing_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_purchasing_manager_user_id_fkey FOREIGN KEY (purchasing_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_records receiving_records_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: receiving_records receiving_records_vendor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_records
    ADD CONSTRAINT receiving_records_vendor_fkey FOREIGN KEY (vendor_id, branch_id) REFERENCES public.vendors(erp_vendor_id, branch_id) ON DELETE RESTRICT;


--
-- Name: CONSTRAINT receiving_records_vendor_fkey ON receiving_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT receiving_records_vendor_fkey ON public.receiving_records IS 'Foreign key constraint linking receiving_records to vendors using composite key (vendor_id -> erp_vendor_id, branch_id -> branch_id)';


--
-- Name: receiving_tasks receiving_tasks_assigned_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_assigned_user_id_fkey FOREIGN KEY (assigned_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: receiving_tasks receiving_tasks_receiving_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_receiving_record_id_fkey FOREIGN KEY (receiving_record_id) REFERENCES public.receiving_records(id) ON DELETE CASCADE;


--
-- Name: receiving_tasks receiving_tasks_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_tasks
    ADD CONSTRAINT receiving_tasks_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.receiving_task_templates(id) ON DELETE SET NULL;


--
-- Name: receiving_user_defaults receiving_user_defaults_default_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_default_branch_id_fkey FOREIGN KEY (default_branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: receiving_user_defaults receiving_user_defaults_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receiving_user_defaults
    ADD CONSTRAINT receiving_user_defaults_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: regular_shift regular_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regular_shift
    ADD CONSTRAINT regular_shift_id_fkey FOREIGN KEY (id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: security_code_scroll_texts security_code_scroll_texts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_code_scroll_texts
    ADD CONSTRAINT security_code_scroll_texts_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: shelf_paper_templates shelf_paper_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shelf_paper_templates
    ADD CONSTRAINT shelf_paper_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: special_shift_date_wise special_shift_date_wise_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_date_wise
    ADD CONSTRAINT special_shift_date_wise_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: special_shift_weekday special_shift_weekday_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.special_shift_weekday
    ADD CONSTRAINT special_shift_weekday_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: task_assignments task_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: task_assignments task_assignments_assigned_to_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_to_branch_id_fkey FOREIGN KEY (assigned_to_branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: CONSTRAINT task_assignments_assigned_to_branch_id_fkey ON task_assignments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT task_assignments_assigned_to_branch_id_fkey ON public.task_assignments IS 'Foreign key relationship to branches table for branch assignments';


--
-- Name: task_assignments task_assignments_assigned_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_assigned_to_user_id_fkey FOREIGN KEY (assigned_to_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: task_assignments task_assignments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_assignments
    ADD CONSTRAINT task_assignments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: task_completions task_completions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;


--
-- Name: task_completions task_completions_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_completions
    ADD CONSTRAINT task_completions_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: task_images task_images_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_images
    ADD CONSTRAINT task_images_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: task_reminder_logs task_reminder_logs_assigned_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_assigned_to_user_id_fkey FOREIGN KEY (assigned_to_user_id) REFERENCES public.users(id);


--
-- Name: task_reminder_logs task_reminder_logs_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id);


--
-- Name: task_reminder_logs task_reminder_logs_quick_task_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_quick_task_assignment_id_fkey FOREIGN KEY (quick_task_assignment_id) REFERENCES public.quick_task_assignments(id) ON DELETE CASCADE;


--
-- Name: task_reminder_logs task_reminder_logs_task_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_reminder_logs
    ADD CONSTRAINT task_reminder_logs_task_assignment_id_fkey FOREIGN KEY (task_assignment_id) REFERENCES public.task_assignments(id) ON DELETE CASCADE;


--
-- Name: user_audit_logs user_audit_logs_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: user_audit_logs user_audit_logs_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_audit_logs user_audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_audit_logs
    ADD CONSTRAINT user_audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_device_sessions user_device_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_device_sessions
    ADD CONSTRAINT user_device_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_mobile_theme_assignments user_mobile_theme_assignments_theme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mobile_theme_assignments
    ADD CONSTRAINT user_mobile_theme_assignments_theme_id_fkey FOREIGN KEY (theme_id) REFERENCES public.mobile_themes(id) ON DELETE CASCADE;


--
-- Name: user_password_history user_password_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_password_history
    ADD CONSTRAINT user_password_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_theme_assignments user_theme_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_theme_assignments user_theme_assignments_theme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_theme_id_fkey FOREIGN KEY (theme_id) REFERENCES public.desktop_themes(id) ON DELETE CASCADE;


--
-- Name: user_theme_assignments user_theme_assignments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_theme_assignments
    ADD CONSTRAINT user_theme_assignments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: users users_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employees(id) ON DELETE SET NULL;


--
-- Name: users users_locked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_locked_by_fkey FOREIGN KEY (locked_by) REFERENCES public.users(id);


--
-- Name: variation_audit_log variation_audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variation_audit_log
    ADD CONSTRAINT variation_audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: vendor_payment_schedule vendor_payment_approval_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_approval_requested_by_fkey FOREIGN KEY (approval_requested_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: vendor_payment_schedule vendor_payment_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: vendor_payment_schedule vendor_payment_assigned_approver_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_assigned_approver_fkey FOREIGN KEY (assigned_approver_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: vendor_payment_schedule vendor_payment_schedule_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: vendor_payment_schedule vendor_payment_schedule_pr_excel_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_pr_excel_verified_by_fkey FOREIGN KEY (pr_excel_verified_by) REFERENCES public.users(id);


--
-- Name: vendor_payment_schedule vendor_payment_schedule_receiving_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_receiving_record_id_fkey FOREIGN KEY (receiving_record_id) REFERENCES public.receiving_records(id) ON DELETE CASCADE;


--
-- Name: vendor_payment_schedule vendor_payment_schedule_task_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_task_assignment_id_fkey FOREIGN KEY (task_assignment_id) REFERENCES public.task_assignments(id) ON DELETE SET NULL;


--
-- Name: vendor_payment_schedule vendor_payment_schedule_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_payment_schedule
    ADD CONSTRAINT vendor_payment_schedule_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE SET NULL;


--
-- Name: vendors vendors_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;


--
-- Name: view_offer view_offer_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.view_offer
    ADD CONSTRAINT view_offer_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: wa_auto_reply_triggers wa_auto_reply_triggers_follow_up_trigger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_follow_up_trigger_id_fkey FOREIGN KEY (follow_up_trigger_id) REFERENCES public.wa_auto_reply_triggers(id) ON DELETE SET NULL;


--
-- Name: wa_auto_reply_triggers wa_auto_reply_triggers_reply_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_reply_template_id_fkey FOREIGN KEY (reply_template_id) REFERENCES public.wa_templates(id) ON DELETE SET NULL;


--
-- Name: wa_auto_reply_triggers wa_auto_reply_triggers_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_auto_reply_triggers
    ADD CONSTRAINT wa_auto_reply_triggers_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_bot_flows wa_bot_flows_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_bot_flows
    ADD CONSTRAINT wa_bot_flows_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_broadcast_recipients wa_broadcast_recipients_broadcast_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_broadcast_id_fkey FOREIGN KEY (broadcast_id) REFERENCES public.wa_broadcasts(id) ON DELETE CASCADE;


--
-- Name: wa_broadcast_recipients wa_broadcast_recipients_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: wa_broadcasts wa_broadcasts_recipient_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_recipient_group_id_fkey FOREIGN KEY (recipient_group_id) REFERENCES public.wa_contact_groups(id) ON DELETE SET NULL;


--
-- Name: wa_broadcasts wa_broadcasts_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.wa_templates(id) ON DELETE SET NULL;


--
-- Name: wa_broadcasts wa_broadcasts_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcasts
    ADD CONSTRAINT wa_broadcasts_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_catalog_orders wa_catalog_orders_catalog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.wa_catalogs(id);


--
-- Name: wa_catalog_orders wa_catalog_orders_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_orders
    ADD CONSTRAINT wa_catalog_orders_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_catalog_products wa_catalog_products_catalog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.wa_catalogs(id) ON DELETE CASCADE;


--
-- Name: wa_catalog_products wa_catalog_products_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalog_products
    ADD CONSTRAINT wa_catalog_products_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_catalogs wa_catalogs_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_catalogs
    ADD CONSTRAINT wa_catalogs_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_contact_group_members wa_contact_group_members_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: wa_contact_group_members wa_contact_group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_contact_group_members
    ADD CONSTRAINT wa_contact_group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.wa_contact_groups(id) ON DELETE CASCADE;


--
-- Name: wa_conversations wa_conversations_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_conversations
    ADD CONSTRAINT wa_conversations_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: wa_conversations wa_conversations_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_conversations
    ADD CONSTRAINT wa_conversations_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_messages wa_messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.wa_conversations(id) ON DELETE CASCADE;


--
-- Name: wa_messages wa_messages_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_settings wa_settings_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_settings
    ADD CONSTRAINT wa_settings_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_templates wa_templates_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_templates
    ADD CONSTRAINT wa_templates_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: warning_sub_category warning_sub_category_main_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_sub_category
    ADD CONSTRAINT warning_sub_category_main_category_id_fkey FOREIGN KEY (main_category_id) REFERENCES public.warning_main_category(id) ON DELETE CASCADE;


--
-- Name: warning_violation warning_violation_main_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_main_category_id_fkey FOREIGN KEY (main_category_id) REFERENCES public.warning_main_category(id) ON DELETE CASCADE;


--
-- Name: warning_violation warning_violation_sub_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.warning_violation
    ADD CONSTRAINT warning_violation_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.warning_sub_category(id) ON DELETE CASCADE;


--
-- Name: employee_fine_payments Admins can manage all fine payments; Type: POLICY; Schema: public; Owner: -
--

   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.user_type = 'global'::public.user_type_enum)))));


--
-- Name: user_device_sessions Admins can view all device sessions; Type: POLICY; Schema: public; Owner: -
--

   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));


--
-- Name: expense_parent_categories Allow admin users to delete parent categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_sub_categories Allow admin users to delete sub categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_parent_categories Allow admin users to insert parent categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_sub_categories Allow admin users to insert sub categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_parent_categories Allow admin users to update parent categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_sub_categories Allow admin users to update sub categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: ai_chat_guide Allow all access to ai_chat_guide; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: approval_permissions Allow all access to approval_permissions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: approver_branch_access Allow all access to approver_branch_access; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: approver_visibility_config Allow all access to approver_visibility_config; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: asset_main_categories Allow all access to asset_main_categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: asset_sub_categories Allow all access to asset_sub_categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: assets Allow all access to assets; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: bank_reconciliations Allow all access to bank_reconciliations; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: branch_default_delivery_receivers Allow all access to branch_default_delivery_receivers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: branch_default_positions Allow all access to branch_default_positions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: break_reasons Allow all access to break_reasons; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: break_register Allow all access to break_register; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: customer_product_requests Allow all access to customer_product_requests; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: day_off_reasons Allow all access to day_off_reasons; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: default_incident_users Allow all access to default_incident_users; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: denomination_transactions Allow all access to denomination_transactions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: desktop_themes Allow all access to desktop_themes; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: employee_checklist_assignments Allow all access to employee_checklist_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_synced_products Allow all access to erp_synced_products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_analysed_attendance_data Allow all access to hr_analysed_attendance_data; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_basic_salary Allow all access to hr_basic_salary; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_checklist_operations Allow all access to hr_checklist_operations; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_checklist_questions Allow all access to hr_checklist_questions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_checklists Allow all access to hr_checklists; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_employee_master Allow all access to hr_employee_master; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_insurance_companies Allow all access to hr_insurance_companies; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: incident_actions Allow all access to incident_actions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: incident_types Allow all access to incident_types; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: incidents Allow all access to incidents; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: lease_rent_lease_parties Allow all access to lease_rent_lease_parties; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: lease_rent_payments Allow all access to lease_rent_payments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: lease_rent_properties Allow all access to lease_rent_properties; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: lease_rent_property_spaces Allow all access to lease_rent_property_spaces; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: lease_rent_rent_parties Allow all access to lease_rent_rent_parties; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: mobile_themes Allow all access to mobile_themes; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: multi_shift_date_wise Allow all access to multi_shift_date_wise; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: multi_shift_regular Allow all access to multi_shift_regular; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: multi_shift_weekday Allow all access to multi_shift_weekday; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: nationalities Allow all access to nationalities; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: near_expiry_reports Allow all access to near_expiry_reports; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_names Allow all access to offer_names; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: pos_deduction_transfers Allow all access to pos_deduction_transfers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: processed_fingerprint_transactions Allow all access to processed_fingerprint_transactions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: product_categories Allow all access to product_categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: product_request_bt Allow all access to product_request_bt; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: product_request_po Allow all access to product_request_po; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: product_request_st Allow all access to product_request_st; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: product_units Allow all access to product_units; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: push_subscriptions Allow all access to push_subscriptions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: receiving_user_defaults Allow all access to receiving_user_defaults; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: regular_shift Allow all access to regular_shift; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: shelf_paper_fonts Allow all access to shelf_paper_fonts; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_favorite_buttons Allow all access to user_favorite_buttons; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_mobile_theme_assignments Allow all access to user_mobile_theme_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_theme_assignments Allow all access to user_theme_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_voice_preferences Allow all access to user_voice_preferences; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_accounts Allow all access to wa_accounts; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_broadcast_recipients Allow all access to wa_broadcast_recipients; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_broadcasts Allow all access to wa_broadcasts; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_conversations Allow all access to wa_conversations; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_templates Allow all access to wa_templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: warning_main_category Allow all access to warning_main_category; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: warning_sub_category Allow all access to warning_sub_category; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: warning_violation Allow all access to warning_violation; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_voice_preferences Allow all operations for authenticated users; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: day_off Allow all operations on day_off; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: day_off_weekday Allow all operations on day_off_weekday; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: employee_official_holidays Allow all operations on employee_official_holidays; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: official_holidays Allow all operations on official_holidays; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: special_shift_date_wise Allow all operations on special_shift_date_wise; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: approval_permissions Allow all to view approval permissions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_employee_master Allow all users to view hr_employee_master table; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: users Allow all users to view users table; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: approval_permissions Allow anon insert approval_permissions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: biometric_connections Allow anon insert biometric_connections; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: bogo_offer_rules Allow anon insert bogo_offer_rules; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: coupon_campaigns Allow anon insert coupon_campaigns; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: coupon_claims Allow anon insert coupon_claims; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: coupon_eligible_customers Allow anon insert coupon_eligible_customers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: coupon_products Allow anon insert coupon_products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: customer_access_code_history Allow anon insert customer_access_code_history; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: customer_app_media Allow anon insert customer_app_media; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: customer_recovery_requests Allow anon insert customer_recovery_requests; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: customers Allow anon insert customers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: deleted_bundle_offers Allow anon insert deleted_bundle_offers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: delivery_fee_tiers Allow anon insert delivery_fee_tiers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: delivery_service_settings Allow anon insert delivery_service_settings; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: employee_fine_payments Allow anon insert employee_fine_payments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_connections Allow anon insert erp_connections; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_daily_sales Allow anon insert erp_daily_sales; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_parent_categories Allow anon insert expense_parent_categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Allow anon insert expense_requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_scheduler Allow anon insert expense_scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_sub_categories Allow anon insert expense_sub_categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: flyer_offer_products Allow anon insert flyer_offer_products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: flyer_offers Allow anon insert flyer_offers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: flyer_templates Allow anon insert flyer_templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_departments Allow anon insert hr_departments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_employee_master Allow anon insert hr_employee_master; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_employees Allow anon insert hr_employees; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_fingerprint_transactions Allow anon insert hr_fingerprint_transactions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_levels Allow anon insert hr_levels; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_position_assignments Allow anon insert hr_position_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_position_reporting_template Allow anon insert hr_position_reporting_template; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_positions Allow anon insert hr_positions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: interface_permissions Allow anon insert interface_permissions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: non_approved_payment_scheduler Allow anon insert non_approved_payment_scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: notification_attachments Allow anon insert notification_attachments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: notification_read_states Allow anon insert notification_read_states; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: notification_recipients Allow anon insert notification_recipients; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: notifications Allow anon insert notifications; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_bundles Allow anon insert offer_bundles; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_cart_tiers Allow anon insert offer_cart_tiers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_products Allow anon insert offer_products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_usage_logs Allow anon insert offer_usage_logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: order_audit_logs Allow anon insert order_audit_logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: order_items Allow anon insert order_items; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: orders Allow anon insert orders; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_branch Allow anon insert privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_master Allow anon insert privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_assignments Allow anon insert quick_task_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_comments Allow anon insert quick_task_comments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_completions Allow anon insert quick_task_completions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_files Allow anon insert quick_task_files; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_user_preferences Allow anon insert quick_task_user_preferences; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_tasks Allow anon insert quick_tasks; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: receiving_task_templates Allow anon insert receiving_task_templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: receiving_tasks Allow anon insert receiving_tasks; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: recurring_assignment_schedules Allow anon insert recurring_assignment_schedules; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: recurring_schedule_check_log Allow anon insert recurring_schedule_check_log; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: requesters Allow anon insert requesters; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: shelf_paper_templates Allow anon insert shelf_paper_templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_assignments Allow anon insert task_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_completions Allow anon insert task_completions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_images Allow anon insert task_images; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_reminder_logs Allow anon insert task_reminder_logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: tasks Allow anon insert tasks; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_audit_logs Allow anon insert user_audit_logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_device_sessions Allow anon insert user_device_sessions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_password_history Allow anon insert user_password_history; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_sessions Allow anon insert user_sessions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: users Allow anon insert users; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: variation_audit_log Allow anon insert variation_audit_log; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: view_offer Allow anon insert view_offer; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: security_code_scroll_texts Allow anon read; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: security_code_scroll_texts Allow authenticated delete; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_catalog_orders Allow authenticated full access on wa_catalog_orders; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_catalog_products Allow authenticated full access on wa_catalog_products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_catalogs Allow authenticated full access on wa_catalogs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: security_code_scroll_texts Allow authenticated insert; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: security_code_scroll_texts Allow authenticated read; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: security_code_scroll_texts Allow authenticated update; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: deleted_bundle_offers Allow authenticated users to archive offers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_connections Allow authenticated users to create ERP connections; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Allow authenticated users to create expense requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_scheduler Allow authenticated users to create expense scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: non_approved_payment_scheduler Allow authenticated users to create non approved scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_branch Allow authenticated users to create privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_master Allow authenticated users to create privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: view_offer Allow authenticated users to create view_offer; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_connections Allow authenticated users to delete ERP connections; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Allow authenticated users to delete requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Allow authenticated users to insert requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_connections Allow authenticated users to read ERP connections; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Allow authenticated users to read expense requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_scheduler Allow authenticated users to read expense scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: non_approved_payment_scheduler Allow authenticated users to read non approved scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_parent_categories Allow authenticated users to read parent categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_branch Allow authenticated users to read privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_master Allow authenticated users to read privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Allow authenticated users to read requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_daily_sales Allow authenticated users to read sales data; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_sub_categories Allow authenticated users to read sub categories; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: view_offer Allow authenticated users to read view_offer; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_connections Allow authenticated users to update ERP connections; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Allow authenticated users to update expense requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_scheduler Allow authenticated users to update expense scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: non_approved_payment_scheduler Allow authenticated users to update non approved scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_branch Allow authenticated users to update privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_master Allow authenticated users to update privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Allow authenticated users to update requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: view_offer Allow authenticated users to update view_offer; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: deleted_bundle_offers Allow authenticated users to view deleted offers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: bogo_offer_rules Allow read access to bogo_offer_rules; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: bogo_offer_rules Allow service role full access to bogo_offer_rules; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: hr_employee_master Allow service role full access to hr_employee_master; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_assignments Allow service role full access to quick_task_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_completions Allow service role full access to quick_task_completions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_tasks Allow service role full access to quick_tasks; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_assignments Allow service role full access to task_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_completions Allow service role full access to task_completions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: tasks Allow service role full access to tasks; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: users Allow service role full access to users; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_daily_sales Allow service role to manage sales data; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: app_icons Anyone can view app icons; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: app_icons Authenticated users can delete app icons; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: app_icons Authenticated users can insert app icons; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: frontend_builds Authenticated users can insert frontend_builds; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_products Authenticated users can manage offer products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: frontend_builds Authenticated users can read frontend_builds; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: app_icons Authenticated users can update app icons; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_reminder_logs Authenticated users can view all reminder logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: notifications Emergency: Allow all inserts for notifications; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_assignments Emergency: Allow all inserts for task_assignments; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: tasks Emergency: Allow all inserts for tasks; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: social_links Enable all access for social_links; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: view_offer Enable all access for view_offer; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: system_api_keys Enable all access to system_api_keys; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: biometric_connections Enable delete for authenticated users; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: biometric_connections Enable insert for authenticated users; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: biometric_connections Enable read for authenticated users; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: biometric_connections Enable update for authenticated users; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_completions Managers can verify completions; Type: POLICY; Schema: public; Owner: -
--

   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));


--
-- Name: quick_task_completions Managers can view all completions; Type: POLICY; Schema: public; Owner: -
--

   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));


--
-- Name: recurring_schedule_check_log Only global users can view check logs; Type: POLICY; Schema: public; Owner: -
--

   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));


--
-- Name: offer_products Public can view active offer products; Type: POLICY; Schema: public; Owner: -
--

   FROM public.offers
  WHERE ((offers.is_active = true) AND (offers.start_date <= now()) AND (offers.end_date >= now())))));


--
-- Name: task_reminder_logs Service role can insert reminder logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: erp_sync_logs Service role full access on erp_sync_logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_ai_bot_config Service role full access on wa_ai_bot_config; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_auto_reply_triggers Service role full access on wa_auto_reply_triggers; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_contact_group_members Service role full access on wa_contact_group_members; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_contact_groups Service role full access on wa_contact_groups; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_messages Service role full access on wa_messages; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: wa_settings Service role full access on wa_settings; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: whatsapp_message_log Service role full access on whatsapp_message_log; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: frontend_builds Service role full access to frontend_builds; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_requisitions Service role has full access to expense requisitions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: expense_scheduler Service role has full access to expense scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: non_approved_payment_scheduler Service role has full access to non approved scheduler; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_branch Service role has full access to privilege_cards_branch; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: privilege_cards_master Service role has full access to privilege_cards_master; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: view_offer Service role has full access to view_offer; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_assignments Simple create task assignments policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple create task assignments policy" ON task_assignments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple create task assignments policy" ON public.task_assignments IS 'Allow all users to create task assignments';


--
-- Name: task_completions Simple create task completions policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple create task completions policy" ON task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple create task completions policy" ON public.task_completions IS 'Allow all users to create task completions';


--
-- Name: task_images Simple create task images policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple create task images policy" ON task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple create task images policy" ON public.task_images IS 'Allow all users to create task images';


--
-- Name: tasks Simple create tasks policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple create tasks policy" ON tasks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple create tasks policy" ON public.tasks IS 'Allow all users to create tasks';


--
-- Name: task_images Simple delete task images policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple delete task images policy" ON task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple delete task images policy" ON public.task_images IS 'Allow all users to delete task images';


--
-- Name: task_assignments Simple update task assignments policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple update task assignments policy" ON task_assignments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple update task assignments policy" ON public.task_assignments IS 'Allow all users to update task assignments';


--
-- Name: task_completions Simple update task completions policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple update task completions policy" ON task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple update task completions policy" ON public.task_completions IS 'Allow all users to update task completions';


--
-- Name: task_images Simple update task images policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple update task images policy" ON task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple update task images policy" ON public.task_images IS 'Allow all users to update task images';


--
-- Name: tasks Simple update tasks policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple update tasks policy" ON tasks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple update tasks policy" ON public.tasks IS 'Allow all users to update tasks';


--
-- Name: task_assignments Simple view task assignments policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple view task assignments policy" ON task_assignments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple view task assignments policy" ON public.task_assignments IS 'Allow viewing all task assignments';


--
-- Name: task_completions Simple view task completions policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple view task completions policy" ON task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple view task completions policy" ON public.task_completions IS 'Allow viewing all task completions';


--
-- Name: task_images Simple view task images policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple view task images policy" ON task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple view task images policy" ON public.task_images IS 'Allow viewing all task images';


--
-- Name: tasks Simple view tasks policy; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: POLICY "Simple view tasks policy" ON tasks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Simple view tasks policy" ON public.tasks IS 'Allow viewing all non-deleted tasks';


--
-- Name: variation_audit_log System can insert variation audit logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: shelf_paper_templates Users can create templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_products Users can delete offer products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: shelf_paper_templates Users can delete own templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_user_preferences Users can delete their own preferences; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_products Users can insert offer products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: notification_read_states Users can insert own read states; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: requesters Users can insert requesters; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_completions Users can insert their own completions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_user_preferences Users can insert their own preferences; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: user_device_sessions Users can manage their own device sessions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_products Users can update offer products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: notification_read_states Users can update own read states; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: shelf_paper_templates Users can update own templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: requesters Users can update requesters; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_completions Users can update their own completions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_user_preferences Users can update their own preferences; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: flyer_templates Users can view active flyer templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: shelf_paper_templates Users can view active templates; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: requesters Users can view all requesters; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: offer_products Users can view offer products; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: notification_read_states Users can view own read states; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_completions Users can view their own completions; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: quick_task_user_preferences Users can view their own preferences; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: task_reminder_logs Users can view their own reminder logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: variation_audit_log Users can view variation audit logs; Type: POLICY; Schema: public; Owner: -
--



--
-- Name: access_code_otp; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.access_code_otp ENABLE ROW LEVEL SECURITY;

--
-- Name: offer_cart_tiers admin_all_offer_cart_tiers; Type: POLICY; Schema: public; Owner: -
--

