CREATE TABLE public.bogo_offer_rules (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    buy_product_id character varying(50) NOT NULL,
    buy_quantity integer NOT NULL,
    get_product_id character varying(50) NOT NULL,
    get_quantity integer NOT NULL,
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bogo_offer_rules_buy_quantity_check CHECK ((buy_quantity > 0)),
    CONSTRAINT bogo_offer_rules_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('free'::character varying)::text, ('percentage'::character varying)::text, ('amount'::character varying)::text]))),
    CONSTRAINT bogo_offer_rules_discount_value_check CHECK ((discount_value >= (0)::numeric)),
    CONSTRAINT bogo_offer_rules_get_quantity_check CHECK ((get_quantity > 0)),
    CONSTRAINT valid_discount_value CHECK ((((discount_type)::text = 'free'::text) OR (((discount_type)::text = 'percentage'::text) AND (discount_value > (0)::numeric) AND (discount_value <= (100)::numeric)) OR (((discount_type)::text = 'amount'::text) AND (discount_value > (0)::numeric))))
);


--
-- Name: TABLE bogo_offer_rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.bogo_offer_rules IS 'Stores Buy X Get Y (BOGO) offer rules - each rule defines a condition where buying X product(s) qualifies for discount on Y product(s)';


--
-- Name: COLUMN bogo_offer_rules.buy_product_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.buy_product_id IS 'Product customer must buy (X)';


--
-- Name: COLUMN bogo_offer_rules.buy_quantity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.buy_quantity IS 'Quantity of buy product required';


--
-- Name: COLUMN bogo_offer_rules.get_product_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.get_product_id IS 'Product customer gets discount on (Y)';


--
-- Name: COLUMN bogo_offer_rules.get_quantity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.get_quantity IS 'Quantity of get product that receives discount';


--
-- Name: COLUMN bogo_offer_rules.discount_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.discount_type IS 'Type of discount: free (100% off), percentage (% off), or amount (fixed amount off)';


--
-- Name: COLUMN bogo_offer_rules.discount_value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bogo_offer_rules.discount_value IS 'Discount value - 0 for free, 1-100 for percentage, or amount for fixed discount';


--
-- Name: bogo_offer_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

