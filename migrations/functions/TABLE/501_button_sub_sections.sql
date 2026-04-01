CREATE TABLE public.button_sub_sections (
    id bigint NOT NULL,
    main_section_id bigint NOT NULL,
    subsection_name_en character varying(255) NOT NULL,
    subsection_name_ar character varying(255) NOT NULL,
    subsection_code character varying(50) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: button_sub_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.button_sub_sections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_sub_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: coupon_campaigns; Type: TABLE; Schema: public; Owner: -
--

