CREATE TABLE public.employee_checklist_assignments (
    id bigint NOT NULL,
    employee_id text NOT NULL,
    assigned_to_user_id text,
    branch_id bigint,
    checklist_id text NOT NULL,
    frequency_type text NOT NULL,
    day_of_week text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    assigned_by text,
    updated_by text,
    CONSTRAINT employee_checklist_assignments_frequency_type_check CHECK ((frequency_type = ANY (ARRAY['daily'::text, 'weekly'::text])))
);


--
-- Name: employee_checklist_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

