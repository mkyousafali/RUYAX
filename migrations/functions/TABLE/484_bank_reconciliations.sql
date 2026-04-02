CREATE TABLE public.bank_reconciliations (
    id integer NOT NULL,
    operation_id uuid NOT NULL,
    branch_id integer,
    pos_number integer DEFAULT 1 NOT NULL,
    supervisor_id uuid,
    cashier_id uuid,
    reconciliation_number character varying(100) DEFAULT ''::character varying NOT NULL,
    mada_amount numeric(12,2) DEFAULT 0 NOT NULL,
    visa_amount numeric(12,2) DEFAULT 0 NOT NULL,
    mastercard_amount numeric(12,2) DEFAULT 0 NOT NULL,
    google_pay_amount numeric(12,2) DEFAULT 0 NOT NULL,
    other_amount numeric(12,2) DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: bank_reconciliations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

