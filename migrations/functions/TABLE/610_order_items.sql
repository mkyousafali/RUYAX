CREATE TABLE public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id character varying(50) NOT NULL,
    product_name_ar character varying(255) NOT NULL,
    product_name_en character varying(255) NOT NULL,
    product_sku character varying(100),
    unit_id character varying(50),
    unit_name_ar character varying(100),
    unit_name_en character varying(100),
    unit_size character varying(50),
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    original_price numeric(10,2) NOT NULL,
    discount_amount numeric(10,2) DEFAULT 0 NOT NULL,
    final_price numeric(10,2) NOT NULL,
    line_total numeric(10,2) NOT NULL,
    has_offer boolean DEFAULT false NOT NULL,
    offer_id integer,
    offer_name_ar character varying(255),
    offer_name_en character varying(255),
    offer_type character varying(50),
    offer_discount_percentage numeric(5,2),
    offer_special_price numeric(10,2),
    item_type character varying(20) DEFAULT 'regular'::character varying NOT NULL,
    bundle_id uuid,
    bundle_name_ar character varying(255),
    bundle_name_en character varying(255),
    is_bundle_item boolean DEFAULT false NOT NULL,
    is_bogo_free boolean DEFAULT false NOT NULL,
    bogo_group_id uuid,
    tax_rate numeric(5,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0 NOT NULL,
    item_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY public.order_items REPLICA IDENTITY FULL;


--
-- Name: TABLE order_items; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.order_items IS 'Individual line items within customer orders';


--
-- Name: COLUMN order_items.product_name_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_items.product_name_ar IS 'Product name snapshot in Arabic at time of order';


--
-- Name: COLUMN order_items.product_name_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_items.product_name_en IS 'Product name snapshot in English at time of order';


--
-- Name: COLUMN order_items.unit_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_items.unit_price IS 'Price per unit at time of order';


--
-- Name: COLUMN order_items.final_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_items.final_price IS 'Price after applying discounts/offers';


--
-- Name: COLUMN order_items.line_total; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_items.line_total IS 'Total for this line (final_price * quantity)';


--
-- Name: COLUMN order_items.item_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_items.item_type IS 'Type of item: regular, bundle_item, bogo_free, bogo_discounted';


--
-- Name: COLUMN order_items.bundle_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_items.bundle_id IS 'Groups items that belong to the same bundle purchase';


--
-- Name: COLUMN order_items.bogo_group_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_items.bogo_group_id IS 'Groups items involved in the same BOGO offer';


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

