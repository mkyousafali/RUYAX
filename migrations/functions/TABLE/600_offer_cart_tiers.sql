CREATE TABLE public.offer_cart_tiers (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    tier_number integer NOT NULL,
    min_amount numeric(10,2) NOT NULL,
    max_amount numeric(10,2),
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT offer_cart_tiers_check CHECK (((max_amount IS NULL) OR (max_amount > min_amount))),
    CONSTRAINT offer_cart_tiers_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('percentage'::character varying)::text, ('fixed'::character varying)::text]))),
    CONSTRAINT offer_cart_tiers_discount_value_check CHECK ((discount_value >= (0)::numeric)),
    CONSTRAINT offer_cart_tiers_min_amount_check CHECK ((min_amount >= (0)::numeric)),
    CONSTRAINT offer_cart_tiers_tier_number_check CHECK (((tier_number >= 1) AND (tier_number <= 6)))
);


--
-- Name: offer_cart_tiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

