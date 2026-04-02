CREATE TABLE public.official_holidays (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    holiday_date date NOT NULL,
    name_en text DEFAULT ''::text NOT NULL,
    name_ar text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: order_audit_logs; Type: TABLE; Schema: public; Owner: -
--

