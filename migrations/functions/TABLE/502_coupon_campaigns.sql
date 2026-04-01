CREATE TABLE public.coupon_campaigns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_name character varying(255),
    campaign_code character varying(50) NOT NULL,
    description text,
    validity_start_date timestamp with time zone,
    validity_end_date timestamp with time zone,
    is_active boolean DEFAULT true,
    terms_conditions_en text,
    terms_conditions_ar text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    max_claims_per_customer integer DEFAULT 1,
    CONSTRAINT valid_campaign_dates CHECK ((end_date > start_date)),
    CONSTRAINT valid_max_claims CHECK ((max_claims_per_customer > 0))
);


--
-- Name: coupon_claims; Type: TABLE; Schema: public; Owner: -
--

