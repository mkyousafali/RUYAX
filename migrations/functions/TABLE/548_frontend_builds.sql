CREATE TABLE public.frontend_builds (
    id integer NOT NULL,
    version text NOT NULL,
    file_name text NOT NULL,
    file_size bigint DEFAULT 0 NOT NULL,
    storage_path text NOT NULL,
    notes text,
    uploaded_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: frontend_builds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

