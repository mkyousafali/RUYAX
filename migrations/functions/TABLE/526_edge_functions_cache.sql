CREATE TABLE public.edge_functions_cache (
    func_name text NOT NULL,
    func_size text,
    file_count integer DEFAULT 0,
    last_modified timestamp with time zone,
    has_index boolean DEFAULT false,
    func_code text DEFAULT ''::text,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: employee_checklist_assignments; Type: TABLE; Schema: public; Owner: -
--

