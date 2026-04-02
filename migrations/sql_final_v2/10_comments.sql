--

COMMENT ON SCHEMA public IS 'standard public schema';

--

COMMENT ON FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) IS 'Admin accepts a new order';

--

COMMENT ON FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text, p_approved_by uuid) IS 'Approves or rejects a customer account. Requires admin privileges. Creates user account for approved customers.';

--

COMMENT ON FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) IS 'Assigns delivery person to order';

--

COMMENT ON FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) IS 'Assigns picker to order for preparation';

--

COMMENT ON FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) IS 'Cancels order with reason';

--

COMMENT ON FUNCTION public.check_and_notify_recurring_schedules() IS 'Sends reminder notifications to approvers/users 2 days before scheduled payment occurrences. Occurrences are pre-created by generate_recurring_occurrences() function.';

--

COMMENT ON FUNCTION public.check_and_notify_recurring_schedules_with_logging() IS 'Wrapper function that calls check_and_notify_recurring_schedules() and logs execution. Use this for cron jobs or manual execution.';

--

COMMENT ON FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) IS 'Check ERP sync status for a specific receiving record';

--

COMMENT ON FUNCTION public.check_overdue_tasks_and_send_reminders() IS 'Automatic task reminder system - runs hourly via pg_cron. Uses SECURITY DEFINER to bypass RLS.';

--

COMMENT ON FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint) IS 'Counts receiving records without ERP purchase invoice reference, optionally filtered by branch';

--

COMMENT ON FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint) IS 'Counts receiving records without original bill file, optionally filtered by branch';

--

COMMENT ON FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint) IS 'Counts receiving records without PR Excel file, optionally filtered by branch';

--

COMMENT ON FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text) IS 'Creates a new customer order (SECURITY DEFINER to bypass RLS)';

--

COMMENT ON FUNCTION public.create_quick_task_notification() IS 'Enhanced notification function that includes assignment details showing who assigned the task to whom';

--

COMMENT ON FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean) IS 'Creates a recurring task assignment with schedule configuration';

--

COMMENT ON FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean) IS 'Creates a one-time task assignment with optional scheduling and deadline';

--

COMMENT ON FUNCTION public.deactivate_expired_media() IS 'Automatically deactivates media that has passed its expiry date';

--

COMMENT ON FUNCTION public.export_schema_ddl() IS 'Exports all public schema DDL (functions, triggers, types, policies) as SQL text for branch sync';

--

COMMENT ON FUNCTION public.generate_order_number() IS 'Generates unique order number in format ORD-YYYYMMDD-XXXX';

--

COMMENT ON FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) IS 'Generates all future occurrences immediately when a recurring schedule is created. This allows users to see, modify, or cancel individual occurrences.';

--

COMMENT ON FUNCTION public.get_active_customer_media() IS 'Returns all active non-expired media for customer home page display';

--

COMMENT ON FUNCTION public.get_all_delivery_tiers() IS 'Get all active delivery fee tiers ordered for display';

--

COMMENT ON FUNCTION public.get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer) IS 'Retrieves assignments with deadline information and overdue status';

--

COMMENT ON FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) IS 'Get delivery settings for a specific branch with separate timings for delivery and pickup';

--

COMMENT ON FUNCTION public.get_branch_service_availability(branch_id uuid) IS 'Check delivery and pickup service availability for a specific branch';

--

COMMENT ON FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) IS 'Calculate delivery fee based on order amount using active tier structure';

--

COMMENT ON FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) IS 'Calculate delivery fee for order amount using branch tiers only';

--

COMMENT ON FUNCTION public.get_delivery_service_settings() IS 'Get global delivery service configuration settings';

--

COMMENT ON FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) IS 'Get active delivery fee tiers for a specific branch only';

--

COMMENT ON FUNCTION public.get_next_delivery_tier(current_amount numeric) IS 'Get the next tier that would reduce delivery fee with amount needed to reach it';

--

COMMENT ON FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) IS 'Get next tier for branch reducing delivery fee with savings info';

--

COMMENT ON FUNCTION public.get_overdue_tasks_without_reminders() IS 'Returns overdue tasks that havent received reminders yet - used by Edge Function';

--

COMMENT ON FUNCTION public.get_product_offers(p_product_id uuid) IS 'Get all active product offers for a specific product, ordered by best savings';

--

COMMENT ON FUNCTION public.get_products_in_active_offers() IS 'Get all products in active product offers for admin filtering';

--

COMMENT ON FUNCTION public.get_reminder_statistics(p_user_id uuid, p_days integer) IS 'Returns statistics about sent reminders for a user or all users';

--

COMMENT ON FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) IS 'Gets vendor details for a receiving record, ensuring branch compatibility';

--

COMMENT ON FUNCTION public.has_order_management_access(user_id uuid) IS 'Check if user has management-level access to orders (Admin, Master Admin, CEO, Operations Manager, Branch Manager, Customer Service Supervisor, Night Supervisors, IT Systems Manager)';

--

COMMENT ON FUNCTION public.is_delivery_staff(user_id uuid) IS 'Check if user is delivery staff (Delivery Staff, Driver)';

--

COMMENT ON FUNCTION public.queue_quick_task_push_notifications() IS 'Enhanced queue function with better payload information for Quick Task notifications';

--

COMMENT ON FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean) IS 'Reassigns a task to a different user or branch while maintaining audit trail';

--

COMMENT ON FUNCTION public.sync_all_pending_erp_references() IS 'Sync all receiving records that have pending ERP references from task completions';

--

COMMENT ON FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) IS 'Manually sync ERP reference from task completion to specific receiving record';

--

COMMENT ON FUNCTION public.trigger_cleanup_assignment_notifications() IS 'Trigger function to clean up notifications when task assignments are deleted';

--

COMMENT ON FUNCTION public.trigger_cleanup_task_notifications() IS 'Trigger function to clean up notifications when tasks are deleted';

--

COMMENT ON FUNCTION public.trigger_log_order_offer_usage() IS 'Links offer usage logs to orders for tracking';

--

COMMENT ON FUNCTION public.trigger_notify_new_order() IS 'Notifies all Admin and Master Admin users when a new order is placed';

--

COMMENT ON FUNCTION public.trigger_order_status_audit() IS 'Automatically creates audit log when order status changes';

--

COMMENT ON FUNCTION public.trigger_update_order_totals() IS 'Recalculates order item counts when order_items change';

--

COMMENT ON FUNCTION public.update_notification_delivery_status() IS 'Updates notification_recipients.delivery_status when push notifications are sent or failed.';

--

COMMENT ON FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text) IS 'Updates order status with audit trail';

--

COMMENT ON FUNCTION public.update_updated_at_column() IS 'Automatically updates the updated_at timestamp on row modification';

--

COMMENT ON FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) IS 'Validate if product offer can be applied';

--

COMMENT ON FUNCTION public.validate_vendor_branch_match() IS 'Validates that vendor belongs to the branch specified in receiving record';

--

COMMENT ON TABLE public.app_icons IS 'Stores metadata for all application icons managed dynamically';

--

COMMENT ON COLUMN public.app_icons.icon_key IS 'Unique key used in code to reference this icon (e.g. logo, saudi-currency)';

--

COMMENT ON COLUMN public.app_icons.category IS 'Category: logo, currency, social, pwa, misc';

--

COMMENT ON COLUMN public.app_icons.storage_path IS 'Path within the app-icons storage bucket';

--

COMMENT ON TABLE public.approval_permissions IS 'Stores granular approval permissions for different types of requests (requisitions, schedules, vendor payments, etc.)';

--

COMMENT ON COLUMN public.approval_permissions.user_id IS 'Reference to the user who has these approval permissions';

--

COMMENT ON COLUMN public.approval_permissions.can_approve_requisitions IS 'Whether user can approve expense requisitions';

--

COMMENT ON COLUMN public.approval_permissions.requisition_amount_limit IS 'Maximum amount user can approve for requisitions (0 = unlimited)';

--

COMMENT ON COLUMN public.approval_permissions.can_approve_single_bill IS 'Whether user can approve single bill payment schedules';

--

COMMENT ON COLUMN public.approval_permissions.single_bill_amount_limit IS 'Maximum amount user can approve for single bills (0 = unlimited)';

--

COMMENT ON COLUMN public.approval_permissions.can_approve_multiple_bill IS 'Whether user can approve multiple bill payment schedules';

--

COMMENT ON COLUMN public.approval_permissions.multiple_bill_amount_limit IS 'Maximum amount user can approve for multiple bills (0 = unlimited)';

--

COMMENT ON COLUMN public.approval_permissions.can_approve_recurring_bill IS 'Whether user can approve recurring bill payment schedules';

