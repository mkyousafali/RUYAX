CREATE TABLE public.deleted_bundle_offers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    original_offer_id integer NOT NULL,
    offer_data jsonb NOT NULL,
    bundles_data jsonb NOT NULL,
    deleted_at timestamp with time zone DEFAULT now(),
    deleted_by uuid,
    deletion_reason text
);


--
-- Name: TABLE deleted_bundle_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.deleted_bundle_offers IS 'Archive table for deleted bundle offers - allows recovery and audit trail';


--
-- Name: COLUMN deleted_bundle_offers.original_offer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.original_offer_id IS 'The original offer ID from offers table (INTEGER)';


--
-- Name: COLUMN deleted_bundle_offers.offer_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.offer_data IS 'Complete offer data as JSON';


--
-- Name: COLUMN deleted_bundle_offers.bundles_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.bundles_data IS 'Array of bundle data as JSON';


--
-- Name: COLUMN deleted_bundle_offers.deleted_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.deleted_by IS 'User who deleted the offer';


--
-- Name: COLUMN deleted_bundle_offers.deletion_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.deleted_bundle_offers.deletion_reason IS 'Optional reason for deletion';


--
-- Name: delivery_fee_tiers; Type: TABLE; Schema: public; Owner: -
--

