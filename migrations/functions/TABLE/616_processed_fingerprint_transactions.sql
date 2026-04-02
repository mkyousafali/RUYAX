CREATE TABLE public.processed_fingerprint_transactions (
    id text NOT NULL,
    center_id text NOT NULL,
    employee_id text NOT NULL,
    branch_id text NOT NULL,
    punch_date date NOT NULL,
    punch_time time without time zone NOT NULL,
    status text,
    processed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: processed_fingerprint_transactions_seq; Type: SEQUENCE; Schema: public; Owner: -
--

