CREATE TABLE public.flyer_offer_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_id uuid NOT NULL,
    product_barcode text NOT NULL,
    cost numeric(10,2),
    sales_price numeric(10,2),
    offer_price numeric(10,2),
    profit_amount numeric(10,2),
    profit_percent numeric(10,2),
    profit_after_offer numeric(10,2),
    decrease_amount numeric(10,2),
    offer_qty integer DEFAULT 1 NOT NULL,
    limit_qty integer,
    free_qty integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    page_number integer DEFAULT 1,
    page_order integer DEFAULT 1,
    total_sales_price numeric DEFAULT 0,
    total_offer_price numeric DEFAULT 0,
    CONSTRAINT flyer_offer_products_free_qty_check CHECK ((free_qty >= 0)),
    CONSTRAINT flyer_offer_products_offer_qty_check CHECK ((offer_qty >= 0))
);


--
-- Name: TABLE flyer_offer_products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.flyer_offer_products IS 'Junction table linking flyer offers to products with pricing details';


--
-- Name: COLUMN flyer_offer_products.offer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.offer_id IS 'Reference to the flyer offer';


--
-- Name: COLUMN flyer_offer_products.product_barcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.product_barcode IS 'Reference to the product barcode';


--
-- Name: COLUMN flyer_offer_products.cost; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.cost IS 'Product cost price';


--
-- Name: COLUMN flyer_offer_products.sales_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.sales_price IS 'Regular sales price';


--
-- Name: COLUMN flyer_offer_products.offer_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.offer_price IS 'Special offer price';


--
-- Name: COLUMN flyer_offer_products.profit_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.profit_amount IS 'Profit amount in currency';


--
-- Name: COLUMN flyer_offer_products.profit_percent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.profit_percent IS 'Profit as percentage';


--
-- Name: COLUMN flyer_offer_products.profit_after_offer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.profit_after_offer IS 'Profit after applying offer discount';


--
-- Name: COLUMN flyer_offer_products.decrease_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.decrease_amount IS 'Amount decreased from regular price';


--
-- Name: COLUMN flyer_offer_products.offer_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.offer_qty IS 'Quantity required to qualify for offer';


--
-- Name: COLUMN flyer_offer_products.limit_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.limit_qty IS 'Maximum quantity limit per customer (nullable)';


--
-- Name: COLUMN flyer_offer_products.free_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.free_qty IS 'Free quantity given with purchase';


--
-- Name: COLUMN flyer_offer_products.page_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.page_number IS 'The page number where this product appears in the flyer';


--
-- Name: COLUMN flyer_offer_products.page_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offer_products.page_order IS 'The order/position of this product on its page';


--
-- Name: flyer_offers; Type: TABLE; Schema: public; Owner: -
--

