CREATE TABLE public.branches (
    id bigint NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    location_en character varying(500) NOT NULL,
    location_ar character varying(500) NOT NULL,
    is_active boolean DEFAULT true,
    is_main_branch boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by bigint,
    updated_by bigint,
    vat_number character varying(50),
    delivery_service_enabled boolean DEFAULT true NOT NULL,
    pickup_service_enabled boolean DEFAULT true NOT NULL,
    minimum_order_amount numeric(10,2) DEFAULT 15.00,
    is_24_hours boolean DEFAULT true,
    operating_start_time time without time zone,
    operating_end_time time without time zone,
    delivery_message_ar text,
    delivery_message_en text,
    delivery_is_24_hours boolean DEFAULT true,
    delivery_start_time time without time zone,
    delivery_end_time time without time zone,
    pickup_is_24_hours boolean DEFAULT true,
    pickup_start_time time without time zone,
    pickup_end_time time without time zone,
    location_url text,
    latitude double precision,
    longitude double precision,
    CONSTRAINT check_vat_number_not_empty CHECK (((vat_number IS NULL) OR (length(TRIM(BOTH FROM vat_number)) > 0)))
);


--
-- Name: COLUMN branches.vat_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.vat_number IS 'VAT registration number for the branch';


--
-- Name: COLUMN branches.delivery_service_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_service_enabled IS 'Enable/disable delivery service for this branch';


--
-- Name: COLUMN branches.pickup_service_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.pickup_service_enabled IS 'Enable/disable store pickup service for this branch';


--
-- Name: COLUMN branches.minimum_order_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.minimum_order_amount IS 'Minimum order amount for this branch (SAR)';


--
-- Name: COLUMN branches.is_24_hours; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.is_24_hours IS 'Whether delivery service is available 24/7 for this branch';


--
-- Name: COLUMN branches.operating_start_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.operating_start_time IS 'Delivery service start time (if not 24/7)';


--
-- Name: COLUMN branches.operating_end_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.operating_end_time IS 'Delivery service end time (if not 24/7)';


--
-- Name: COLUMN branches.delivery_message_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_message_ar IS 'Custom delivery message in Arabic for this branch';


--
-- Name: COLUMN branches.delivery_message_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_message_en IS 'Custom delivery message in English for this branch';


--
-- Name: COLUMN branches.delivery_is_24_hours; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_is_24_hours IS 'Whether delivery service is available 24/7';


--
-- Name: COLUMN branches.delivery_start_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_start_time IS 'Delivery service start time';


--
-- Name: COLUMN branches.delivery_end_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.delivery_end_time IS 'Delivery service end time';


--
-- Name: COLUMN branches.pickup_is_24_hours; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.pickup_is_24_hours IS 'Whether pickup service is available 24/7';


--
-- Name: COLUMN branches.pickup_start_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.pickup_start_time IS 'Pickup service start time';


--
-- Name: COLUMN branches.pickup_end_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.pickup_end_time IS 'Pickup service end time';


--
-- Name: COLUMN branches.location_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.location_url IS 'Google Maps URL for the branch location';


--
-- Name: COLUMN branches.latitude; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.latitude IS 'Branch latitude for distance calculation';


--
-- Name: COLUMN branches.longitude; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.branches.longitude IS 'Branch longitude for distance calculation';


--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

