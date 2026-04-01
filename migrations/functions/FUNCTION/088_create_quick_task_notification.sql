CREATE FUNCTION public.create_quick_task_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    assigned_by_name TEXT;
    assigned_to_name TEXT;
BEGIN
    -- Get the name of who assigned the task (from hr_employees if available, otherwise username)
    SELECT COALESCE(he.name, u.username, 'Admin') INTO assigned_by_name
    FROM users u
    LEFT JOIN hr_employees he ON u.employee_id = he.id
    WHERE u.id = (SELECT assigned_by FROM quick_tasks WHERE id = NEW.quick_task_id);
    
    -- Get the name of who the task is assigned to (from hr_employees if available, otherwise username)
    SELECT COALESCE(he.name, u.username, 'User') INTO assigned_to_name
    FROM users u
    LEFT JOIN hr_employees he ON u.employee_id = he.id
    WHERE u.id = NEW.assigned_to_user_id;
    
    -- Insert notification for each assigned user
    INSERT INTO notifications (
        title,
        message,
        type,
        priority,
        target_type,
        target_users,
        created_by,
        created_by_name,
        metadata,
        created_at
    )
    SELECT 
        'New Quick Task: ' || qt.title,
        'You have been assigned a new quick task: "' || qt.title || 
        '" by ' || COALESCE(assigned_by_name, 'Admin') || 
        '. Priority: ' || qt.priority || 
        '. Deadline: ' || to_char(qt.deadline_datetime, 'YYYY-MM-DD HH24:MI') ||
        CASE 
            WHEN qt.description IS NOT NULL AND qt.description != '' 
            THEN E'\n\nDescription: ' || qt.description
            ELSE ''
        END,
        'task_assignment',
        qt.priority,
        'specific_users',
        jsonb_build_array(NEW.assigned_to_user_id),
        qt.assigned_by::text,
        COALESCE(assigned_by_name, 'Admin'),
        jsonb_build_object(
            'quick_task_id', qt.id,
            'task_title', qt.title,
            'deadline', qt.deadline_datetime,
            'priority', qt.priority,
            'issue_type', qt.issue_type,
            'assigned_by', qt.assigned_by,
            'assigned_by_name', assigned_by_name,
            'assigned_to_user_id', NEW.assigned_to_user_id,
            'assigned_to_name', assigned_to_name,
            'quick_task_assignment_id', NEW.id,
            'assignment_details', 'Assigned by ' || COALESCE(assigned_by_name, 'Admin') || ' to ' || COALESCE(assigned_to_name, 'User')
        ),
        NOW()
    FROM quick_tasks qt
    WHERE qt.id = NEW.quick_task_id;
    
    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION create_quick_task_notification(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.create_quick_task_notification() IS 'Enhanced notification function that includes assignment details showing who assigned the task to whom';


--
-- Name: create_quick_task_with_assignments(character varying, text, character varying, timestamp with time zone, uuid, uuid[], boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

