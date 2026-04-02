CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_number character varying(50) NOT NULL,
    customer_id uuid NOT NULL,
    customer_name character varying(255) NOT NULL,
    customer_phone character varying(20) NOT NULL,
    customer_whatsapp character varying(20),
    branch_id bigint NOT NULL,
    selected_location jsonb,
    order_status character varying(50) DEFAULT 'new'::character varying NOT NULL,
    fulfillment_method character varying(20) DEFAULT 'delivery'::character varying NOT NULL,
    subtotal_amount numeric(10,2) DEFAULT 0 NOT NULL,
    delivery_fee numeric(10,2) DEFAULT 0 NOT NULL,
    discount_amount numeric(10,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0 NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    payment_method character varying(20) NOT NULL,
    payment_status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    payment_reference character varying(100),
    total_items integer DEFAULT 0 NOT NULL,
    total_quantity integer DEFAULT 0 NOT NULL,
    picker_id uuid,
    picker_assigned_at timestamp with time zone,
    delivery_person_id uuid,
    delivery_assigned_at timestamp with time zone,
    accepted_at timestamp with time zone,
    ready_at timestamp with time zone,
    delivered_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    cancelled_by uuid,
    cancellation_reason text,
    customer_notes text,
    admin_notes text,
    estimated_pickup_time timestamp with time zone,
    estimated_delivery_time timestamp with time zone,
    actual_pickup_time timestamp with time zone,
    actual_delivery_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    picked_up_at timestamp with time zone
);

ALTER TABLE ONLY public.orders REPLICA IDENTITY FULL;


--
-- Name: TABLE orders; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.orders IS 'Customer orders from mobile app';


--
-- Name: COLUMN orders.order_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.order_number IS 'Unique order number displayed to customer (e.g., ORD-20251120-0001)';


--
-- Name: COLUMN orders.selected_location; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.selected_location IS 'Customer delivery location snapshot from their saved locations';


--
-- Name: COLUMN orders.order_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.order_status IS 'Order workflow status: new, accepted, in_picking, ready, out_for_delivery, delivered, cancelled';


--
-- Name: COLUMN orders.fulfillment_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.fulfillment_method IS 'How customer will receive order: delivery or pickup';


--
-- Name: COLUMN orders.payment_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.payment_method IS 'Payment method: cash, card, online';


--
-- Name: COLUMN orders.payment_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.payment_status IS 'Payment tracking: pending, paid, refunded';


--
-- Name: overtime_registrations; Type: TABLE; Schema: public; Owner: -
--

