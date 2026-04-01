CREATE TABLE public.system_api_keys (
    id integer NOT NULL,
    service_name character varying(100) NOT NULL,
    api_key text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: system_api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