--

COMMENT ON COLUMN public.approval_permissions.recurring_bill_amount_limit IS 'Maximum amount user can approve for recurring bills (0 = unlimited)';

--

COMMENT ON COLUMN public.approval_permissions.can_approve_vendor_payments IS 'Whether user can approve vendor payments';

--

COMMENT ON COLUMN public.approval_permissions.vendor_payment_amount_limit IS 'Maximum amount user can approve for vendor payments (0 = unlimited)';

--

COMMENT ON COLUMN public.approval_permissions.is_active IS 'Whether these permissions are currently active';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_customer_incidents IS 'Permission to receive and review customer-related incident reports';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_employee_incidents IS 'Permission to receive and review employee-related incident reports';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_maintenance_incidents IS 'Permission to receive and review maintenance-related incident reports';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_vendor_incidents IS 'Permission to receive and review vendor-related incident reports';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_vehicle_incidents IS 'Permission to receive and review vehicle-related incident reports';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_government_incidents IS 'Permission to receive and review government-related incident reports';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_other_incidents IS 'Permission to receive and review other types of incident reports';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_finance_incidents IS 'Permission to receive and review finance department incident reports (IN8)';

--

COMMENT ON COLUMN public.approval_permissions.can_receive_pos_incidents IS 'Permission to receive and review customer/POS incident reports (IN9)';

--

COMMENT ON TABLE public.biometric_connections IS 'Stores biometric server connection configurations for ZKBioTime attendance sync';

--

COMMENT ON COLUMN public.biometric_connections.branch_id IS 'References branches.id - which Aqura branch this config belongs to';

--

COMMENT ON COLUMN public.biometric_connections.server_ip IS 'IP address of ZKBioTime SQL Server (e.g., 192.168.0.3)';

--

COMMENT ON COLUMN public.biometric_connections.server_name IS 'SQL Server instance name (e.g., SQLEXPRESS, WIN-D1D6EN8240A)';

--

COMMENT ON COLUMN public.biometric_connections.database_name IS 'ZKBioTime database name (e.g., Zkurbard)';

--

COMMENT ON COLUMN public.biometric_connections.device_id IS 'Computer name/ID running the sync app';

--

COMMENT ON COLUMN public.biometric_connections.terminal_sn IS 'Optional: Filter by specific terminal serial number (e.g., MFP3243700773)';

--

COMMENT ON COLUMN public.biometric_connections.last_sync_at IS 'Timestamp of last punch transaction sync';

--

COMMENT ON COLUMN public.biometric_connections.last_employee_sync_at IS 'Timestamp of last employee sync';

--

COMMENT ON TABLE public.bogo_offer_rules IS 'Stores Buy X Get Y (BOGO) offer rules - each rule defines a condition where buying X product(s) qualifies for discount on Y product(s)';

--

COMMENT ON COLUMN public.bogo_offer_rules.buy_product_id IS 'Product customer must buy (X)';

--

COMMENT ON COLUMN public.bogo_offer_rules.buy_quantity IS 'Quantity of buy product required';

--

COMMENT ON COLUMN public.bogo_offer_rules.get_product_id IS 'Product customer gets discount on (Y)';

--

COMMENT ON COLUMN public.bogo_offer_rules.get_quantity IS 'Quantity of get product that receives discount';

--

COMMENT ON COLUMN public.bogo_offer_rules.discount_type IS 'Type of discount: free (100% off), percentage (% off), or amount (fixed amount off)';

--

COMMENT ON COLUMN public.bogo_offer_rules.discount_value IS 'Discount value - 0 for free, 1-100 for percentage, or amount for fixed discount';

--

COMMENT ON TABLE public.box_operations IS 'Tracks POS cash box operations and counter check sessions';

--

COMMENT ON COLUMN public.box_operations.difference IS 'Difference between before and after totals (before - after)';

--

COMMENT ON COLUMN public.box_operations.is_matched IS 'True if counter check matched, false if there was a difference';

--

COMMENT ON COLUMN public.box_operations.status IS 'Operation status: in_use (active), pending_close (waiting for final close), completed, or cancelled';

--

COMMENT ON COLUMN public.box_operations.closing_details IS 'JSON containing all closing form data';

--

COMMENT ON COLUMN public.box_operations.supervisor_verified_at IS 'Timestamp when supervisor code was verified';

--

COMMENT ON COLUMN public.box_operations.supervisor_id IS 'ID of supervisor who verified the closing';

--

COMMENT ON COLUMN public.box_operations.difference_cash_sales IS 'Difference between total cash sales and system cash sales';

--

COMMENT ON COLUMN public.box_operations.difference_card_sales IS 'Difference between bank total and system card sales';

--

COMMENT ON COLUMN public.box_operations.total_difference IS 'Total of cash and card differences';

--

COMMENT ON COLUMN public.box_operations.pos_before_url IS 'URL to the stored POS before closing image in pos-before storage bucket';

--

COMMENT ON COLUMN public.branch_sync_config.tunnel_url IS 'Cloudflare Tunnel URL for the branch Supabase (used when local URL is unreachable)';

--

COMMENT ON COLUMN public.branches.vat_number IS 'VAT registration number for the branch';

--

COMMENT ON COLUMN public.branches.delivery_service_enabled IS 'Enable/disable delivery service for this branch';

--

COMMENT ON COLUMN public.branches.pickup_service_enabled IS 'Enable/disable store pickup service for this branch';

--

COMMENT ON COLUMN public.branches.minimum_order_amount IS 'Minimum order amount for this branch (SAR)';

--

COMMENT ON COLUMN public.branches.is_24_hours IS 'Whether delivery service is available 24/7 for this branch';

--

COMMENT ON COLUMN public.branches.operating_start_time IS 'Delivery service start time (if not 24/7)';

--

COMMENT ON COLUMN public.branches.operating_end_time IS 'Delivery service end time (if not 24/7)';

--

COMMENT ON COLUMN public.branches.delivery_message_ar IS 'Custom delivery message in Arabic for this branch';

--

COMMENT ON COLUMN public.branches.delivery_message_en IS 'Custom delivery message in English for this branch';

--

COMMENT ON COLUMN public.branches.delivery_is_24_hours IS 'Whether delivery service is available 24/7';

--

COMMENT ON COLUMN public.branches.delivery_start_time IS 'Delivery service start time';

--

COMMENT ON COLUMN public.branches.delivery_end_time IS 'Delivery service end time';

--

COMMENT ON COLUMN public.branches.pickup_is_24_hours IS 'Whether pickup service is available 24/7';

--

COMMENT ON COLUMN public.branches.pickup_start_time IS 'Pickup service start time';

--

COMMENT ON COLUMN public.branches.pickup_end_time IS 'Pickup service end time';

--

COMMENT ON COLUMN public.branches.location_url IS 'Google Maps URL for the branch location';

--

COMMENT ON COLUMN public.branches.latitude IS 'Branch latitude for distance calculation';

--

COMMENT ON COLUMN public.branches.longitude IS 'Branch longitude for distance calculation';

--

COMMENT ON TABLE public.customer_access_code_history IS 'Audit trail of customer access code changes';

--

COMMENT ON COLUMN public.customer_access_code_history.reason IS 'Reason for access code change';

--

COMMENT ON TABLE public.customer_app_media IS 'Stores videos and images displayed on customer home page with expiry management';

--

COMMENT ON TABLE public.customer_recovery_requests IS 'Customer account recovery requests for admin processing';

--

COMMENT ON COLUMN public.customer_recovery_requests.request_type IS 'Type of recovery request';

--

COMMENT ON COLUMN public.customer_recovery_requests.verification_status IS 'Admin verification status';

--

COMMENT ON TABLE public.customers IS 'Customer information and access codes for customer login system';

--

COMMENT ON COLUMN public.customers.access_code IS 'Unique 6-digit access code for customer login';

--

COMMENT ON COLUMN public.customers.whatsapp_number IS 'Customer WhatsApp number for notifications';

--

COMMENT ON COLUMN public.customers.registration_status IS 'Customer registration approval status';

--

COMMENT ON COLUMN public.customers.deleted_at IS 'Timestamp when customer deleted their account';

--

COMMENT ON COLUMN public.customers.erp_branch_id IS 'ERP branch ID for queries';

--

COMMENT ON COLUMN public.day_off.description IS 'Description or reason for the day off request';

--

COMMENT ON TABLE public.deleted_bundle_offers IS 'Archive table for deleted bundle offers - allows recovery and audit trail';

--

COMMENT ON COLUMN public.deleted_bundle_offers.original_offer_id IS 'The original offer ID from offers table (INTEGER)';

