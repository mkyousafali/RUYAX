CREATE TABLE public.erp_synced_products (
    id integer NOT NULL,
    barcode character varying(50) NOT NULL,
    auto_barcode character varying(50),
    parent_barcode character varying(50),
    product_name_en character varying(500),
    product_name_ar character varying(500),
    unit_name character varying(100),
    unit_qty numeric(18,6) DEFAULT 1,
    is_base_unit boolean DEFAULT false,
    synced_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    expiry_dates jsonb DEFAULT '[]'::jsonb,
    managed_by jsonb DEFAULT '[]'::jsonb,
    in_process jsonb DEFAULT '[]'::jsonb,
    expiry_hidden boolean DEFAULT false
);


--
-- Name: erp_synced_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

