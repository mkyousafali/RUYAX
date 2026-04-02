CREATE TABLE public.denomination_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    section character varying(20) NOT NULL,
    transaction_type character varying(50) NOT NULL,
    amount numeric(15,2) NOT NULL,
    remarks text,
    apply_denomination boolean DEFAULT false,
    denomination_details jsonb DEFAULT '{}'::jsonb,
    entity_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL,
    CONSTRAINT denomination_transactions_section_check CHECK (((section)::text = ANY ((ARRAY['paid'::character varying, 'received'::character varying])::text[]))),
    CONSTRAINT denomination_transactions_transaction_type_check CHECK (((transaction_type)::text = ANY ((ARRAY['vendor'::character varying, 'expenses'::character varying, 'user'::character varying, 'other'::character varying])::text[])))
);


--
-- Name: denomination_types; Type: TABLE; Schema: public; Owner: -
--

