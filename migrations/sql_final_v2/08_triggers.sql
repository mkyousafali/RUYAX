--

CREATE TRIGGER ai_chat_guide_timestamp_update BEFORE UPDATE ON public.ai_chat_guide FOR EACH ROW EXECUTE FUNCTION public.update_ai_chat_guide_timestamp();

--

CREATE TRIGGER approver_visibility_config_timestamp_update BEFORE UPDATE ON public.approver_visibility_config FOR EACH ROW EXECUTE FUNCTION public.update_approver_visibility_config_timestamp();

--

CREATE TRIGGER bank_reconciliations_timestamp_update BEFORE UPDATE ON public.bank_reconciliations FOR EACH ROW EXECUTE FUNCTION public.update_bank_reconciliations_timestamp();

--

CREATE TRIGGER box_operations_updated_at BEFORE UPDATE ON public.box_operations FOR EACH ROW EXECUTE FUNCTION public.update_box_operations_updated_at();

--

CREATE TRIGGER branch_default_positions_timestamp_update BEFORE UPDATE ON public.branch_default_positions FOR EACH ROW EXECUTE FUNCTION public.update_branch_default_positions_timestamp();

--

CREATE TRIGGER branches_notify_trigger AFTER INSERT OR DELETE OR UPDATE ON public.branches FOR EACH ROW EXECUTE FUNCTION public.notify_branches_change();

--

CREATE TRIGGER calculate_receiving_amounts_trigger BEFORE INSERT OR UPDATE ON public.receiving_records FOR EACH ROW EXECUTE FUNCTION public.calculate_receiving_amounts();

--

CREATE TRIGGER calculate_working_hours_trigger BEFORE INSERT OR UPDATE ON public.regular_shift FOR EACH ROW EXECUTE FUNCTION public.calculate_working_hours();

--

CREATE TRIGGER cleanup_assignment_notifications_trigger AFTER DELETE ON public.task_assignments FOR EACH ROW EXECUTE FUNCTION public.trigger_cleanup_assignment_notifications();

--

CREATE TRIGGER cleanup_task_notifications_trigger AFTER DELETE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.trigger_cleanup_task_notifications();

--

CREATE TRIGGER day_off_reasons_timestamp_update BEFORE UPDATE ON public.day_off_reasons FOR EACH ROW EXECUTE FUNCTION public.update_day_off_reasons_timestamp();

--

CREATE TRIGGER day_off_timestamp_trigger BEFORE UPDATE ON public.day_off FOR EACH ROW EXECUTE FUNCTION public.update_day_off_timestamp();

--

CREATE TRIGGER day_off_weekday_updated_at_trigger BEFORE UPDATE ON public.day_off_weekday FOR EACH ROW EXECUTE FUNCTION public.update_day_off_weekday_updated_at();

--

CREATE TRIGGER denomination_records_audit AFTER INSERT OR DELETE OR UPDATE ON public.denomination_records FOR EACH ROW EXECUTE FUNCTION public.denomination_audit_trigger();

--

CREATE TRIGGER denomination_records_updated_at BEFORE UPDATE ON public.denomination_records FOR EACH ROW EXECUTE FUNCTION public.update_denomination_updated_at();

--

CREATE TRIGGER denomination_transactions_timestamp_update BEFORE UPDATE ON public.denomination_transactions FOR EACH ROW EXECUTE FUNCTION public.update_denomination_transactions_timestamp();

--

CREATE TRIGGER denomination_types_updated_at BEFORE UPDATE ON public.denomination_types FOR EACH ROW EXECUTE FUNCTION public.update_denomination_updated_at();

--

CREATE TRIGGER desktop_themes_timestamp_update BEFORE UPDATE ON public.desktop_themes FOR EACH ROW EXECUTE FUNCTION public.update_desktop_themes_timestamp();

--

CREATE TRIGGER erp_daily_sales_notify_trigger AFTER INSERT OR DELETE OR UPDATE ON public.erp_daily_sales FOR EACH ROW EXECUTE FUNCTION public.notify_erp_daily_sales_change();

--

CREATE TRIGGER expense_scheduler_updated_at BEFORE UPDATE ON public.expense_scheduler FOR EACH ROW EXECUTE FUNCTION public.update_expense_scheduler_updated_at();

--

CREATE TRIGGER hr_checklist_operations_timestamp_update BEFORE UPDATE ON public.hr_checklist_operations FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklist_operations_timestamp();

