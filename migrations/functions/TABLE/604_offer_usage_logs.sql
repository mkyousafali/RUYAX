CREATE TABLE public.offer_usage_logs (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    customer_id uuid,
    order_id uuid,
    discount_applied numeric(10,2) NOT NULL,
    original_amount numeric(10,2) NOT NULL,
    final_amount numeric(10,2) NOT NULL,
    cart_items jsonb,
    used_at timestamp with time zone DEFAULT now(),
    session_id character varying(255) DEFAULT NULL::character varying,
    device_type character varying(50) DEFAULT NULL::character varying
);


--
-- Name: TABLE offer_usage_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.offer_usage_logs IS 'Comprehensive logging of all offer applications';


--
-- Name: COLUMN offer_usage_logs.order_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.offer_usage_logs.order_id IS 'Links offer usage to the order where it was applied (NULL for non-order usage)';


--
-- Name: offer_usage_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

