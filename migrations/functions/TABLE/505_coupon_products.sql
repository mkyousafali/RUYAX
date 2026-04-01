CREATE TABLE public.coupon_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    product_name_en character varying(255) NOT NULL,
    product_name_ar character varying(255) NOT NULL,
    product_image_url text,
    original_price numeric(10,2) NOT NULL,
    offer_price numeric(10,2) NOT NULL,
    special_barcode character varying(50) NOT NULL,
    stock_limit integer DEFAULT 0 NOT NULL,
    stock_remaining integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    flyer_product_id character varying(10),
    CONSTRAINT valid_price CHECK (((offer_price >= (0)::numeric) AND (original_price >= offer_price))),
    CONSTRAINT valid_stock CHECK (((stock_remaining >= 0) AND (stock_remaining <= stock_limit)))
);


--
-- Name: customer_access_code_history; Type: TABLE; Schema: public; Owner: -
--