--

COMMENT ON COLUMN public.deleted_bundle_offers.offer_data IS 'Complete offer data as JSON';

--

COMMENT ON COLUMN public.deleted_bundle_offers.bundles_data IS 'Array of bundle data as JSON';

--

COMMENT ON COLUMN public.deleted_bundle_offers.deleted_by IS 'User who deleted the offer';

--

COMMENT ON COLUMN public.deleted_bundle_offers.deletion_reason IS 'Optional reason for deletion';

--

COMMENT ON TABLE public.delivery_fee_tiers IS 'Multi-tier delivery fee system - Migration 20251107000000';

--

COMMENT ON COLUMN public.delivery_fee_tiers.min_order_amount IS 'Minimum order amount for this tier (SAR)';

--

COMMENT ON COLUMN public.delivery_fee_tiers.max_order_amount IS 'Maximum order amount for this tier, NULL for unlimited';

--

COMMENT ON COLUMN public.delivery_fee_tiers.delivery_fee IS 'Delivery fee charged for orders in this tier (SAR)';

--

COMMENT ON COLUMN public.delivery_fee_tiers.tier_order IS 'Display order for admin interface';

--

COMMENT ON COLUMN public.delivery_fee_tiers.branch_id IS 'When NULL, tier is global. When set, tier applies only to this branch.';

--

COMMENT ON TABLE public.delivery_service_settings IS 'Global delivery service configuration settings';

--

COMMENT ON COLUMN public.delivery_service_settings.minimum_order_amount IS 'Minimum order amount to place any order (SAR)';

--

COMMENT ON TABLE public.denomination_audit_log IS 'Automatic audit log for all denomination record changes (INSERT, UPDATE, DELETE)';

--

COMMENT ON TABLE public.denomination_records IS 'Stores denomination count records for main, boxes, and other sections';

--

COMMENT ON COLUMN public.denomination_records.record_type IS 'Type of record: main, advance_box, collection_box, paid, received';

--

COMMENT ON COLUMN public.denomination_records.box_number IS 'Box or card number (1-12 for advance boxes, 1-6 for collection boxes, 1-6 for paid/received, null for main)';

--

COMMENT ON COLUMN public.denomination_records.counts IS 'JSONB storing denomination counts: {"d500": 10, "d200": 5, ...}';

--

COMMENT ON COLUMN public.denomination_records.petty_cash_operation IS 'JSONB column storing petty cash operation details: {transferred_from_box_number, transferred_from_user_id, closing_details}';

--

COMMENT ON CONSTRAINT denomination_records_record_type_check ON public.denomination_records IS 'Allowed record types: main (main denomination), advance_box (advance manager boxes), collection_box (collection boxes), paid (paid records), received (received records), petty_cash_box (petty cash transfers)';

--

COMMENT ON TABLE public.denomination_types IS 'Master table for denomination types (currency notes, coins, damage)';

--

COMMENT ON TABLE public.denomination_user_preferences IS 'Stores user preferences for the Denomination feature';

--

COMMENT ON COLUMN public.denomination_user_preferences.user_id IS 'Reference to the user';

--

COMMENT ON COLUMN public.denomination_user_preferences.default_branch_id IS 'Default branch selected by the user for denomination';

--

COMMENT ON TABLE public.employee_fine_payments IS 'Payment history for fines associated with warnings';

--

COMMENT ON COLUMN public.erp_connections.erp_branch_id IS 'Branch ID from ERP system (1, 2, 3, etc.)';

--

COMMENT ON COLUMN public.erp_connections.tunnel_url IS 'Cloudflare Tunnel URL for the ERP bridge API on this branch server';

--

COMMENT ON TABLE public.expense_parent_categories IS 'Parent expense categories with bilingual support (English and Arabic)';

--

COMMENT ON TABLE public.expense_requisitions IS 'Expense requisitions with approval workflow and image storage';

--

COMMENT ON COLUMN public.expense_requisitions.requisition_number IS 'Unique requisition number in format REQ-YYYYMMDD-XXXX';

--

COMMENT ON COLUMN public.expense_requisitions.expense_category_id IS 'Expense category - can be null initially and assigned when closing the request';

--

COMMENT ON COLUMN public.expense_requisitions.payment_category IS 'Payment method: advance_cash, advance_bank, advance_cash_credit, advance_bank_credit, cash, bank, cash_credit, bank_credit, stock_purchase_advance_cash, stock_purchase_advance_bank, stock_purchase_cash, stock_purchase_bank';

--

COMMENT ON COLUMN public.expense_requisitions.status IS 'Requisition status: pending, approved, rejected, completed';

--

COMMENT ON COLUMN public.expense_requisitions.credit_period IS 'Credit period in days (required for credit payment methods: advance_cash_credit, advance_bank_credit, cash_credit, bank_credit)';

--

COMMENT ON COLUMN public.expense_requisitions.bank_name IS 'Bank name (optional for all bank payment methods)';

--

COMMENT ON COLUMN public.expense_requisitions.iban IS 'IBAN number (optional for all bank payment methods)';

--

COMMENT ON COLUMN public.expense_requisitions.used_amount IS 'Total amount used from this requisition across all scheduled bills';

--

COMMENT ON COLUMN public.expense_requisitions.remaining_balance IS 'Remaining balance available for new bills (amount - used_amount)';

--

COMMENT ON COLUMN public.expense_requisitions.requester_ref_id IS 'Reference to the requesters table for normalized requester data';

--

COMMENT ON COLUMN public.expense_requisitions.is_active IS 'Indicates if the requisition is active. Deactivated requisitions are excluded from filters and scheduling.';

--

COMMENT ON COLUMN public.expense_requisitions.due_date IS 'Automatically calculated due date based on payment method and credit period';

--

COMMENT ON COLUMN public.expense_requisitions.vendor_id IS 'Vendor ERP ID when request type is vendor';

--

COMMENT ON COLUMN public.expense_requisitions.vendor_name IS 'Vendor name when request type is vendor';

--

COMMENT ON TABLE public.expense_scheduler IS 'Unified table for all scheduled expenses including bills from closed requisitions. 
Bills from closed requisitions have schedule_type = closed_requisition_bill and is_paid = true.';

--

COMMENT ON COLUMN public.expense_scheduler.expense_category_id IS 'Can be NULL for requisitions created without categories - category will be assigned when closing the request with bills';

--

COMMENT ON COLUMN public.expense_scheduler.due_date IS 'Payment due date - calculated based on bill_date or created_at plus credit_period';

--

COMMENT ON COLUMN public.expense_scheduler.payment_reference IS 'Payment reference number or transaction ID for tracking purposes';

--

COMMENT ON COLUMN public.expense_scheduler.schedule_type IS 'Types: single_bill, multiple_bill, recurring, expense_requisition, closed_requisition_bill';

--

COMMENT ON COLUMN public.expense_scheduler.recurring_type IS 'Type of recurring schedule: daily, weekly, monthly_date, monthly_day, yearly, half_yearly, quarterly, custom. Only applies when schedule_type is recurring';

--

COMMENT ON COLUMN public.expense_scheduler.recurring_metadata IS 'JSON metadata for recurring schedule details (until_date, weekday, month_position, etc.)';

--

COMMENT ON COLUMN public.expense_scheduler.approver_id IS 'User ID of the approver for recurring schedules. Required for recurring schedules.';

--

COMMENT ON COLUMN public.expense_scheduler.approver_name IS 'Name of the approver for recurring schedules. Required for recurring schedules.';

--

COMMENT ON COLUMN public.expense_scheduler.vendor_id IS 'Vendor ERP ID when schedule is for a vendor expense';

--

COMMENT ON COLUMN public.expense_scheduler.vendor_name IS 'Vendor name when schedule is for a vendor expense';

--

COMMENT ON CONSTRAINT check_co_user_for_non_recurring ON public.expense_scheduler IS 'Ensures CO user is required for single_bill and multiple_bill, but not for recurring, expense_requisition, or closed_requisition_bill schedule types';

--

COMMENT ON CONSTRAINT check_schedule_type_values ON public.expense_scheduler IS 'Allowed schedule types: single_bill, multiple_bill, recurring, expense_requisition, closed_requisition_bill';

--

COMMENT ON TABLE public.expense_sub_categories IS 'Sub expense categories linked to parent categories with bilingual support';

--

COMMENT ON TABLE public.flyer_offer_products IS 'Junction table linking flyer offers to products with pricing details';

--

COMMENT ON COLUMN public.flyer_offer_products.offer_id IS 'Reference to the flyer offer';

--

COMMENT ON COLUMN public.flyer_offer_products.product_barcode IS 'Reference to the product barcode';

