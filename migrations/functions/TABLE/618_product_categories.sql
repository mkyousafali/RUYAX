CREATE TABLE public.product_categories (
    id character varying(10) NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    image_url text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: product_request_bt; Type: TABLE; Schema: public; Owner: -
--

