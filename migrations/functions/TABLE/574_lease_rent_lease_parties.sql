CREATE TABLE public.lease_rent_lease_parties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    property_space_id uuid,
    party_name_en character varying(255) NOT NULL,
    party_name_ar character varying(255) NOT NULL,
    shop_name character varying(255),
    contract_start_date date,
    contract_end_date date,
    lease_amount_contract numeric(12,2) DEFAULT 0,
    lease_amount_outside_contract numeric(12,2) DEFAULT 0,
    utility_charges numeric(12,2) DEFAULT 0,
    security_charges numeric(12,2) DEFAULT 0,
    other_charges jsonb DEFAULT '[]'::jsonb,
    payment_mode character varying(20) DEFAULT 'cash'::character varying,
    collection_incharge_id text,
    payment_period character varying(30) DEFAULT 'monthly'::character varying,
    payment_specific_date integer,
    payment_end_of_month boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_open_contract boolean DEFAULT false,
    contact_number character varying(50),
    email character varying(255)
);


--
-- Name: lease_rent_payment_entries; Type: TABLE; Schema: public; Owner: -
--