--

COMMENT ON COLUMN public.flyer_offer_products.cost IS 'Product cost price';

--

COMMENT ON COLUMN public.flyer_offer_products.sales_price IS 'Regular sales price';

--

COMMENT ON COLUMN public.flyer_offer_products.offer_price IS 'Special offer price';

--

COMMENT ON COLUMN public.flyer_offer_products.profit_amount IS 'Profit amount in currency';

--

COMMENT ON COLUMN public.flyer_offer_products.profit_percent IS 'Profit as percentage';

--

COMMENT ON COLUMN public.flyer_offer_products.profit_after_offer IS 'Profit after applying offer discount';

--

COMMENT ON COLUMN public.flyer_offer_products.decrease_amount IS 'Amount decreased from regular price';

--

COMMENT ON COLUMN public.flyer_offer_products.offer_qty IS 'Quantity required to qualify for offer';

--

COMMENT ON COLUMN public.flyer_offer_products.limit_qty IS 'Maximum quantity limit per customer (nullable)';

--

COMMENT ON COLUMN public.flyer_offer_products.free_qty IS 'Free quantity given with purchase';

--

COMMENT ON COLUMN public.flyer_offer_products.page_number IS 'The page number where this product appears in the flyer';

--

COMMENT ON COLUMN public.flyer_offer_products.page_order IS 'The order/position of this product on its page';

--

COMMENT ON TABLE public.flyer_offers IS 'Stores flyer offer campaigns and templates';

--

COMMENT ON COLUMN public.flyer_offers.template_id IS 'Unique template identifier for the offer';

--

COMMENT ON COLUMN public.flyer_offers.template_name IS 'Display name for the offer template';

--

COMMENT ON COLUMN public.flyer_offers.is_active IS 'Whether this offer is currently active';

--

COMMENT ON COLUMN public.flyer_offers.offer_name IS 'Optional custom name for the offer, in addition to the template name';

--

COMMENT ON COLUMN public.flyer_offers.offer_name_id IS 'Reference to predefined offer name from offer_names table';

--

COMMENT ON CONSTRAINT flyer_offers_dates_check ON public.flyer_offers IS 'Ensures end date is not before start date';

--

COMMENT ON TABLE public.flyer_templates IS 'Stores flyer template designs with product field configurations';

--

COMMENT ON COLUMN public.flyer_templates.first_page_image_url IS 'Storage URL for the first page template image';

--

COMMENT ON COLUMN public.flyer_templates.sub_page_image_urls IS 'Array of storage URLs for unlimited sub-page template images';

--

COMMENT ON COLUMN public.flyer_templates.first_page_configuration IS 'JSONB array of product field configurations for first page';

--

COMMENT ON COLUMN public.flyer_templates.sub_page_configurations IS 'JSONB 2D array - each element contains field configurations for a sub-page';

--

COMMENT ON COLUMN public.flyer_templates.metadata IS 'Template dimensions and additional metadata';

--

COMMENT ON TABLE public.hr_basic_salary IS 'Stores basic salary information for employees';

--

COMMENT ON COLUMN public.hr_basic_salary.employee_id IS 'References hr_employee_master.id';

--

COMMENT ON COLUMN public.hr_basic_salary.basic_salary IS 'Employee basic salary amount';

--

COMMENT ON COLUMN public.hr_basic_salary.payment_mode IS 'Payment mode: Bank or Cash';

--

COMMENT ON COLUMN public.hr_basic_salary.other_allowance IS 'Other allowance amount';

--

COMMENT ON COLUMN public.hr_basic_salary.other_allowance_payment_mode IS 'Payment mode for other allowance: Bank or Cash';

--

COMMENT ON COLUMN public.hr_basic_salary.accommodation_allowance IS 'Accommodation allowance amount';

--

COMMENT ON COLUMN public.hr_basic_salary.accommodation_payment_mode IS 'Payment mode for accommodation: Bank or Cash';

--

COMMENT ON COLUMN public.hr_basic_salary.travel_allowance IS 'Travel allowance amount';

--

COMMENT ON COLUMN public.hr_basic_salary.travel_payment_mode IS 'Payment mode for travel: Bank or Cash';

--

COMMENT ON COLUMN public.hr_basic_salary.gosi_deduction IS 'GOSI deduction amount';

--

COMMENT ON COLUMN public.hr_basic_salary.total_salary IS 'Total salary after all allowances and deductions';

--

COMMENT ON COLUMN public.hr_basic_salary.food_allowance IS 'Food allowance amount for the employee';

--

COMMENT ON COLUMN public.hr_basic_salary.food_payment_mode IS 'Payment mode for food allowance: Bank or Cash';

--

COMMENT ON COLUMN public.hr_checklist_operations.answers IS 'JSONB array: [{ question_id: "Q1", answer_key: "a1", answer_text: "Yes", points: 5, remarks: "...", other_value: "..." }, ...]';

--

COMMENT ON COLUMN public.hr_checklist_operations.max_points IS 'Total possible points from all questions in the checklist';

--

COMMENT ON COLUMN public.hr_checklist_operations.submission_type_en IS 'Submission type in English: POS, Daily, Weekly';

--

COMMENT ON COLUMN public.hr_checklist_operations.submission_type_ar IS 'Submission type in Arabic: POS, يومي, أسبوعي';

--

COMMENT ON TABLE public.hr_departments IS 'HR Departments - minimal schema for Create Department function';

--

COMMENT ON COLUMN public.hr_employee_master.bank_name IS 'Name of the bank where employee has account';

--

COMMENT ON COLUMN public.hr_employee_master.iban IS 'International Bank Account Number';

--

COMMENT ON COLUMN public.hr_employee_master.contract_expiry_date IS 'Employment contract expiry date';

--

COMMENT ON COLUMN public.hr_employee_master.contract_document_url IS 'URL to the uploaded contract document';

--

COMMENT ON COLUMN public.hr_employee_master.sponsorship_status IS 'Employee sponsorship status - true if active, false if inactive';

--

COMMENT ON COLUMN public.hr_employee_master.employment_status_effective_date IS 'Effective date for employment status changes (Resigned, Terminated, Run Away)';

--

COMMENT ON COLUMN public.hr_employee_master.employment_status_reason IS 'Reason for employment status change';

--

COMMENT ON TABLE public.hr_employees IS 'HR Employees - Upload function with Employee ID and Name only. Branch assigned from UI, Hire Date updated later.';

--

COMMENT ON TABLE public.hr_fingerprint_transactions IS 'HR Fingerprint Transactions - Excel upload with numeric employee_id and name matching hr_employees table';

--

COMMENT ON TABLE public.hr_levels IS 'HR Levels - minimal schema for Create Level function';

--

COMMENT ON TABLE public.hr_position_assignments IS 'HR Position Assignments - minimal schema for Assign Positions function';

--

COMMENT ON TABLE public.hr_position_reporting_template IS 'HR Position Reporting Template - Each position can report to up to 5 different manager positions (Slots 1-5)';

--

COMMENT ON TABLE public.hr_positions IS 'HR Positions - minimal schema for Create Position function';

--

COMMENT ON TABLE public.incident_actions IS 'Tracks all actions taken on incidents including warnings, fines, and their payment status';

--

COMMENT ON COLUMN public.incident_actions.id IS 'Auto-generated ID in format ACT1, ACT2, etc.';

--

COMMENT ON COLUMN public.incident_actions.action_type IS 'Type of action: warning, investigation, termination, other';

--

COMMENT ON COLUMN public.incident_actions.recourse_type IS 'Type of recourse for warnings';

--

COMMENT ON COLUMN public.incident_actions.action_report IS 'Full action/warning report as JSONB';

--

COMMENT ON COLUMN public.incident_actions.has_fine IS 'Whether this action includes a fine';

--

COMMENT ON COLUMN public.incident_actions.fine_amount IS 'Fine amount if applicable';

--

COMMENT ON COLUMN public.incident_actions.fine_threat_amount IS 'Threatened fine amount for warning_fine_threat type';

--

COMMENT ON COLUMN public.incident_actions.is_paid IS 'Whether the fine has been paid';

--

COMMENT ON COLUMN public.incident_actions.paid_at IS 'When the fine was paid';

--

COMMENT ON COLUMN public.incident_actions.paid_by IS 'User ID who marked the fine as paid';

--

COMMENT ON TABLE public.incident_types IS 'Stores the types of incidents that can be reported in the system';

--

COMMENT ON COLUMN public.incident_types.id IS 'Unique identifier for incident type (IN1, IN2, etc.)';

--

COMMENT ON COLUMN public.incident_types.incident_type_en IS 'English name of the incident type';

