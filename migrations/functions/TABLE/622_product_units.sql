CREATE TABLE public.product_units (
    id character varying(10) NOT NULL,
    name_en character varying(50) NOT NULL,
    name_ar character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