--

CREATE TRIGGER hr_checklist_questions_timestamp_update BEFORE UPDATE ON public.hr_checklist_questions FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklist_questions_timestamp();

--

CREATE TRIGGER hr_checklists_timestamp_update BEFORE UPDATE ON public.hr_checklists FOR EACH ROW EXECUTE FUNCTION public.update_hr_checklists_timestamp();

--

CREATE TRIGGER hr_employee_master_timestamp_update BEFORE UPDATE ON public.hr_employee_master FOR EACH ROW EXECUTE FUNCTION public.update_hr_employee_master_timestamp();

--

CREATE TRIGGER issue_types_updated_at_trigger BEFORE UPDATE ON public.purchase_voucher_issue_types FOR EACH ROW EXECUTE FUNCTION public.update_issue_types_updated_at();

--

CREATE TRIGGER lease_rent_lease_parties_timestamp_update BEFORE UPDATE ON public.lease_rent_lease_parties FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_lease_parties_timestamp();

--

CREATE TRIGGER lease_rent_properties_timestamp_update BEFORE UPDATE ON public.lease_rent_properties FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_property_spaces_timestamp();

--

CREATE TRIGGER lease_rent_property_spaces_timestamp_update BEFORE UPDATE ON public.lease_rent_property_spaces FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_property_spaces_timestamp();

--

CREATE TRIGGER lease_rent_rent_parties_timestamp_update BEFORE UPDATE ON public.lease_rent_rent_parties FOR EACH ROW EXECUTE FUNCTION public.update_lease_rent_rent_parties_timestamp();

--

CREATE TRIGGER multi_shift_date_wise_timestamp_update BEFORE UPDATE ON public.multi_shift_date_wise FOR EACH ROW EXECUTE FUNCTION public.update_multi_shift_date_wise_timestamp();

--

CREATE TRIGGER multi_shift_regular_timestamp_update BEFORE UPDATE ON public.multi_shift_regular FOR EACH ROW EXECUTE FUNCTION public.update_multi_shift_regular_timestamp();

--

CREATE TRIGGER multi_shift_weekday_timestamp_update BEFORE UPDATE ON public.multi_shift_weekday FOR EACH ROW EXECUTE FUNCTION public.update_multi_shift_weekday_timestamp();

--

CREATE TRIGGER non_approved_scheduler_updated_at BEFORE UPDATE ON public.non_approved_payment_scheduler FOR EACH ROW EXECUTE FUNCTION public.update_non_approved_scheduler_updated_at();

--

CREATE TRIGGER official_holidays_timestamp_trigger BEFORE UPDATE ON public.official_holidays FOR EACH ROW EXECUTE FUNCTION public.update_official_holidays_timestamp();

--

CREATE TRIGGER product_request_bt_timestamp_update BEFORE UPDATE ON public.product_request_bt FOR EACH ROW EXECUTE FUNCTION public.update_product_request_bt_timestamp();

--

CREATE TRIGGER product_request_po_timestamp_update BEFORE UPDATE ON public.product_request_po FOR EACH ROW EXECUTE FUNCTION public.update_product_request_po_timestamp();

--

CREATE TRIGGER product_request_st_timestamp_update BEFORE UPDATE ON public.product_request_st FOR EACH ROW EXECUTE FUNCTION public.update_product_request_st_timestamp();

--

CREATE TRIGGER purchase_voucher_items_updated_at_trigger BEFORE UPDATE ON public.purchase_voucher_items FOR EACH ROW EXECUTE FUNCTION public.update_purchase_voucher_items_updated_at();

--

CREATE TRIGGER purchase_vouchers_updated_at_trigger BEFORE UPDATE ON public.purchase_vouchers FOR EACH ROW EXECUTE FUNCTION public.update_purchase_vouchers_updated_at();

--

CREATE TRIGGER receiving_user_defaults_timestamp_update BEFORE UPDATE ON public.receiving_user_defaults FOR EACH ROW EXECUTE FUNCTION public.update_receiving_user_defaults_timestamp();

--

CREATE TRIGGER regular_shift_timestamp_update BEFORE UPDATE ON public.regular_shift FOR EACH ROW EXECUTE FUNCTION public.update_regular_shift_timestamp();

--

CREATE TRIGGER set_branch_delivery_receivers_updated_at BEFORE UPDATE ON public.branch_default_delivery_receivers FOR EACH ROW EXECUTE FUNCTION public.update_branch_delivery_receivers_updated_at();

