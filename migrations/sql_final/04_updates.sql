UPDATE public.customers
            SET name = p_name,
                access_code = v_hashed_code,
                access_code_generated_at = now(),
                registration_status = 'approved',
                updated_at = now()
            WHERE id = v_existing_customer.id
            RETURNING id INTO v_customer_id;

UPDATE break_register
  SET end_time = NOW(),
      duration_seconds = v_duration,
      status = 'closed'
  WHERE id = v_break.id;

UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = v_current_time,
        updated_at = v_current_time
    WHERE id = p_customer_id;

UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = now(),
        updated_at = now()
    WHERE id = v_customer.id;

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

UPDATE users
  SET quick_access_code = v_hashed_code,
      updated_at = NOW()
  WHERE id = v_user_id;

UPDATE quick_task_completions 
    SET completion_status = new_status,
        verified_by_user_id = verified_by_user_id_param,
        verified_at = now(),
        verification_notes = verification_notes_param,
        updated_at = now()
    WHERE id = completion_id_param;