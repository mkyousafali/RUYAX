CREATE TABLE public.offers (
    id integer NOT NULL,
    type character varying(20) NOT NULL,
    name_ar character varying(255) NOT NULL,
    name_en character varying(255) NOT NULL,
    description_ar text,
    description_en text,
    start_date timestamp with time zone DEFAULT now() NOT NULL,
    end_date timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true,
    max_uses_per_customer integer,
    max_total_uses integer,
    current_total_uses integer DEFAULT 0,
    branch_id integer,
    service_type character varying(20) DEFAULT 'both'::character varying,
    show_on_product_page boolean DEFAULT true,
    show_in_carousel boolean DEFAULT false,
    send_push_notification boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT offers_service_type_check CHECK (((service_type)::text = ANY (ARRAY[('delivery'::character varying)::text, ('pickup'::character varying)::text, ('both'::character varying)::text]))),
    CONSTRAINT offers_type_check CHECK (((type)::text = ANY (ARRAY[('bundle'::character varying)::text, ('cart'::character varying)::text, ('product'::character varying)::text, ('bogo'::character varying)::text]))),
    CONSTRAINT valid_date_range CHECK ((end_date > start_date))
);


--
-- Name: TABLE offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offers IS 'Main offers table with all offer configurations and rules';


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