--

CREATE TRIGGER set_push_subscriptions_updated_at BEFORE UPDATE ON public.push_subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_push_subscriptions_updated_at();

--

CREATE TRIGGER social_links_updated_at_trigger BEFORE UPDATE ON public.social_links FOR EACH ROW EXECUTE FUNCTION public.update_social_links_updated_at();

--

CREATE TRIGGER special_shift_date_wise_timestamp_trigger BEFORE UPDATE ON public.special_shift_date_wise FOR EACH ROW EXECUTE FUNCTION public.update_special_shift_date_wise_timestamp();

--

CREATE TRIGGER special_shift_weekday_timestamp_update BEFORE UPDATE ON public.special_shift_weekday FOR EACH ROW EXECUTE FUNCTION public.update_special_shift_weekday_timestamp();

--

CREATE TRIGGER sync_requisition_balance_trigger AFTER INSERT OR UPDATE ON public.expense_scheduler FOR EACH ROW EXECUTE FUNCTION public.sync_requisition_balance();

--

CREATE TRIGGER sync_roles_on_position_changes AFTER INSERT OR DELETE OR UPDATE ON public.hr_positions FOR EACH ROW EXECUTE FUNCTION public.sync_user_roles_from_positions();

--

CREATE TRIGGER system_api_keys_timestamp_update BEFORE UPDATE ON public.system_api_keys FOR EACH ROW EXECUTE FUNCTION public.update_system_api_keys_timestamp();

--

CREATE TRIGGER track_media_activation BEFORE UPDATE ON public.customer_app_media FOR EACH ROW EXECUTE FUNCTION public.track_media_activation();

--

CREATE TRIGGER trg_app_icons_updated_at BEFORE UPDATE ON public.app_icons FOR EACH ROW EXECUTE FUNCTION public.update_app_icons_updated_at();

--

CREATE TRIGGER trg_generate_insurance_company_id BEFORE INSERT ON public.hr_insurance_companies FOR EACH ROW EXECUTE FUNCTION public.generate_insurance_company_id();

--

CREATE TRIGGER trg_update_final_bill_amount BEFORE INSERT OR UPDATE OF discount_amount, grr_amount, pri_amount, bill_amount ON public.vendor_payment_schedule FOR EACH ROW EXECUTE FUNCTION public.update_final_bill_amount_on_adjustment();

--

CREATE TRIGGER trigger_adjust_product_stock BEFORE INSERT ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.adjust_product_stock_on_order_insert();

--

CREATE TRIGGER trigger_auto_create_payment_schedule AFTER INSERT OR UPDATE OF certificate_url ON public.receiving_records FOR EACH ROW EXECUTE FUNCTION public.auto_create_payment_schedule();

--

CREATE TRIGGER trigger_calculate_flyer_product_profit BEFORE INSERT OR UPDATE OF sale_price, cost ON public.products FOR EACH ROW EXECUTE FUNCTION public.calculate_flyer_product_profit();

--

CREATE TRIGGER trigger_copy_completion_requirements AFTER INSERT ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.copy_completion_requirements_to_assignment();

--

CREATE TRIGGER trigger_create_default_interface_permissions AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.create_default_interface_permissions();

--

CREATE TRIGGER trigger_create_notification_recipients AFTER INSERT ON public.notifications FOR EACH ROW WHEN (((new.status)::text = 'published'::text)) EXECUTE FUNCTION public.create_notification_recipients();

--

CREATE TRIGGER trigger_create_quick_task_notification AFTER INSERT ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.create_quick_task_notification();

--

CREATE TRIGGER trigger_customer_push_on_status_change AFTER INSERT ON public.order_audit_logs FOR EACH ROW WHEN (((new.action_type)::text = 'status_change'::text)) EXECUTE FUNCTION public.notify_customer_order_status_change();

--

CREATE TRIGGER trigger_ensure_single_default_flyer_template BEFORE INSERT OR UPDATE OF is_default ON public.flyer_templates FOR EACH ROW WHEN ((new.is_default = true)) EXECUTE FUNCTION public.ensure_single_default_flyer_template();

--

CREATE TRIGGER trigger_link_offer_usage_to_order AFTER INSERT ON public.order_items FOR EACH ROW WHEN (((new.has_offer = true) AND (new.offer_id IS NOT NULL))) EXECUTE FUNCTION public.trigger_log_order_offer_usage();