--

COMMENT ON COLUMN public.incident_types.incident_type_ar IS 'Arabic name of the incident type';

--

COMMENT ON TABLE public.incidents IS 'Stores incident reports submitted by employees and other incident types';

--

COMMENT ON COLUMN public.incidents.id IS 'Unique identifier for incident (INS1, INS2, etc.)';

--

COMMENT ON COLUMN public.incidents.incident_type_id IS 'Type of incident (references incident_types table)';

--

COMMENT ON COLUMN public.incidents.employee_id IS 'Employee ID - NULL for non-employee incidents (Customer, Maintenance, Vendor, Vehicle, Government, Other)';

--

COMMENT ON COLUMN public.incidents.branch_id IS 'Branch where incident occurred';

--

COMMENT ON COLUMN public.incidents.violation_id IS 'Violation ID - NULL for non-employee incidents';

--

COMMENT ON COLUMN public.incidents.what_happened IS 'JSONB: Detailed description of what happened';

--

COMMENT ON COLUMN public.incidents.witness_details IS 'JSONB: Information about witnesses';

--

COMMENT ON COLUMN public.incidents.report_type IS 'Type of report (e.g., employee_related)';

--

COMMENT ON COLUMN public.incidents.reports_to_user_ids IS 'Array of user IDs who should receive this incident report';

--

COMMENT ON COLUMN public.incidents.claims_status IS 'Status of claims related to the incident';

--

COMMENT ON COLUMN public.incidents.claimed_user_id IS 'User ID of person who claimed the incident';

--

COMMENT ON COLUMN public.incidents.resolution_status IS 'Status: reported, claimed, or resolved';

--

COMMENT ON COLUMN public.incidents.user_statuses IS 'JSONB: Individual status for each user in reports_to_user_ids';

--

COMMENT ON COLUMN public.incidents.attachments IS 'JSONB array of attachments: [{url, name, type, size, uploaded_at}, ...]';

--

COMMENT ON COLUMN public.incidents.investigation_report IS 'Stores investigation report details as JSON';

--

COMMENT ON COLUMN public.incidents.related_party IS 'Stores related party details as JSONB. For customer incidents: {name, contact_number}. For other incidents: {details}';

--

COMMENT ON COLUMN public.incidents.resolution_report IS 'Stores resolution report as JSONB with content, resolved_by, resolved_by_name, and resolved_at';

--

COMMENT ON TABLE public.interface_permissions IS 'User access permissions for different application interfaces';

--

COMMENT ON COLUMN public.interface_permissions.desktop_enabled IS 'Whether user can access desktop interface';

--

COMMENT ON COLUMN public.interface_permissions.mobile_enabled IS 'Whether user can access mobile interface';

--

COMMENT ON COLUMN public.interface_permissions.customer_enabled IS 'Whether user can access customer interface';

--

COMMENT ON COLUMN public.interface_permissions.cashier_enabled IS 'Controls access to the cashier/POS application';

--

COMMENT ON TABLE public.non_approved_payment_scheduler IS 'Stores payment schedules that require approval before being posted to expense_scheduler';

--

COMMENT ON COLUMN public.non_approved_payment_scheduler.schedule_type IS 'Type of schedule: single_bill, multiple_bill, or recurring';

--

COMMENT ON COLUMN public.non_approved_payment_scheduler.approval_status IS 'Approval status: pending, approved, rejected';

--

COMMENT ON COLUMN public.non_approved_payment_scheduler.expense_scheduler_id IS 'Links to expense_scheduler after approval';

--

COMMENT ON COLUMN public.notification_read_states.is_read IS 'Whether the notification has been read by the user';

--

COMMENT ON TABLE public.notifications IS 'Cache refresh timestamp: 2025-10-04 11:00:23.237041+00';

--

COMMENT ON COLUMN public.notifications.task_id IS 'Reference to the task this notification is about';

--

COMMENT ON COLUMN public.notifications.task_assignment_id IS 'Reference to the task assignment this notification is about';

--

COMMENT ON TABLE public.offer_bundles IS 'Bundle offer configurations with multiple products';

--

COMMENT ON TABLE public.offer_names IS 'Predefined offer name templates';

--

COMMENT ON TABLE public.offer_products IS 'Stores individual products in product discount offers with percentage or special price';

--

COMMENT ON COLUMN public.offer_products.offer_id IS 'Reference to parent offer';

--

COMMENT ON COLUMN public.offer_products.product_id IS 'Reference to product';

--

COMMENT ON COLUMN public.offer_products.offer_qty IS 'Quantity required for offer (e.g., 2 for "2 pieces for 39.95")';

--

COMMENT ON COLUMN public.offer_products.offer_percentage IS 'Percentage discount (e.g., 20.00 for 20% off) - NULL for special price offers';

--

COMMENT ON COLUMN public.offer_products.offer_price IS 'Special price for offer quantity (e.g., 39.95 for 2 pieces) - NULL for percentage offers';

--

COMMENT ON COLUMN public.offer_products.max_uses IS 'Maximum uses per product (NULL = unlimited)';

--

COMMENT ON COLUMN public.offer_products.is_part_of_variation_group IS 'Flag indicating if this product belongs to a variation group within the offer';

--

COMMENT ON COLUMN public.offer_products.variation_group_id IS 'UUID linking all variations in the same group within an offer';

--

COMMENT ON COLUMN public.offer_products.variation_parent_barcode IS 'Quick reference to the parent product barcode';

--

COMMENT ON COLUMN public.offer_products.added_by IS 'User who added this variation to the offer';

--

COMMENT ON COLUMN public.offer_products.added_at IS 'Timestamp when this variation was added to the offer';

--

COMMENT ON TABLE public.offer_usage_logs IS 'Comprehensive logging of all offer applications';

--

COMMENT ON COLUMN public.offer_usage_logs.order_id IS 'Links offer usage to the order where it was applied (NULL for non-order usage)';

--

COMMENT ON TABLE public.offers IS 'Main offers table with all offer configurations and rules';

--

COMMENT ON TABLE public.order_audit_logs IS 'Audit trail for all order changes and actions';

--

COMMENT ON COLUMN public.order_audit_logs.action_type IS 'Type of action: created, status_changed, assigned_picker, assigned_delivery, cancelled, etc.';

--

COMMENT ON COLUMN public.order_audit_logs.from_status IS 'Previous order status (for status_changed actions)';

--

COMMENT ON COLUMN public.order_audit_logs.to_status IS 'New order status (for status_changed actions)';

--

COMMENT ON COLUMN public.order_audit_logs.performed_by IS 'User who performed the action';

--

COMMENT ON COLUMN public.order_audit_logs.assigned_user_id IS 'User who was assigned (for assignment actions)';

--

COMMENT ON COLUMN public.order_audit_logs.assignment_type IS 'Type of assignment: picker or delivery';

--

COMMENT ON TABLE public.order_items IS 'Individual line items within customer orders';

--

COMMENT ON COLUMN public.order_items.product_name_ar IS 'Product name snapshot in Arabic at time of order';

--

COMMENT ON COLUMN public.order_items.product_name_en IS 'Product name snapshot in English at time of order';

--

COMMENT ON COLUMN public.order_items.unit_price IS 'Price per unit at time of order';

--

COMMENT ON COLUMN public.order_items.final_price IS 'Price after applying discounts/offers';

--

COMMENT ON COLUMN public.order_items.line_total IS 'Total for this line (final_price * quantity)';

--

COMMENT ON COLUMN public.order_items.item_type IS 'Type of item: regular, bundle_item, bogo_free, bogo_discounted';

--

COMMENT ON COLUMN public.order_items.bundle_id IS 'Groups items that belong to the same bundle purchase';

--

COMMENT ON COLUMN public.order_items.bogo_group_id IS 'Groups items involved in the same BOGO offer';

--

COMMENT ON TABLE public.orders IS 'Customer orders from mobile app';

--

COMMENT ON COLUMN public.orders.order_number IS 'Unique order number displayed to customer (e.g., ORD-20251120-0001)';

--

COMMENT ON COLUMN public.orders.selected_location IS 'Customer delivery location snapshot from their saved locations';

--

COMMENT ON COLUMN public.orders.order_status IS 'Order workflow status: new, accepted, in_picking, ready, out_for_delivery, delivered, cancelled';

--

COMMENT ON COLUMN public.orders.fulfillment_method IS 'How customer will receive order: delivery or pickup';

--

COMMENT ON COLUMN public.orders.payment_method IS 'Payment method: cash, card, online';

--

COMMENT ON COLUMN public.orders.payment_status IS 'Payment tracking: pending, paid, refunded';

--

