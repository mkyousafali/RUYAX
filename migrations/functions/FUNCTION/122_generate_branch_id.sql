CREATE FUNCTION public.generate_branch_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    prefix VARCHAR(2);
    next_num INTEGER;
BEGIN
    -- Always generate branch_id if not provided or empty
    IF NEW.branch_id IS NULL OR NEW.branch_id = '' THEN
        -- Determine prefix based on branch type
        prefix := CASE 
            WHEN NEW.branch_type = 'head_branch' THEN 'HB'
            ELSE 'BR'
        END;
        
        -- Get next number for this branch type by finding the highest existing number
        SELECT COALESCE(MAX(
            CASE 
                WHEN branch_id ~ ('^' || prefix || '[0-9]+$') 
                THEN CAST(SUBSTRING(branch_id FROM LENGTH(prefix) + 1) AS INTEGER)
                ELSE 0
            END
        ), 0) + 1
        INTO next_num
        FROM branches 
        WHERE branch_id LIKE prefix || '%';
        
        -- Generate new branch_id with zero-padded number
        NEW.branch_id := prefix || LPAD(next_num::TEXT, 3, '0');
    END IF;
    
    RETURN NEW;
END;
$_$;


--
-- Name: generate_campaign_code(); Type: FUNCTION; Schema: public; Owner: -
--