--

CREATE TRIGGER trigger_new_order_notification AFTER INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.trigger_notify_new_order();

--

CREATE TRIGGER trigger_order_items_delete_totals AFTER DELETE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.trigger_update_order_totals();

--

CREATE TRIGGER trigger_order_items_insert_totals AFTER INSERT ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.trigger_update_order_totals();

--

CREATE TRIGGER trigger_order_items_update_totals AFTER UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.trigger_update_order_totals();

--

CREATE TRIGGER trigger_order_status_change_audit AFTER UPDATE ON public.orders FOR EACH ROW WHEN (((old.order_status)::text IS DISTINCT FROM (new.order_status)::text)) EXECUTE FUNCTION public.trigger_order_status_audit();

--

CREATE TRIGGER trigger_order_task_completion AFTER UPDATE ON public.quick_task_assignments FOR EACH ROW WHEN ((((old.status)::text IS DISTINCT FROM (new.status)::text) AND ((new.status)::text = 'completed'::text))) EXECUTE FUNCTION public.handle_order_task_completion();

--

CREATE TRIGGER trigger_sync_erp_on_completion AFTER INSERT OR UPDATE ON public.task_completions FOR EACH ROW EXECUTE FUNCTION public.trigger_sync_erp_reference_on_task_completion();

--

CREATE TRIGGER trigger_update_bogo_offer_rules_updated_at BEFORE UPDATE ON public.bogo_offer_rules FOR EACH ROW EXECUTE FUNCTION public.update_bogo_offer_rules_updated_at();

--

CREATE TRIGGER trigger_update_branches_updated_at BEFORE UPDATE ON public.branches FOR EACH ROW EXECUTE FUNCTION public.update_branches_updated_at();

--

CREATE TRIGGER trigger_update_coupon_campaigns_updated_at BEFORE UPDATE ON public.coupon_campaigns FOR EACH ROW EXECUTE FUNCTION public.update_coupon_campaigns_updated_at();

--

CREATE TRIGGER trigger_update_coupon_products_updated_at BEFORE UPDATE ON public.coupon_products FOR EACH ROW EXECUTE FUNCTION public.update_coupon_products_updated_at();

--

CREATE TRIGGER trigger_update_customer_recovery_requests_updated_at BEFORE UPDATE ON public.customer_recovery_requests FOR EACH ROW EXECUTE FUNCTION public.update_customer_recovery_requests_updated_at();

--

CREATE TRIGGER trigger_update_customers_updated_at BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.update_customers_updated_at();

--

CREATE TRIGGER trigger_update_deadline_datetime BEFORE INSERT OR UPDATE OF deadline_date, deadline_time ON public.task_assignments FOR EACH ROW EXECUTE FUNCTION public.update_deadline_datetime();

--

CREATE TRIGGER trigger_update_delivery_settings_timestamp BEFORE UPDATE ON public.delivery_service_settings FOR EACH ROW EXECUTE FUNCTION public.update_delivery_tiers_timestamp();

--

CREATE TRIGGER trigger_update_delivery_tiers_timestamp BEFORE UPDATE ON public.delivery_fee_tiers FOR EACH ROW EXECUTE FUNCTION public.update_delivery_tiers_timestamp();

--

CREATE TRIGGER trigger_update_flyer_templates_updated_at BEFORE UPDATE ON public.flyer_templates FOR EACH ROW EXECUTE FUNCTION public.update_flyer_templates_updated_at();

--

CREATE TRIGGER trigger_update_interface_permissions_updated_at BEFORE UPDATE ON public.interface_permissions FOR EACH ROW EXECUTE FUNCTION public.update_interface_permissions_updated_at();

--

CREATE TRIGGER trigger_update_near_expiry_reports_updated_at BEFORE UPDATE ON public.near_expiry_reports FOR EACH ROW EXECUTE FUNCTION public.update_near_expiry_reports_updated_at();

--

CREATE TRIGGER trigger_update_offer_bundles_updated_at BEFORE UPDATE ON public.offer_bundles FOR EACH ROW EXECUTE FUNCTION public.update_offers_updated_at();

--

CREATE TRIGGER trigger_update_offers_updated_at BEFORE UPDATE ON public.offers FOR EACH ROW EXECUTE FUNCTION public.update_offers_updated_at();

--

