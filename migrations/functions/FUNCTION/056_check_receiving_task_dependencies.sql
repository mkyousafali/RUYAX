CREATE FUNCTION public.check_receiving_task_dependencies(receiving_record_id_param uuid, role_type_param text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  template_record RECORD;
  dependency_role TEXT;
  missing_dependencies TEXT[] := ARRAY[]::TEXT[];
  blocking_roles TEXT[] := ARRAY[]::TEXT[];
  completed_dependencies TEXT[] := ARRAY[]::TEXT[];
  v_total_tasks INT;
  v_completed_tasks INT;
BEGIN
  -- Get the template for the role
  SELECT * INTO template_record
  FROM receiving_task_templates
  WHERE role_type = role_type_param;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'can_complete', false,
      'error', 'Template not found for role: ' || role_type_param,
      'missing_dependencies', ARRAY[]::TEXT[],
      'blocking_roles', ARRAY[]::TEXT[],
      'completed_dependencies', ARRAY[]::TEXT[]
    );
  END IF;

  -- If no dependencies, can complete
  IF template_record.depends_on_role_types IS NULL OR array_length(template_record.depends_on_role_types, 1) = 0 THEN
    RETURN json_build_object(
      'can_complete', true,
      'missing_dependencies', ARRAY[]::TEXT[],
      'blocking_roles', ARRAY[]::TEXT[],
      'completed_dependencies', ARRAY[]::TEXT[]
    );
  END IF;

  -- Check each dependency
  -- For array roles (shelf_stocker, warehouse_handler, night_supervisor),
  -- ALL tasks must be completed before the dependent role can proceed
  FOREACH dependency_role IN ARRAY template_record.depends_on_role_types
  LOOP
    -- Count total and completed tasks for this role
    SELECT
      COUNT(*),
      COUNT(*) FILTER (WHERE task_completed = true)
    INTO v_total_tasks, v_completed_tasks
    FROM receiving_tasks
    WHERE receiving_record_id = receiving_record_id_param
      AND role_type = dependency_role;

    IF v_total_tasks = 0 OR v_completed_tasks < v_total_tasks THEN
      -- Either no tasks exist or not ALL are completed
      missing_dependencies := array_append(missing_dependencies, dependency_role);

      CASE dependency_role
        WHEN 'inventory_manager' THEN
          blocking_roles := array_append(blocking_roles, 'Inventory Manager must complete their task first');
        WHEN 'purchase_manager' THEN
          blocking_roles := array_append(blocking_roles, 'Purchase Manager must complete their task first');
        WHEN 'shelf_stocker' THEN
          IF v_total_tasks > 1 THEN
            blocking_roles := array_append(blocking_roles, 'All Shelf Stockers must complete their tasks first (' || v_completed_tasks || '/' || v_total_tasks || ' done)');
          ELSE
            blocking_roles := array_append(blocking_roles, 'Shelf Stocker must complete their task first');
          END IF;
        WHEN 'warehouse_handler' THEN
          IF v_total_tasks > 1 THEN
            blocking_roles := array_append(blocking_roles, 'All Warehouse Handlers must complete their tasks first (' || v_completed_tasks || '/' || v_total_tasks || ' done)');
          ELSE
            blocking_roles := array_append(blocking_roles, 'Warehouse Handler must complete their task first');
          END IF;
        WHEN 'night_supervisor' THEN
          IF v_total_tasks > 1 THEN
            blocking_roles := array_append(blocking_roles, 'All Night Supervisors must complete their tasks first (' || v_completed_tasks || '/' || v_total_tasks || ' done)');
          ELSE
            blocking_roles := array_append(blocking_roles, 'Night Supervisor must complete their task first');
          END IF;
        ELSE
          blocking_roles := array_append(blocking_roles, dependency_role || ' must complete their task first');
      END CASE;
    ELSE
      completed_dependencies := array_append(completed_dependencies, dependency_role);
    END IF;
  END LOOP;

  -- Return result
  IF array_length(missing_dependencies, 1) > 0 THEN
    RETURN json_build_object(
      'can_complete', false,
      'missing_dependencies', missing_dependencies,
      'blocking_roles', blocking_roles,
      'completed_dependencies', completed_dependencies
    );
  ELSE
    RETURN json_build_object(
      'can_complete', true,
      'missing_dependencies', ARRAY[]::TEXT[],
      'blocking_roles', ARRAY[]::TEXT[],
      'completed_dependencies', completed_dependencies
    );
  END IF;
END;
$$;


--
-- Name: check_task_completion_criteria(uuid, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

