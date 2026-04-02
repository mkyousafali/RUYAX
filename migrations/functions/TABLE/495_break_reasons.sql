CREATE TABLE public.break_reasons (
    id integer NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    requires_note boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: break_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

