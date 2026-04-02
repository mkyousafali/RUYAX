CREATE FUNCTION public.create_warning_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Handle different trigger operations
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employee_warning_history (
            warning_id,
            action_type,
            new_values,
            changed_by,
            changed_by_username,
            change_reason
        ) VALUES (
            NEW.id,
            'created',
            row_to_json(NEW),
            NEW.issued_by,
            NEW.issued_by_username,
            'Warning created'
        );
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employee_warning_history (
            warning_id,
            action_type,
            old_values,
            new_values,
            changed_by,
            changed_by_username,
            change_reason
        ) VALUES (
            NEW.id,
            'updated',
            row_to_json(OLD),
            row_to_json(NEW),
            NEW.issued_by,
            NEW.issued_by_username,
            'Warning updated'
        );
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employee_warning_history (
            warning_id,
            action_type,
            old_values,
            changed_by,
            changed_by_username,
            change_reason
        ) VALUES (
            OLD.id,
            'deleted',
            row_to_json(OLD),
            OLD.deleted_by,
            'system',
            'Warning deleted'
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: current_user_is_admin(); Type: FUNCTION; Schema: public; Owner: -
--

