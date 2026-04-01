CREATE TABLE public.denomination_types (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    value numeric(10,2) NOT NULL,
    label character varying(50) NOT NULL,
    label_ar character varying(50),
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE denomination_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.denomination_types IS 'Master table for denomination types (currency notes, coins, damage)';


--
-- Name: denomination_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

