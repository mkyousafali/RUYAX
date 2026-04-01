CREATE TABLE public.employee_fine_payments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    warning_id uuid,
    payment_method character varying(50),
    payment_amount numeric(10,2) NOT NULL,
    payment_currency character varying(3) DEFAULT 'USD'::character varying,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    payment_reference character varying(100),
    payment_notes text,
    processed_by uuid,
    processed_by_username character varying(255),
    account_code character varying(50),
    transaction_id character varying(100),
    receipt_number character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE employee_fine_payments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.employee_fine_payments IS 'Payment history for fines associated with warnings';


--
-- Name: employee_official_holidays; Type: TABLE; Schema: public; Owner: -
--

