CREATE TABLE public.coupon_claims (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    customer_mobile character varying(20) NOT NULL,
    product_id uuid,
    branch_id bigint,
    claimed_by_user uuid,
    claimed_at timestamp with time zone DEFAULT now(),
    print_count integer DEFAULT 1,
    barcode_scanned boolean DEFAULT false,
    validity_date date NOT NULL,
    status character varying(20) DEFAULT 'claimed'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    max_claims_per_customer integer DEFAULT 1,
    CONSTRAINT valid_status CHECK (((status)::text = ANY (ARRAY[('claimed'::character varying)::text, ('redeemed'::character varying)::text, ('expired'::character varying)::text])))
);


--
-- Name: coupon_eligible_customers; Type: TABLE; Schema: public; Owner: -
--

