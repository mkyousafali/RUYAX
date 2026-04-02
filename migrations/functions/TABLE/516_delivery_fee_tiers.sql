CREATE TABLE public.delivery_fee_tiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    min_order_amount numeric(10,2) NOT NULL,
    max_order_amount numeric(10,2),
    delivery_fee numeric(10,2) NOT NULL,
    tier_order integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description_en text,
    description_ar text,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    branch_id bigint,
    CONSTRAINT check_delivery_fee_positive CHECK ((delivery_fee >= (0)::numeric)),
    CONSTRAINT check_min_amount_positive CHECK ((min_order_amount >= (0)::numeric)),
    CONSTRAINT check_min_max_order CHECK (((max_order_amount IS NULL) OR (max_order_amount > min_order_amount)))
);


--
-- Name: TABLE delivery_fee_tiers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.delivery_fee_tiers IS 'Multi-tier delivery fee system - Migration 20251107000000';


--
-- Name: COLUMN delivery_fee_tiers.min_order_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.min_order_amount IS 'Minimum order amount for this tier (SAR)';


--
-- Name: COLUMN delivery_fee_tiers.max_order_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.max_order_amount IS 'Maximum order amount for this tier, NULL for unlimited';


--
-- Name: COLUMN delivery_fee_tiers.delivery_fee; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.delivery_fee IS 'Delivery fee charged for orders in this tier (SAR)';


--
-- Name: COLUMN delivery_fee_tiers.tier_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.tier_order IS 'Display order for admin interface';


--
-- Name: COLUMN delivery_fee_tiers.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.delivery_fee_tiers.branch_id IS 'When NULL, tier is global. When set, tier applies only to this branch.';


--
-- Name: delivery_service_settings; Type: TABLE; Schema: public; Owner: -
--

