CREATE TABLE public.sidebar_buttons (
    id bigint NOT NULL,
    main_section_id bigint NOT NULL,
    subsection_id bigint NOT NULL,
    button_name_en character varying(255) NOT NULL,
    button_name_ar character varying(255) NOT NULL,
    button_code character varying(100) NOT NULL,
    icon character varying(50),
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: sidebar_buttons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.sidebar_buttons ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sidebar_buttons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: social_links; Type: TABLE; Schema: public; Owner: -
--

