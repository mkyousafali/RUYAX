CREATE FUNCTION public.generate_clearance_certificate_tasks(receiving_record_id_param uuid, clearance_certificate_url_param text, created_by_user_id text, created_by_name text DEFAULT NULL::text, created_by_role text DEFAULT NULL::text) RETURNS TABLE(task_count integer, notification_count integer, task_ids uuid[], assignment_ids uuid[])
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_record RECORD;
    vendor_record RECORD;
    task_id UUID;
    assignment_id UUID;
    notification_id UUID;
    deadline_datetime TIMESTAMPTZ;
    task_description TEXT;
    user_id UUID;
    total_tasks INTEGER := 0;
    total_notifications INTEGER := 0;
    created_task_ids UUID[] := '{}';
    created_assignment_ids UUID[] := '{}';
BEGIN
    deadline_datetime := now() + INTERVAL '24 hours';
    
    -- Get receiving record details
    SELECT * INTO receiving_record 
    FROM receiving_records 
    WHERE id = receiving_record_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving record not found: %', receiving_record_id_param;
    END IF;
    
    -- Get vendor details for description
    SELECT vendor_name INTO vendor_record 
    FROM vendors 
    WHERE erp_vendor_id = receiving_record.vendor_id;
    
    task_description := format('Vendor: %s, Bill #: %s, Bill Amount: %s, Bill Date: %s, Received by: %s',
        COALESCE(vendor_record.vendor_name, 'Unknown Vendor'),
        COALESCE(receiving_record.bill_number, 'N/A'),
        COALESCE(receiving_record.bill_amount::TEXT, 'N/A'),
        receiving_record.bill_date::TEXT,
        COALESCE(created_by_name, 'Unknown User')
    );
    
    -- 1. Branch Manager Task
    IF receiving_record.branch_manager_user_id IS NOT NULL THEN
        task_id := create_task(
            'New delivery arrivedΓÇöstart placing.',
            task_description,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            COALESCE(created_by_role, ''),
            'high',
            deadline_datetime::DATE,
            deadline_datetime::TIME,
            true,   -- require_task_finished
            false,  -- require_photo_upload  
            false,  -- require_erp_reference (NO ERP!)
            false,  -- can_escalate
            true    -- can_reassign
        );
        
        assignment_id := assign_task_simple(
            task_id,
            receiving_record.branch_manager_user_id,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            deadline_datetime,
            'high',
            'Clearance certificate attached'
        );
        
        notification_id := create_notification_simple(
            'New Delivery Task Assigned',
            format('You have been assigned a new delivery task: %s', task_description),
            created_by_user_id,
            COALESCE(created_by_name, ''),
            receiving_record.branch_manager_user_id,
            task_id,
            assignment_id
        );
        
        total_tasks := total_tasks + 1;
        total_notifications := total_notifications + 1;
        created_task_ids := created_task_ids || task_id;
        created_assignment_ids := created_assignment_ids || assignment_id;
        
        RAISE NOTICE 'Branch Manager task created: %', task_id;
    END IF;
    
    -- 2. Purchase Manager Task
    IF receiving_record.purchasing_manager_user_id IS NOT NULL THEN
        task_id := create_task(
            'New delivery arrivedΓÇöprice check.',
            task_description,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            COALESCE(created_by_role, ''),
            'medium',
            deadline_datetime::DATE,
            deadline_datetime::TIME,
            true,   -- require_task_finished
            false,  -- require_photo_upload  
            false,  -- require_erp_reference (NO ERP!)
            false,  -- can_escalate
            false   -- can_reassign
        );
        
        assignment_id := assign_task_simple(
            task_id,
            receiving_record.purchasing_manager_user_id,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            deadline_datetime,
            'medium',
            'Clearance certificate attached'
        );
        
        notification_id := create_notification_simple(
            'Price Check Task Assigned',
            format('You have been assigned a price check task: %s', task_description),
            created_by_user_id,
            COALESCE(created_by_name, ''),
            receiving_record.purchasing_manager_user_id,
            task_id,
            assignment_id
        );
        
        total_tasks := total_tasks + 1;
        total_notifications := total_notifications + 1;
        created_task_ids := created_task_ids || task_id;
        created_assignment_ids := created_assignment_ids || assignment_id;
        
        RAISE NOTICE 'Purchase Manager task created: %', task_id;
    END IF;
    
    -- 3. Inventory Manager Task (NO ERP!)
    IF receiving_record.inventory_manager_user_id IS NOT NULL THEN
        task_id := create_task(
            'New delivery arrivedΓÇöenter into the purchase ERP, upload the original bill, and update the ERP purchase invoice number.',
            task_description,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            COALESCE(created_by_role, ''),
            'high',
            deadline_datetime::DATE,
            deadline_datetime::TIME,
            true,   -- require_task_finished
            false,  -- require_photo_upload  
            false,  -- require_erp_reference (NO ERP!)
            false,  -- can_escalate
            false   -- can_reassign
        );
        
        assignment_id := assign_task_simple(
            task_id,
            receiving_record.inventory_manager_user_id,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            deadline_datetime,
            'high',
            'Clearance certificate attached. NO ERP reference required.'
        );
        
        notification_id := create_notification_simple(
            'ERP Entry Task Assigned (No ERP Required)',
            format('You have been assigned an ERP entry task: %s', task_description),
            created_by_user_id,
            COALESCE(created_by_name, ''),
            receiving_record.inventory_manager_user_id,
            task_id,
            assignment_id
        );
        
        total_tasks := total_tasks + 1;
        total_notifications := total_notifications + 1;
        created_task_ids := created_task_ids || task_id;
        created_assignment_ids := created_assignment_ids || assignment_id;
        
        RAISE NOTICE 'Inventory Manager task created: %', task_id;
    END IF;
    
    -- 4. Night Supervisors Tasks
    IF receiving_record.night_supervisor_user_ids IS NOT NULL AND array_length(receiving_record.night_supervisor_user_ids, 1) > 0 THEN
        FOREACH user_id IN ARRAY receiving_record.night_supervisor_user_ids
        LOOP
            task_id := create_task(
                'New delivery arrivedΓÇöconfirm product is placed.',
                task_description,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                COALESCE(created_by_role, ''),
                'medium',
                deadline_datetime::DATE,
                deadline_datetime::TIME,
                true,   -- require_task_finished
                false,  -- require_photo_upload  
                false,  -- require_erp_reference (NO ERP!)
                false,  -- can_escalate
                true    -- can_reassign
            );
            
            assignment_id := assign_task_simple(
                task_id,
                user_id,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                deadline_datetime,
                'medium',
                'Clearance certificate attached'
            );
            
            notification_id := create_notification_simple(
                'Product Placement Task Assigned',
                format('You have been assigned a product placement task: %s', task_description),
                created_by_user_id,
                COALESCE(created_by_name, ''),
                user_id,
                task_id,
                assignment_id
            );
            
            total_tasks := total_tasks + 1;
            total_notifications := total_notifications + 1;
            created_task_ids := created_task_ids || task_id;
            created_assignment_ids := created_assignment_ids || assignment_id;
        END LOOP;
        
        RAISE NOTICE 'Night Supervisor tasks created: %', array_length(receiving_record.night_supervisor_user_ids, 1);
    END IF;
    
    -- 5. Warehouse Handlers Tasks
    IF receiving_record.warehouse_handler_user_ids IS NOT NULL AND array_length(receiving_record.warehouse_handler_user_ids, 1) > 0 THEN
        FOREACH user_id IN ARRAY receiving_record.warehouse_handler_user_ids
        LOOP
            task_id := create_task(
                'New delivery arrivedΓÇöconfirm product is moved to display.',
                task_description,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                COALESCE(created_by_role, ''),
                'medium',
                deadline_datetime::DATE,
                deadline_datetime::TIME,
                true,   -- require_task_finished
                false,  -- require_photo_upload  
                false,  -- require_erp_reference (NO ERP!)
                false,  -- can_escalate
                false   -- can_reassign
            );
            
            assignment_id := assign_task_simple(
                task_id,
                user_id,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                deadline_datetime,
                'medium',
                'Clearance certificate attached'
            );
            
            notification_id := create_notification_simple(
                'Display Movement Task Assigned',
                format('You have been assigned a display movement task: %s', task_description),
                created_by_user_id,
                COALESCE(created_by_name, ''),
                user_id,
                task_id,
                assignment_id
            );
            
            total_tasks := total_tasks + 1;
            total_notifications := total_notifications + 1;
            created_task_ids := created_task_ids || task_id;
            created_assignment_ids := created_assignment_ids || assignment_id;
        END LOOP;
        
        RAISE NOTICE 'Warehouse Handler tasks created: %', array_length(receiving_record.warehouse_handler_user_ids, 1);
    END IF;
    
    -- 6. Shelf Stockers Tasks
    IF receiving_record.shelf_stocker_user_ids IS NOT NULL AND array_length(receiving_record.shelf_stocker_user_ids, 1) > 0 THEN
        FOREACH user_id IN ARRAY receiving_record.shelf_stocker_user_ids
        LOOP
            task_id := create_task(
                'New delivery arrivedΓÇöconfirm product is placed.',
                task_description,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                COALESCE(created_by_role, ''),
                'low',
                deadline_datetime::DATE,
                deadline_datetime::TIME,
                true,   -- require_task_finished
                false,  -- require_photo_upload  
                false,  -- require_erp_reference (NO ERP!)
                false,  -- can_escalate
                false   -- can_reassign
            );
            
            assignment_id := assign_task_simple(
                task_id,
                user_id,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                deadline_datetime,
                'low',
                'Confirm product placement on shelves'
            );
            
            notification_id := create_notification_simple(
                'Shelf Stocking Task Assigned',
                format('You have been assigned a shelf stocking task: %s', task_description),
                created_by_user_id,
                COALESCE(created_by_name, ''),
                user_id,
                task_id,
                assignment_id
            );
            
            total_tasks := total_tasks + 1;
            total_notifications := total_notifications + 1;
            created_task_ids := created_task_ids || task_id;
            created_assignment_ids := created_assignment_ids || assignment_id;
        END LOOP;
        
        RAISE NOTICE 'Shelf Stocker tasks created: %', array_length(receiving_record.shelf_stocker_user_ids, 1);
    END IF;
    
    -- 7. Accountant Task (NO ERP!)
    IF receiving_record.accountant_user_id IS NOT NULL THEN
        task_id := create_task(
            'New delivery arrivedΓÇöconfirm the original has been received and filed, and verify the ERP purchase invoice number with the original entry.',
            task_description,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            COALESCE(created_by_role, ''),
            'medium',
            deadline_datetime::DATE,
            deadline_datetime::TIME,
            true,   -- require_task_finished
            false,  -- require_photo_upload  
            false,  -- require_erp_reference (NO ERP!)
            false,  -- can_escalate
            false   -- can_reassign
        );
        
        assignment_id := assign_task_simple(
            task_id,
            receiving_record.accountant_user_id,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            deadline_datetime,
            'medium',
            'NO ERP reference required'
        );
        
        notification_id := create_notification_simple(
            'Accounting Filing Task Assigned',
            format('You have been assigned an accounting filing task: %s', task_description),
            created_by_user_id,
            COALESCE(created_by_name, ''),
            receiving_record.accountant_user_id,
            task_id,
            assignment_id
        );
        
        total_tasks := total_tasks + 1;
        total_notifications := total_notifications + 1;
        created_task_ids := created_task_ids || task_id;
        created_assignment_ids := created_assignment_ids || assignment_id;
        
        RAISE NOTICE 'Accountant task created: %', task_id;
    END IF;
    
    RAISE NOTICE 'Total tasks created: %, Total notifications sent: %', total_tasks, total_notifications;
    
    RETURN QUERY SELECT total_tasks, total_notifications, created_task_ids, created_assignment_ids;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error in generate_clearance_certificate_tasks: %', SQLERRM;
    RAISE;
END;
$$;


--
-- Name: generate_insurance_company_id(); Type: FUNCTION; Schema: public; Owner: -
--

