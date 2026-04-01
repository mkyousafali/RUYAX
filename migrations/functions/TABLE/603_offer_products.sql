CREATE TABLE public.offer_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_id integer NOT NULL,
    product_id character varying(50) NOT NULL,
    offer_qty integer DEFAULT 1 NOT NULL,
    offer_percentage numeric(5,2),
    offer_price numeric(10,2),
    max_uses integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_part_of_variation_group boolean DEFAULT false NOT NULL,
    variation_group_id uuid,
    variation_parent_barcode text,
    added_by uuid,
    added_at timestamp with time zone DEFAULT now(),
    CONSTRAINT at_least_one_discount CHECK (((offer_percentage IS NOT NULL) OR (offer_price IS NOT NULL))),
    CONSTRAINT valid_offer_price CHECK (((offer_price IS NULL) OR (offer_price >= (0)::numeric))),
    CONSTRAINT valid_offer_qty CHECK ((offer_qty > 0)),
    CONSTRAINT valid_percentage CHECK (((offer_percentage IS NULL) OR ((offer_percentage >= (0)::numeric) AND (offer_percentage <= (100)::numeric))))
);


--
-- Name: TABLE offer_products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offer_products IS 'Stores individual products in product discount offers with percentage or special price';


--
-- Name: COLUMN offer_products.offer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.offer_id IS 'Reference to parent offer';


--
-- Name: COLUMN offer_products.product_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.product_id IS 'Reference to product';


--
-- Name: COLUMN offer_products.offer_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.offer_qty IS 'Quantity required for offer (e.g., 2 for "2 pieces for 39.95")';


--
-- Name: COLUMN offer_products.offer_percentage; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.offer_percentage IS 'Percentage discount (e.g., 20.00 for 20% off) - NULL for special price offers';


--
-- Name: COLUMN offer_products.offer_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.offer_price IS 'Special price for offer quantity (e.g., 39.95 for 2 pieces) - NULL for percentage offers';


--
-- Name: COLUMN offer_products.max_uses; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.max_uses IS 'Maximum uses per product (NULL = unlimited)';


--
-- Name: COLUMN offer_products.is_part_of_variation_group; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.is_part_of_variation_group IS 'Flag indicating if this product belongs to a variation group within the offer';


--
-- Name: COLUMN offer_products.variation_group_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.variation_group_id IS 'UUID linking all variations in the same group within an offer';


--
-- Name: COLUMN offer_products.variation_parent_barcode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.variation_parent_barcode IS 'Quick reference to the parent product barcode';


--
-- Name: COLUMN offer_products.added_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.added_by IS 'User who added this variation to the offer';


--
-- Name: COLUMN offer_products.added_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_products.added_at IS 'Timestamp when this variation was added to the offer';


--
-- Name: CONSTRAINT at_least_one_discount ON offer_products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT at_least_one_discount ON public.offer_products IS 'Ensures at least one discount field is set. Both can be set for percentage offers (stores calculated price).';


--
-- Name: offer_usage_logs; Type: TABLE; Schema: public; Owner: -
--

