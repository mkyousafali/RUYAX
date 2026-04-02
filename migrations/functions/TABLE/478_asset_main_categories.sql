CREATE TABLE public.asset_main_categories (
    id integer NOT NULL,
    group_code character varying(20) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: asset_main_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

