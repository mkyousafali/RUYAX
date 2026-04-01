CREATE TABLE public.asset_sub_categories (
    id integer NOT NULL,
    category_id integer NOT NULL,
    group_code character varying(20) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    useful_life_years character varying(20),
    annual_depreciation_pct numeric(8,4) DEFAULT 0,
    monthly_depreciation_pct numeric(8,4) DEFAULT 0,
    residual_pct character varying(20) DEFAULT '0%'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: asset_sub_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

