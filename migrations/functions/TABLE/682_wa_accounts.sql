CREATE TABLE public.wa_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone_number character varying(20) NOT NULL,
    display_name text,
    waba_id text,
    phone_number_id text,
    access_token text,
    quality_rating character varying(10) DEFAULT 'GREEN'::character varying,
    status character varying(20) DEFAULT 'connected'::character varying,
    is_default boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true,
    branch_id uuid,
    payment_pending numeric(12,2) DEFAULT 0,
    payment_currency text DEFAULT 'USD'::text,
    last_payment_date timestamp without time zone,
    meta_business_account_id text,
    meta_access_token text
);


--
-- Name: wa_ai_bot_config; Type: TABLE; Schema: public; Owner: -
--

