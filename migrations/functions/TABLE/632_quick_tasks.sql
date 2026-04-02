CREATE TABLE public.quick_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    price_tag character varying(50),
    issue_type character varying(100) NOT NULL,
    priority character varying(50) NOT NULL,
    assigned_by uuid NOT NULL,
    assigned_to_branch_id bigint,
    created_at timestamp with time zone DEFAULT now(),
    deadline_datetime timestamp with time zone DEFAULT (now() + '24:00:00'::interval),
    completed_at timestamp with time zone,
    status character varying(50) DEFAULT 'pending'::character varying,
    created_from character varying(50) DEFAULT 'quick_task'::character varying,
    updated_at timestamp with time zone DEFAULT now(),
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    incident_id text,
    product_request_id uuid,
    product_request_type character varying(5),
    order_id uuid,
    CONSTRAINT chk_require_task_finished_not_null CHECK ((require_task_finished IS NOT NULL))
);


--
-- Name: COLUMN quick_tasks.require_task_finished; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.require_task_finished IS 'Default requirement for task completion (always required)';


--
-- Name: COLUMN quick_tasks.require_photo_upload; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.require_photo_upload IS 'Default requirement for photo upload on task completion';


--
-- Name: COLUMN quick_tasks.require_erp_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.require_erp_reference IS 'Default requirement for ERP reference on task completion';


--
-- Name: COLUMN quick_tasks.incident_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.incident_id IS 'Reference to the incident that triggered this quick task';


--
-- Name: COLUMN quick_tasks.product_request_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.product_request_id IS 'Reference to the product request that triggered this quick task';


--
-- Name: COLUMN quick_tasks.product_request_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_tasks.product_request_type IS 'Type of product request: PO, ST, or BT';


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

