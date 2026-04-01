CREATE TABLE public.branch_default_positions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    branch_manager_user_id uuid,
    purchasing_manager_user_id uuid,
    inventory_manager_user_id uuid,
    accountant_user_id uuid,
    night_supervisor_user_ids uuid[] DEFAULT '{}'::uuid[],
    warehouse_handler_user_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: branch_sync_config; Type: TABLE; Schema: public; Owner: -
--