COMMENT ON TABLE public.overtime_registrations IS 'Stores overtime registrations for employees who worked on holidays/day offs or worked beyond expected hours';

--

COMMENT ON TABLE public.pos_deduction_transfers IS 'Stores POS deduction transfer records when cashier has shortage more than 5';

--

COMMENT ON TABLE public.push_subscriptions IS 'Stores web push notification subscriptions for users';

--

COMMENT ON COLUMN public.push_subscriptions.subscription IS 'Full PushSubscription object in JSON format';

--

COMMENT ON COLUMN public.push_subscriptions.endpoint IS 'Push service endpoint URL for deduplication';

--

COMMENT ON COLUMN public.push_subscriptions.failed_deliveries IS 'Count of consecutive failed push attempts';

--

COMMENT ON COLUMN public.push_subscriptions.is_active IS 'Whether this subscription is active and should receive pushes';

--

COMMENT ON COLUMN public.quick_task_assignments.require_task_finished IS 'Whether task completion checkbox is required';

--

COMMENT ON COLUMN public.quick_task_assignments.require_photo_upload IS 'Whether photo upload is required for task completion';

--

COMMENT ON COLUMN public.quick_task_assignments.require_erp_reference IS 'Whether ERP reference number is required for task completion';

--

COMMENT ON TABLE public.quick_task_completions IS 'Completion records for quick tasks with photos and verification';

--

COMMENT ON COLUMN public.quick_task_completions.id IS 'Unique identifier for the completion record';

--

COMMENT ON COLUMN public.quick_task_completions.quick_task_id IS 'Reference to the quick task that was completed';

--

COMMENT ON COLUMN public.quick_task_completions.assignment_id IS 'Reference to the specific assignment that was completed';

--

COMMENT ON COLUMN public.quick_task_completions.completed_by_user_id IS 'User who completed the task';

--

COMMENT ON COLUMN public.quick_task_completions.completion_notes IS 'Notes provided by the user upon completion';

--

COMMENT ON COLUMN public.quick_task_completions.photo_path IS 'Path to the completion photo in storage';

--

COMMENT ON COLUMN public.quick_task_completions.erp_reference IS 'ERP system reference number if required';

--

COMMENT ON COLUMN public.quick_task_completions.completion_status IS 'Status of the completion record';

--

COMMENT ON COLUMN public.quick_task_completions.verified_by_user_id IS 'User who verified the completion';

--

COMMENT ON COLUMN public.quick_task_completions.verified_at IS 'When the completion was verified';

--

COMMENT ON COLUMN public.quick_task_completions.verification_notes IS 'Notes from the verifier';

--

COMMENT ON COLUMN public.quick_tasks.require_task_finished IS 'Default requirement for task completion (always required)';

--

COMMENT ON COLUMN public.quick_tasks.require_photo_upload IS 'Default requirement for photo upload on task completion';

--

COMMENT ON COLUMN public.quick_tasks.require_erp_reference IS 'Default requirement for ERP reference on task completion';

--

COMMENT ON COLUMN public.quick_tasks.incident_id IS 'Reference to the incident that triggered this quick task';

--

COMMENT ON COLUMN public.quick_tasks.product_request_id IS 'Reference to the product request that triggered this quick task';

--

COMMENT ON COLUMN public.quick_tasks.product_request_type IS 'Type of product request: PO, ST, or BT';

--

COMMENT ON COLUMN public.users.ai_translation_enabled IS 'Whether AI translation is enabled for this user - controls access to AI translation features in mobile interface';

--

COMMENT ON TABLE public.receiving_records IS 'Receiving records with bill information and return processing';

--

COMMENT ON COLUMN public.receiving_records.user_id IS 'User who performed the receiving';

--

COMMENT ON COLUMN public.receiving_records.branch_id IS 'Branch where receiving was performed';

--

COMMENT ON COLUMN public.receiving_records.vendor_id IS 'Vendor from whom goods were received';

--

COMMENT ON COLUMN public.receiving_records.bill_date IS 'Date entered from the physical bill';

--

COMMENT ON COLUMN public.receiving_records.bill_amount IS 'Total amount from the bill';

--

COMMENT ON COLUMN public.receiving_records.bill_number IS 'Bill number from the physical bill';

--

COMMENT ON COLUMN public.receiving_records.payment_method IS 'Payment method for this receiving (can differ from vendor default)';

--

COMMENT ON COLUMN public.receiving_records.credit_period IS 'Credit period in days for this receiving (can differ from vendor default)';

--

COMMENT ON COLUMN public.receiving_records.due_date IS 'Calculated due date (bill date + credit period) for credit payment methods';

--

COMMENT ON COLUMN public.receiving_records.bank_name IS 'Bank name for this receiving (can differ from vendor default)';

--

COMMENT ON COLUMN public.receiving_records.iban IS 'IBAN for this receiving (can differ from vendor default)';

--

COMMENT ON COLUMN public.receiving_records.vendor_vat_number IS 'VAT number from vendor record at time of receiving';

--

COMMENT ON COLUMN public.receiving_records.bill_vat_number IS 'VAT number entered from the physical bill';

--

COMMENT ON COLUMN public.receiving_records.vat_numbers_match IS 'Whether vendor and bill VAT numbers match';

--

COMMENT ON COLUMN public.receiving_records.vat_mismatch_reason IS 'Reason provided when VAT numbers do not match';

--

COMMENT ON COLUMN public.receiving_records.branch_manager_user_id IS 'Selected branch manager or responsible user for this receiving';

--

COMMENT ON COLUMN public.receiving_records.shelf_stocker_user_ids IS 'Array of user IDs selected as shelf stockers for this receiving';

--

COMMENT ON COLUMN public.receiving_records.accountant_user_id IS 'Selected accountant or responsible user for accounting tasks';

--

COMMENT ON COLUMN public.receiving_records.purchasing_manager_user_id IS 'Selected purchasing manager or responsible user for purchasing oversight';

--

COMMENT ON COLUMN public.receiving_records.expired_return_amount IS 'Amount returned for expired items';

--

COMMENT ON COLUMN public.receiving_records.near_expiry_return_amount IS 'Amount returned for near expiry items';

--

COMMENT ON COLUMN public.receiving_records.over_stock_return_amount IS 'Amount returned for over stock items';

--

COMMENT ON COLUMN public.receiving_records.damage_return_amount IS 'Amount returned for damaged items';

--

COMMENT ON COLUMN public.receiving_records.total_return_amount IS 'Total amount of all returns (auto-calculated)';

--

COMMENT ON COLUMN public.receiving_records.final_bill_amount IS 'Final bill amount after deducting returns (auto-calculated)';

--

COMMENT ON COLUMN public.receiving_records.expired_erp_document_type IS 'ERP document type for expired returns (GRN, PR)';

--

COMMENT ON COLUMN public.receiving_records.expired_erp_document_number IS 'ERP document number for expired returns';

--

COMMENT ON COLUMN public.receiving_records.expired_vendor_document_number IS 'Vendor document number for expired returns';

--

COMMENT ON COLUMN public.receiving_records.near_expiry_erp_document_type IS 'ERP document type for near expiry returns (GRN, PR)';

--

COMMENT ON COLUMN public.receiving_records.near_expiry_erp_document_number IS 'ERP document number for near expiry returns';

--

COMMENT ON COLUMN public.receiving_records.near_expiry_vendor_document_number IS 'Vendor document number for near expiry returns';

--

COMMENT ON COLUMN public.receiving_records.over_stock_erp_document_type IS 'ERP document type for over stock returns (GRN, PR)';

--

COMMENT ON COLUMN public.receiving_records.over_stock_erp_document_number IS 'ERP document number for over stock returns';

--

COMMENT ON COLUMN public.receiving_records.over_stock_vendor_document_number IS 'Vendor document number for over stock returns';

--

COMMENT ON COLUMN public.receiving_records.damage_erp_document_type IS 'ERP document type for damage returns (GRN, PR)';

--

COMMENT ON COLUMN public.receiving_records.damage_erp_document_number IS 'ERP document number for damage returns';

--

COMMENT ON COLUMN public.receiving_records.damage_vendor_document_number IS 'Vendor document number for damage returns';

--

COMMENT ON COLUMN public.receiving_records.has_expired_returns IS 'Whether expired returns were processed';

--

COMMENT ON COLUMN public.receiving_records.has_near_expiry_returns IS 'Whether near expiry returns were processed';

--

COMMENT ON COLUMN public.receiving_records.has_over_stock_returns IS 'Whether over stock returns were processed';

--

COMMENT ON COLUMN public.receiving_records.has_damage_returns IS 'Whether damage returns were processed';

