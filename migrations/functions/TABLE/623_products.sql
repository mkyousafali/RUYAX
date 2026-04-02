CREATE TABLE public.products (
    id character varying(10) NOT NULL,
    barcode text NOT NULL,
    product_name_en text,
    product_name_ar text,
    image_url text,
    category_id character varying(10),
    unit_id character varying(10),
    unit_qty numeric DEFAULT 1 NOT NULL,
    sale_price numeric DEFAULT 0 NOT NULL,
    cost numeric DEFAULT 0 NOT NULL,
    profit numeric DEFAULT 0 NOT NULL,
    profit_percentage numeric DEFAULT 0 NOT NULL,
    current_stock integer DEFAULT 0 NOT NULL,
    minim_qty integer DEFAULT 0 NOT NULL,
    minimum_qty_alert integer DEFAULT 0 NOT NULL,
    maximum_qty integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    is_customer_product boolean DEFAULT true,
    is_variation boolean DEFAULT false NOT NULL,
    parent_product_barcode text,
    variation_group_name_en text,
    variation_group_name_ar text,
    variation_order integer DEFAULT 0,
    variation_image_override text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    modified_by uuid,
    modified_at timestamp with time zone
);


--
-- Name: purchase_voucher_issue_types; Type: TABLE; Schema: public; Owner: -
--

