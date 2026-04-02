CREATE TABLE public.offer_names (
    id text NOT NULL,
    name_en text NOT NULL,
    name_ar text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: TABLE offer_names; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offer_names IS 'Predefined offer name templates';


--
-- Name: offer_products; Type: TABLE; Schema: public; Owner: -
--

