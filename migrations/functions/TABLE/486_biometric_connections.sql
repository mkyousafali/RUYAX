CREATE TABLE public.biometric_connections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    branch_name text NOT NULL,
    server_ip text NOT NULL,
    server_name text,
    database_name text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    device_id text NOT NULL,
    terminal_sn text,
    is_active boolean DEFAULT true,
    last_sync_at timestamp with time zone,
    last_employee_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    branch_location_code text
);


--
-- Name: TABLE biometric_connections; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.biometric_connections IS 'Stores biometric server connection configurations for ZKBioTime attendance sync';


--
-- Name: COLUMN biometric_connections.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.branch_id IS 'References branches.id - which Aqura branch this config belongs to';


--
-- Name: COLUMN biometric_connections.server_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.server_ip IS 'IP address of ZKBioTime SQL Server (e.g., 192.168.0.3)';


--
-- Name: COLUMN biometric_connections.server_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.server_name IS 'SQL Server instance name (e.g., SQLEXPRESS, WIN-D1D6EN8240A)';


--
-- Name: COLUMN biometric_connections.database_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.database_name IS 'ZKBioTime database name (e.g., Zkurbard)';


--
-- Name: COLUMN biometric_connections.device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.device_id IS 'Computer name/ID running the sync app';


--
-- Name: COLUMN biometric_connections.terminal_sn; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.terminal_sn IS 'Optional: Filter by specific terminal serial number (e.g., MFP3243700773)';


--
-- Name: COLUMN biometric_connections.last_sync_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.last_sync_at IS 'Timestamp of last punch transaction sync';


--
-- Name: COLUMN biometric_connections.last_employee_sync_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.biometric_connections.last_employee_sync_at IS 'Timestamp of last employee sync';


--
-- Name: bogo_offer_rules; Type: TABLE; Schema: public; Owner: -
--