CREATE TRIGGER trigger_update_pos_deduction_transfers_updated_at BEFORE UPDATE ON public.pos_deduction_transfers FOR EACH ROW EXECUTE FUNCTION public.update_pos_deduction_transfers_updated_at();

--

CREATE TRIGGER trigger_update_quick_task_completions_updated_at BEFORE UPDATE ON public.quick_task_completions FOR EACH ROW EXECUTE FUNCTION public.update_quick_task_completions_updated_at();

--

CREATE TRIGGER trigger_update_quick_task_status AFTER UPDATE ON public.quick_task_assignments FOR EACH ROW EXECUTE FUNCTION public.update_quick_task_status();

--

CREATE TRIGGER trigger_update_receiving_task_templates_updated_at BEFORE UPDATE ON public.receiving_task_templates FOR EACH ROW EXECUTE FUNCTION public.update_receiving_task_templates_updated_at();

--

CREATE TRIGGER trigger_update_receiving_tasks_updated_at BEFORE UPDATE ON public.receiving_tasks FOR EACH ROW EXECUTE FUNCTION public.update_receiving_tasks_updated_at();

--

CREATE TRIGGER trigger_update_requisition_balance AFTER INSERT OR DELETE OR UPDATE ON public.expense_scheduler FOR EACH ROW EXECUTE FUNCTION public.update_requisition_balance();

--

CREATE TRIGGER trigger_update_requisition_balance_old BEFORE DELETE OR UPDATE ON public.expense_scheduler FOR EACH ROW EXECUTE FUNCTION public.update_requisition_balance_old();

--

CREATE TRIGGER trigger_user_device_sessions_updated_at BEFORE UPDATE ON public.user_device_sessions FOR EACH ROW EXECUTE FUNCTION public.update_user_device_sessions_updated_at();

--

CREATE TRIGGER trigger_validate_bundle_offer_type BEFORE INSERT OR UPDATE ON public.offer_bundles FOR EACH ROW EXECUTE FUNCTION public.validate_bundle_offer_type();

--

CREATE TRIGGER update_approval_permissions_timestamp BEFORE UPDATE ON public.approval_permissions FOR EACH ROW EXECUTE FUNCTION public.update_approval_permissions_updated_at();

--

CREATE TRIGGER update_customer_app_media_timestamp BEFORE UPDATE ON public.customer_app_media FOR EACH ROW EXECUTE FUNCTION public.update_customer_app_media_timestamp();

--

CREATE TRIGGER update_erp_connections_updated_at BEFORE UPDATE ON public.erp_connections FOR EACH ROW EXECUTE FUNCTION public.update_erp_connections_updated_at();

--

CREATE TRIGGER update_erp_daily_sales_updated_at BEFORE UPDATE ON public.erp_daily_sales FOR EACH ROW EXECUTE FUNCTION public.update_erp_daily_sales_updated_at();

--

CREATE TRIGGER update_flyer_offers_updated_at BEFORE UPDATE ON public.flyer_offers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

--

CREATE TRIGGER update_offer_cart_tiers_updated_at BEFORE UPDATE ON public.offer_cart_tiers FOR EACH ROW EXECUTE FUNCTION public.update_offer_cart_tiers_updated_at();

--

CREATE TRIGGER update_offer_products_updated_at BEFORE UPDATE ON public.offer_products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

--

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

--

CREATE TRIGGER update_requesters_updated_at BEFORE UPDATE ON public.requesters FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

--

CREATE TRIGGER update_shelf_paper_templates_updated_at BEFORE UPDATE ON public.shelf_paper_templates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

--

CREATE TRIGGER user_theme_assignments_timestamp_update BEFORE UPDATE ON public.user_theme_assignments FOR EACH ROW EXECUTE FUNCTION public.update_user_theme_assignments_timestamp();

--

CREATE TRIGGER users_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.log_user_action();

--

CREATE TRIGGER warning_main_category_timestamp_update BEFORE UPDATE ON public.warning_main_category FOR EACH ROW EXECUTE FUNCTION public.update_warning_main_category_timestamp();

--

CREATE TRIGGER warning_sub_category_timestamp_update BEFORE UPDATE ON public.warning_sub_category FOR EACH ROW EXECUTE FUNCTION public.update_warning_sub_category_timestamp();

--

CREATE TRIGGER warning_violation_timestamp_update BEFORE UPDATE ON public.warning_violation FOR EACH ROW EXECUTE FUNCTION public.update_warning_violation_timestamp();