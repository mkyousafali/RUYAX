CREATE TABLE public.customer_app_media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    media_type character varying(10) NOT NULL,
    slot_number integer NOT NULL,
    title_en character varying(255) NOT NULL,
    title_ar character varying(255) NOT NULL,
    description_en text,
    description_ar text,
    file_url text NOT NULL,
    file_size bigint,
    file_type character varying(50),
    duration integer,
    is_active boolean DEFAULT false,
    display_order integer DEFAULT 0,
    is_infinite boolean DEFAULT false,
    expiry_date timestamp with time zone,
    uploaded_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    activated_at timestamp with time zone,
    deactivated_at timestamp with time zone,
    CONSTRAINT customer_app_media_media_type_check CHECK (((media_type)::text = ANY (ARRAY[('video'::character varying)::text, ('image'::character varying)::text]))),
    CONSTRAINT customer_app_media_slot_number_check CHECK (((slot_number >= 1) AND (slot_number <= 6))),
    CONSTRAINT expiry_required_unless_infinite CHECK (((is_infinite = true) OR (expiry_date IS NOT NULL)))
);


--
-- Name: TABLE customer_app_media; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.customer_app_media IS 'Stores videos and images displayed on customer home page with expiry management';


--
-- Name: customer_product_requests; Type: TABLE; Schema: public; Owner: -
--

