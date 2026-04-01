CREATE TABLE public.offer_bundles (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    bundle_name_ar character varying(255) NOT NULL,
    bundle_name_en character varying(255) NOT NULL,
    required_products jsonb NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    discount_type character varying(20) DEFAULT 'amount'::character varying,
    CONSTRAINT offer_bundles_discount_amount_check CHECK ((discount_value > (0)::numeric)),
    CONSTRAINT offer_bundles_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('percentage'::character varying)::text, ('amount'::character varying)::text]))),
    CONSTRAINT offer_bundles_discount_value_check CHECK ((discount_value > (0)::numeric))
);


--
-- Name: TABLE offer_bundles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offer_bundles IS 'Bundle offer configurations with multiple products';


--
-- Name: offer_bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

