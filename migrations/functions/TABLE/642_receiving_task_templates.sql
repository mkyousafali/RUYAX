CREATE TABLE public.receiving_task_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_type character varying(50) NOT NULL,
    title_template text NOT NULL,
    description_template text NOT NULL,
    require_erp_reference boolean DEFAULT false NOT NULL,
    require_original_bill_upload boolean DEFAULT false NOT NULL,
    require_task_finished_mark boolean DEFAULT true NOT NULL,
    priority character varying(20) DEFAULT 'high'::character varying NOT NULL,
    deadline_hours integer DEFAULT 24 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    depends_on_role_types text[] DEFAULT '{}'::text[],
    require_photo_upload boolean DEFAULT false,
    CONSTRAINT receiving_task_templates_deadline_hours_check CHECK (((deadline_hours > 0) AND (deadline_hours <= 168))),
    CONSTRAINT receiving_task_templates_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('medium'::character varying)::text, ('high'::character varying)::text, ('urgent'::character varying)::text]))),
    CONSTRAINT receiving_task_templates_role_type_check CHECK (((role_type)::text = ANY (ARRAY[('branch_manager'::character varying)::text, ('purchase_manager'::character varying)::text, ('inventory_manager'::character varying)::text, ('night_supervisor'::character varying)::text, ('warehouse_handler'::character varying)::text, ('shelf_stocker'::character varying)::text, ('accountant'::character varying)::text])))
);


--
-- Name: TABLE receiving_task_templates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.receiving_task_templates IS 'Reusable task templates for receiving workflow. Each role has one template.';


--
-- Name: COLUMN receiving_task_templates.role_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_task_templates.role_type IS 'Role type: branch_manager, purchase_manager, inventory_manager, night_supervisor, warehouse_handler, shelf_stocker, accountant';


--
-- Name: COLUMN receiving_task_templates.title_template; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_task_templates.title_template IS 'Task title template. Use {placeholders} for dynamic content.';


--
-- Name: COLUMN receiving_task_templates.description_template; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_task_templates.description_template IS 'Task description template. Use {placeholders} for branch, vendor, bill details.';


--
-- Name: COLUMN receiving_task_templates.depends_on_role_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_task_templates.depends_on_role_types IS 'Array of role types that must complete their tasks before this role can complete theirs';


--
-- Name: COLUMN receiving_task_templates.require_photo_upload; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.receiving_task_templates.require_photo_upload IS 'Whether this role must upload a completion photo';


--
-- Name: receiving_tasks; Type: TABLE; Schema: public; Owner: -
--

