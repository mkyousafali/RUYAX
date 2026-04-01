CREATE TABLE public.privilege_cards_branch (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    privilege_card_id integer NOT NULL,
    card_number character varying(50) NOT NULL,
    branch_id integer NOT NULL,
    card_balance numeric(10,4) DEFAULT 0,
    card_holder_name character varying(255),
    total_redemptions numeric(10,4) DEFAULT 0,
    redemption_count integer DEFAULT 0,
    expiry_date date,
    mobile character varying(20),
    last_sync_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: privilege_cards_master; Type: TABLE; Schema: public; Owner: -
--

