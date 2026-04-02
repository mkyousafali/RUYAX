CREATE TABLE public.receiving_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    receiving_record_id uuid NOT NULL,
    role_type character varying(50) NOT NULL,
    assigned_user_id uuid,
    requires_erp_reference boolean DEFAULT false,
    requires_original_bill_upload boolean DEFAULT false,
    requires_reassignment boolean DEFAULT false,
    requires_task_finished_mark boolean DEFAULT true,
    erp_reference_number character varying(255),
    original_bill_uploaded boolean DEFAULT false,
    original_bill_file_path text,
    task_completed boolean DEFAULT false,
    completed_at timestamp with time zone,
    clearance_certificate_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    template_id uuid,
    task_status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    title text,
    description text,
    priority character varying(20) DEFAULT 'high'::character varying,
    due_date timestamp with time zone,
    completed_by_user_id uuid,
    completion_photo_url text,
    completion_notes text,
    rule_effective_date timestamp with time zone,
    CONSTRAINT receiving_tasks_role_type_check CHECK (((role_type)::text = ANY (ARRAY[('branch_manager'::character varying)::text, ('purchase_manager'::character varying)::text, ('inventory_manager'::character varying)::text, ('night_supervisor'::character varying)::text, ('warehouse_handler'::character varying)::text, ('shelf_stocker'::character varying)::text, ('accountant'::character varying)::text]))),
    CONSTRAINT receiving_tasks_task_status_check CHECK (((task_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('in_progress'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text])))
);


--
-- Name: TABLE receiving_tasks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.receiving_tasks IS 'Receiving-specific tasks with full separation from general task system. Links templates with receiving records.';


--
-- Name: COLUMN receiving_tasks.role_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_tasks.role_type IS 'Role type for this task: branch_manager, purchase_manager, inventory_manager, night_supervisor, warehouse_handler, shelf_stocker, accountant';


--
-- Name: COLUMN receiving_tasks.template_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_tasks.template_id IS 'Foreign key to receiving_task_templates. Defines the task type and role.';


--
-- Name: COLUMN receiving_tasks.task_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_tasks.task_status IS 'Current status: pending, in_progress, completed, cancelled';


--
-- Name: COLUMN receiving_tasks.completion_photo_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_tasks.completion_photo_url IS 'URL of completion photo uploaded by user (required for shelf_stocker role)';


--
-- Name: receiving_user_defaults; Type: TABLE; Schema: public; Owner: -
--

