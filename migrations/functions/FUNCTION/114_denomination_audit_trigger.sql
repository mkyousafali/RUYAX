CREATE FUNCTION public.denomination_audit_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO denomination_audit_log (
            record_id, branch_id, user_id, action, record_type, box_number,
            old_counts, new_counts,
            old_erp_balance, new_erp_balance,
            old_grand_total, new_grand_total,
            old_difference, new_difference
        ) VALUES (
            NEW.id, NEW.branch_id, NEW.user_id, 'INSERT', NEW.record_type, NEW.box_number,
            NULL, NEW.counts,
            NULL, NEW.erp_balance,
            NULL, NEW.grand_total,
            NULL, NEW.difference
        );
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO denomination_audit_log (
            record_id, branch_id, user_id, action, record_type, box_number,
            old_counts, new_counts,
            old_erp_balance, new_erp_balance,
            old_grand_total, new_grand_total,
            old_difference, new_difference
        ) VALUES (
            NEW.id, NEW.branch_id, NEW.user_id, 'UPDATE', NEW.record_type, NEW.box_number,
            OLD.counts, NEW.counts,
            OLD.erp_balance, NEW.erp_balance,
            OLD.grand_total, NEW.grand_total,
            OLD.difference, NEW.difference
        );
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO denomination_audit_log (
            record_id, branch_id, user_id, action, record_type, box_number,
            old_counts, new_counts,
            old_erp_balance, new_erp_balance,
            old_grand_total, new_grand_total,
            old_difference, new_difference
        ) VALUES (
            OLD.id, OLD.branch_id, OLD.user_id, 'DELETE', OLD.record_type, OLD.box_number,
            OLD.counts, NULL,
            OLD.erp_balance, NULL,
            OLD.grand_total, NULL,
            OLD.difference, NULL
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: duplicate_flyer_template(uuid, character varying, uuid); Type: FUNCTION; Schema: public; Owner: -
--