--

COMMENT ON COLUMN public.receiving_records.created_at IS 'When this receiving record was created in system';

--

COMMENT ON COLUMN public.receiving_records.inventory_manager_user_id IS 'Single user responsible for inventory management for this receiving';

--

COMMENT ON COLUMN public.receiving_records.night_supervisor_user_ids IS 'Array of user IDs for night supervisors assigned to this receiving';

--

COMMENT ON COLUMN public.receiving_records.warehouse_handler_user_ids IS 'Array of user IDs for warehouse and stock handlers assigned to this receiving';

--

COMMENT ON COLUMN public.receiving_records.certificate_url IS 'Public URL to the generated clearance certificate image';

--

COMMENT ON COLUMN public.receiving_records.certificate_generated_at IS 'Timestamp when certificate was generated and saved';

--

COMMENT ON COLUMN public.receiving_records.certificate_file_name IS 'Original filename of the certificate in storage';

--

COMMENT ON COLUMN public.receiving_records.original_bill_url IS 'URL to uploaded original bill document (PDF, image, etc.)';

--

COMMENT ON COLUMN public.receiving_records.erp_purchase_invoice_reference IS 'ERP purchase invoice reference number entered by inventory manager when completing receiving task';

--

COMMENT ON COLUMN public.receiving_records.updated_at IS 'Timestamp when the record was last updated';

--

COMMENT ON COLUMN public.receiving_records.pr_excel_file_url IS 'URL link to uploaded PR Excel file stored in Supabase Storage';

--

COMMENT ON COLUMN public.receiving_records.erp_purchase_invoice_uploaded IS 'Boolean flag indicating if ERP purchase invoice reference has been entered by Inventory Manager';

--

COMMENT ON COLUMN public.receiving_records.pr_excel_file_uploaded IS 'Boolean flag indicating if PR Excel file has been uploaded by Inventory Manager';

--

COMMENT ON COLUMN public.receiving_records.original_bill_uploaded IS 'Boolean flag indicating if original bill has been uploaded by Inventory Manager';

--

COMMENT ON TABLE public.vendors IS 'Vendor management table with support for multiple payment methods, return policies, and VAT information';

--

COMMENT ON COLUMN public.vendors.payment_method IS 'Comma-separated list of payment methods: Cash on Delivery, Bank on Delivery, Cash Credit, Bank Credit';

--

COMMENT ON COLUMN public.vendors.credit_period IS 'Credit period in days for credit-based payment methods';

--

COMMENT ON COLUMN public.vendors.bank_name IS 'Bank name for bank-related payment methods';

--

COMMENT ON COLUMN public.vendors.iban IS 'International Bank Account Number for bank transfers';

--

COMMENT ON COLUMN public.vendors.no_return IS 'When TRUE, vendor does not accept any returns regardless of other return policy settings';

--

COMMENT ON COLUMN public.vendors.vat_applicable IS 'VAT applicability status for the vendor';

--

COMMENT ON COLUMN public.vendors.vat_number IS 'VAT registration number when VAT is applicable';

--

COMMENT ON COLUMN public.vendors.branch_id IS 'Branch ID that this vendor belongs to - makes vendor management branch-wise';

--

COMMENT ON COLUMN public.vendors.payment_priority IS 'Payment priority level: Most, Medium, Normal (default), Low';

--

COMMENT ON VIEW public.receiving_records_pr_excel_status IS 'Simple view showing only PR Excel upload status for receiving records';

--

COMMENT ON TABLE public.receiving_task_templates IS 'Reusable task templates for receiving workflow. Each role has one template.';

--

COMMENT ON COLUMN public.receiving_task_templates.role_type IS 'Role type: branch_manager, purchase_manager, inventory_manager, night_supervisor, warehouse_handler, shelf_stocker, accountant';

--

COMMENT ON COLUMN public.receiving_task_templates.title_template IS 'Task title template. Use {placeholders} for dynamic content.';

--

COMMENT ON COLUMN public.receiving_task_templates.description_template IS 'Task description template. Use {placeholders} for branch, vendor, bill details.';

--

COMMENT ON COLUMN public.receiving_task_templates.depends_on_role_types IS 'Array of role types that must complete their tasks before this role can complete theirs';

--

COMMENT ON COLUMN public.receiving_task_templates.require_photo_upload IS 'Whether this role must upload a completion photo';

--

COMMENT ON TABLE public.receiving_tasks IS 'Receiving-specific tasks with full separation from general task system. Links templates with receiving records.';

--

COMMENT ON COLUMN public.receiving_tasks.role_type IS 'Role type for this task: branch_manager, purchase_manager, inventory_manager, night_supervisor, warehouse_handler, shelf_stocker, accountant';

--

COMMENT ON COLUMN public.receiving_tasks.template_id IS 'Foreign key to receiving_task_templates. Defines the task type and role.';

--

COMMENT ON COLUMN public.receiving_tasks.task_status IS 'Current status: pending, in_progress, completed, cancelled';

--

COMMENT ON COLUMN public.receiving_tasks.completion_photo_url IS 'URL of completion photo uploaded by user (required for shelf_stocker role)';

--

COMMENT ON TABLE public.recurring_assignment_schedules IS 'Configuration for recurring task assignments with flexible scheduling';

--

COMMENT ON TABLE public.recurring_schedule_check_log IS 'Log table for recurring schedule checks. 

To manually run the check, execute:
SELECT * FROM check_and_notify_recurring_schedules_with_logging();

--

COMMENT ON TABLE public.requesters IS 'Table to store requester information for expense requisitions';

--

COMMENT ON COLUMN public.requesters.requester_id IS 'Unique identifier for the requester (employee ID or custom ID)';

--

COMMENT ON COLUMN public.requesters.requester_name IS 'Full name of the requester';

--

COMMENT ON COLUMN public.requesters.contact_number IS 'Contact number of the requester';

--

COMMENT ON TABLE public.shelf_paper_templates IS 'Stores shelf paper template designs with field configurations';

--

COMMENT ON COLUMN public.shelf_paper_templates.metadata IS 'Stores template metadata like preview dimensions used for field positioning';

--

COMMENT ON TABLE public.task_assignments IS 'Task assignments to users, branches, or all';

--

COMMENT ON COLUMN public.task_assignments.schedule_date IS 'The date when the task should be started/executed';

--

COMMENT ON COLUMN public.task_assignments.schedule_time IS 'The time when the task should be started/executed';

--

COMMENT ON COLUMN public.task_assignments.deadline_date IS 'The date when the task must be completed';

--

COMMENT ON COLUMN public.task_assignments.deadline_time IS 'The time when the task must be completed';

--

COMMENT ON COLUMN public.task_assignments.deadline_datetime IS 'Computed timestamp combining deadline_date and deadline_time';

--

COMMENT ON COLUMN public.task_assignments.is_reassignable IS 'Whether this assignment can be reassigned to another user';

--

COMMENT ON COLUMN public.task_assignments.is_recurring IS 'Whether this is a recurring assignment';

--

COMMENT ON COLUMN public.task_assignments.recurring_pattern IS 'JSON configuration for recurring patterns';

--

COMMENT ON COLUMN public.task_assignments.notes IS 'Additional instructions or notes for the assignee';

--

COMMENT ON COLUMN public.task_assignments.priority_override IS 'Override the task priority for this specific assignment';

--

COMMENT ON COLUMN public.task_assignments.require_task_finished IS 'Whether task completion confirmation is required';

--

COMMENT ON COLUMN public.task_assignments.require_photo_upload IS 'Whether photo upload is required for completion';

--

COMMENT ON COLUMN public.task_assignments.require_erp_reference IS 'Whether ERP reference is required for completion';

--

COMMENT ON COLUMN public.task_assignments.reassigned_from IS 'Reference to the original assignment if this is a reassignment';

--

COMMENT ON COLUMN public.task_assignments.reassignment_reason IS 'Reason for reassignment';

--

COMMENT ON TABLE public.task_images IS 'Task creation images and completion photos';

--

COMMENT ON TABLE public.task_completions IS 'Individual user task completion records';

--

COMMENT ON COLUMN public.task_completions.completion_photo_url IS 'URL of the uploaded completion photo stored in completion-photos bucket';

--

COMMENT ON TABLE public.tasks IS 'Main task information and metadata';

--

COMMENT ON COLUMN public.tasks.metadata IS 'JSONB field to store task-specific metadata like payment_schedule_id, payment_type, etc.';

--

COMMENT ON TABLE public.task_reminder_logs IS 'Logs all automatic and manual task reminders sent to users';

--

