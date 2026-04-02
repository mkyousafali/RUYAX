CREATE TABLE public.erp_daily_sales (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    branch_id bigint NOT NULL,
    sale_date date NOT NULL,
    total_bills integer DEFAULT 0,
    gross_amount numeric(18,2) DEFAULT 0,
    tax_amount numeric(18,2) DEFAULT 0,
    discount_amount numeric(18,2) DEFAULT 0,
    total_returns integer DEFAULT 0,
    return_amount numeric(18,2) DEFAULT 0,
    return_tax numeric(18,2) DEFAULT 0,
    net_bills integer DEFAULT 0,
    net_amount numeric(18,2) DEFAULT 0,
    net_tax numeric(18,2) DEFAULT 0,
    last_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: erp_sync_logs; Type: TABLE; Schema: public; Owner: -
--

