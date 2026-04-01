CREATE TABLE public.lease_rent_payment_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    period_num integer NOT NULL,
    column_name character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    paid_date date DEFAULT CURRENT_DATE NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: lease_rent_payments; Type: TABLE; Schema: public; Owner: -
--