COMMENT ON COLUMN public.user_mobile_theme_assignments.color_overrides IS 'User-specific color overrides. Merge with theme colors at runtime. Stores only properties that differ from base theme.';

--

COMMENT ON TABLE public.variation_audit_log IS 'Audit trail for all variation group operations';

--

COMMENT ON COLUMN public.variation_audit_log.action_type IS 'Type of action performed on variation group';

--

COMMENT ON COLUMN public.variation_audit_log.variation_group_id IS 'UUID of the variation group affected';

--

COMMENT ON COLUMN public.variation_audit_log.affected_barcodes IS 'Array of product barcodes affected by this action';

--

COMMENT ON COLUMN public.variation_audit_log.parent_barcode IS 'Parent product barcode for reference';

--

COMMENT ON COLUMN public.variation_audit_log.group_name_en IS 'English name of the group at time of action';

--

COMMENT ON COLUMN public.variation_audit_log.group_name_ar IS 'Arabic name of the group at time of action';

--

COMMENT ON COLUMN public.variation_audit_log.user_id IS 'User who performed the action';

--

COMMENT ON COLUMN public.variation_audit_log.details IS 'Additional details stored as JSON (before/after state, etc.)';

--

COMMENT ON TABLE public.vendor_payment_schedule IS 'Schedule and track vendor payments';

--

COMMENT ON COLUMN public.vendor_payment_schedule.due_date IS 'Current due date (can be rescheduled)';

--

COMMENT ON COLUMN public.vendor_payment_schedule.scheduled_date IS 'When the payment was scheduled';

--

COMMENT ON COLUMN public.vendor_payment_schedule.paid_date IS 'Timestamp when payment was marked as paid';

--

COMMENT ON COLUMN public.vendor_payment_schedule.original_due_date IS 'Original due date when first scheduled (never changes)';

--

COMMENT ON COLUMN public.vendor_payment_schedule.original_bill_amount IS 'Original bill amount when first scheduled (never changes)';

--

COMMENT ON COLUMN public.vendor_payment_schedule.original_final_amount IS 'Original final amount when first scheduled (never changes)';

--

COMMENT ON COLUMN public.vendor_payment_schedule.is_paid IS 'Boolean flag: true=paid, false=not paid';

--

COMMENT ON COLUMN public.vendor_payment_schedule.payment_reference IS 'Payment reference number (migrated from payment_transactions). Format: CP#XXXX or AUTO-COD-XXXXX';

--

COMMENT ON COLUMN public.vendor_payment_schedule.task_id IS 'Task created for accountant when payment is marked as paid';

--

COMMENT ON COLUMN public.vendor_payment_schedule.task_assignment_id IS 'Task assignment for the accountant';

--

COMMENT ON COLUMN public.vendor_payment_schedule.receiver_user_id IS 'User who received the goods (from receiving_records)';

--

COMMENT ON COLUMN public.vendor_payment_schedule.accountant_user_id IS 'Accountant assigned to process this payment';

--

COMMENT ON COLUMN public.vendor_payment_schedule.verification_status IS 'Payment verification status: pending, verified, rejected';

--

COMMENT ON COLUMN public.vendor_payment_schedule.verified_by IS 'User who verified the payment';

--

COMMENT ON COLUMN public.vendor_payment_schedule.verified_date IS 'Date when payment was verified';

--

COMMENT ON COLUMN public.vendor_payment_schedule.transaction_date IS 'Actual transaction/payment date';

--

COMMENT ON COLUMN public.vendor_payment_schedule.original_bill_url IS 'URL to the original bill/invoice document';

--

COMMENT ON COLUMN public.vendor_payment_schedule.discount_amount IS 'Discount amount deducted from bill';

--

COMMENT ON COLUMN public.vendor_payment_schedule.discount_notes IS 'Notes explaining the discount';

--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_amount IS 'Goods Receipt Return amount deducted from bill';

--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_reference_number IS 'Reference number for GRR document';

--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_notes IS 'Notes for GRR adjustment';

--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_amount IS 'Purchase Return Invoice amount deducted from bill';

--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_reference_number IS 'Reference number for PRI document';

--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_notes IS 'Notes for PRI adjustment';

--

COMMENT ON COLUMN public.vendor_payment_schedule.last_adjustment_date IS 'Date of last adjustment';

--

COMMENT ON COLUMN public.vendor_payment_schedule.last_adjusted_by IS 'User ID who made the last adjustment (stores auth.users.id without FK constraint)';

--

COMMENT ON COLUMN public.vendor_payment_schedule.adjustment_history IS 'JSON array of all adjustment history';

--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_status IS 'Approval workflow status: pending, sent_for_approval, approved, rejected';

--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_requested_by IS 'User who requested approval';

--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_requested_at IS 'Timestamp when approval was requested';

--

COMMENT ON COLUMN public.vendor_payment_schedule.approved_by IS 'User who approved the payment';

--

COMMENT ON COLUMN public.vendor_payment_schedule.approved_at IS 'Timestamp when payment was approved';

--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_notes IS 'Optional notes about the approval decision';

--

COMMENT ON COLUMN public.vendor_payment_schedule.assigned_approver_id IS 'The specific user assigned to approve this vendor payment';

--

COMMENT ON CONSTRAINT vendors_erp_vendor_branch_unique ON public.vendors IS 'Ensures ERP vendor ID is unique within each branch, allowing same vendor ID across different branches';

--

COMMENT ON CONSTRAINT fk_expense_requisitions_branch ON public.expense_requisitions IS 'Links expense requisitions to their branch. ON DELETE RESTRICT prevents deletion of branches with existing requisitions.';

--

COMMENT ON CONSTRAINT receiving_records_vendor_fkey ON public.receiving_records IS 'Foreign key constraint linking receiving_records to vendors using composite key (vendor_id -> erp_vendor_id, branch_id -> branch_id)';

--

COMMENT ON CONSTRAINT task_assignments_assigned_to_branch_id_fkey ON public.task_assignments IS 'Foreign key relationship to branches table for branch assignments';

--

COMMENT ON POLICY "Simple create task assignments policy" ON public.task_assignments IS 'Allow all users to create task assignments';

--

COMMENT ON POLICY "Simple create task completions policy" ON public.task_completions IS 'Allow all users to create task completions';

--

COMMENT ON POLICY "Simple create task images policy" ON public.task_images IS 'Allow all users to create task images';

--

COMMENT ON POLICY "Simple create tasks policy" ON public.tasks IS 'Allow all users to create tasks';

--

COMMENT ON POLICY "Simple delete task images policy" ON public.task_images IS 'Allow all users to delete task images';

--

COMMENT ON POLICY "Simple update task assignments policy" ON public.task_assignments IS 'Allow all users to update task assignments';

--

COMMENT ON POLICY "Simple update task completions policy" ON public.task_completions IS 'Allow all users to update task completions';

--

COMMENT ON POLICY "Simple update task images policy" ON public.task_images IS 'Allow all users to update task images';

--

COMMENT ON POLICY "Simple update tasks policy" ON public.tasks IS 'Allow all users to update tasks';

--

COMMENT ON POLICY "Simple view task assignments policy" ON public.task_assignments IS 'Allow viewing all task assignments';

--

COMMENT ON POLICY "Simple view task completions policy" ON public.task_completions IS 'Allow viewing all task completions';

--

COMMENT ON POLICY "Simple view task images policy" ON public.task_images IS 'Allow viewing all task images';

--

COMMENT ON POLICY "Simple view tasks policy" ON public.tasks IS 'Allow viewing all non-deleted tasks';

--

COMMENT ON POLICY customers_view_own_orders ON public.orders IS 'Customers can view their own orders, management and delivery staff can view all';

--

COMMENT ON POLICY delivery_view_assigned_orders ON public.orders IS 'Delivery personnel can view their assigned orders';

--

COMMENT ON POLICY flyer_offer_products_select_policy ON public.flyer_offer_products IS 'Allows public read access to flyer offer products';

--

COMMENT ON POLICY flyer_offers_select_all_policy ON public.flyer_offers IS 'Allows authenticated users to view all flyer offers including inactive';

--

COMMENT ON POLICY flyer_offers_select_policy ON public.flyer_offers IS 'Allows public read access to active flyer offers only';

--

COMMENT ON POLICY management_view_all_orders ON public.orders IS 'Management, pickers, and delivery staff can view orders';

--

COMMENT ON POLICY pickers_view_assigned_orders ON public.orders IS 'Pickers can view orders assigned to them';

--

COMMENT ON POLICY users_view_order_audit_logs ON public.order_audit_logs IS 'Users can view audit logs for their orders';

--

COMMENT ON POLICY users_view_order_items ON public.order_items IS 'Users can view items for orders they have access to';