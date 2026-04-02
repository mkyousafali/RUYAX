CREATE TABLE public.employee_official_holidays (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    employee_id text NOT NULL,
    official_holiday_id text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: erp_connections; Type: TABLE; Schema: public; Owner: -
--

