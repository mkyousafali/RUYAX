CREATE TABLE public.erp_sync_logs (
    id integer NOT NULL,
    sync_type text DEFAULT 'auto'::text NOT NULL,
    branches_total integer DEFAULT 0,
    branches_success integer DEFAULT 0,
    branches_failed integer DEFAULT 0,
    products_fetched integer DEFAULT 0,
    products_inserted integer DEFAULT 0,
    products_updated integer DEFAULT 0,
    duration_ms integer DEFAULT 0,
    details jsonb,
    triggered_by text DEFAULT 'pg_cron'::text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: erp_sync_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

