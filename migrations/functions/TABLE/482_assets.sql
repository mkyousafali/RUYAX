CREATE TABLE public.assets (
    id integer NOT NULL,
    asset_id character varying(30) NOT NULL,
    sub_category_id integer NOT NULL,
    asset_name_en character varying(255) NOT NULL,
    asset_name_ar character varying(255) NOT NULL,
    purchase_date date,
    purchase_value numeric(12,2) DEFAULT 0,
    branch_id integer,
    invoice_url text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

