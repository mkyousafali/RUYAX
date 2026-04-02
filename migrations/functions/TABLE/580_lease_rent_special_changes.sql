CREATE TABLE public.lease_rent_special_changes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    field_name character varying(50) NOT NULL,
    old_value numeric(12,2) DEFAULT 0,
    new_value numeric(12,2) NOT NULL,
    effective_from date NOT NULL,
    effective_until date,
    till_end_of_contract boolean DEFAULT false,
    payment_period character varying(20) DEFAULT 'monthly'::character varying,
    reason text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    CONSTRAINT lease_rent_special_changes_party_type_check CHECK (((party_type)::text = ANY ((ARRAY['rent'::character varying, 'lease'::character varying])::text[])))
);


--
-- Name: mobile_themes; Type: TABLE; Schema: public; Owner: -
--

