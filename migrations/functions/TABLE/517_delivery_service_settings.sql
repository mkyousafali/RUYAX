CREATE TABLE public.delivery_service_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    minimum_order_amount numeric(10,2) DEFAULT 15.00 NOT NULL,
    is_24_hours boolean DEFAULT true NOT NULL,
    operating_start_time time without time zone,
    operating_end_time time without time zone,
    is_active boolean DEFAULT true NOT NULL,
    display_message_ar text DEFAULT '╪º┘ä╪¬┘ê╪╡┘è┘ä ┘à╪¬╪º╪¡ ╪╣┘ä┘ë ┘à╪»╪º╪▒ ╪º┘ä╪│╪º╪╣╪⌐ (24/7)'::text,
    display_message_en text DEFAULT 'Delivery available 24/7'::text,
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    customer_login_mask_enabled boolean DEFAULT true NOT NULL,
    CONSTRAINT delivery_settings_singleton CHECK ((id = '00000000-0000-0000-0000-000000000001'::uuid))
);

ALTER TABLE ONLY public.delivery_service_settings REPLICA IDENTITY FULL;


--
-- Name: TABLE delivery_service_settings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.delivery_service_settings IS 'Global delivery service configuration settings';


--
-- Name: COLUMN delivery_service_settings.minimum_order_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_service_settings.minimum_order_amount IS 'Minimum order amount to place any order (SAR)';


--
-- Name: denomination_audit_log; Type: TABLE; Schema: public; Owner: -
--

