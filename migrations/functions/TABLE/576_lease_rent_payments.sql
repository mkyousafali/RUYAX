CREATE TABLE public.lease_rent_payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    period_num integer NOT NULL,
    period_from date NOT NULL,
    period_to date NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    paid_amount numeric(12,2) DEFAULT 0 NOT NULL,
    is_fully_paid boolean DEFAULT false NOT NULL,
    paid_at timestamp with time zone DEFAULT now(),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    paid_contract numeric(12,2) DEFAULT 0,
    paid_outside numeric(12,2) DEFAULT 0,
    paid_utility numeric(12,2) DEFAULT 0,
    paid_security numeric(12,2) DEFAULT 0,
    paid_other numeric(12,2) DEFAULT 0,
    paid_date date,
    CONSTRAINT lease_rent_payments_party_type_check CHECK (((party_type)::text = ANY ((ARRAY['rent'::character varying, 'lease'::character varying])::text[])))
);


--
-- Name: lease_rent_properties; Type: TABLE; Schema: public; Owner: -
--

