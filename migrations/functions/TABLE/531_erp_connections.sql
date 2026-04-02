CREATE TABLE public.erp_connections (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    server_ip text NOT NULL,
    server_name text,
    database_name text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    device_id text,
    erp_branch_id integer,
    tunnel_url text
);


--
-- Name: COLUMN erp_connections.erp_branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.erp_connections.erp_branch_id IS 'Branch ID from ERP system (1, 2, 3, etc.)';


--
-- Name: COLUMN erp_connections.tunnel_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.erp_connections.tunnel_url IS 'Cloudflare Tunnel URL for the ERP bridge API on this branch server';


--
-- Name: erp_daily_sales; Type: TABLE; Schema: public; Owner: -
--

