CREATE TABLE public.warning_violation (
    id character varying(10) NOT NULL,
    sub_category_id character varying(10) NOT NULL,
    main_category_id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: whatsapp_message_log; Type: TABLE; Schema: public; Owner: -
--

