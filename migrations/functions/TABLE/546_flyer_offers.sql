CREATE TABLE public.flyer_offers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id text DEFAULT (gen_random_uuid())::text NOT NULL,
    template_name text NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    offer_name text,
    offer_name_id text,
    CONSTRAINT flyer_offers_dates_check CHECK ((end_date >= start_date))
);


--
-- Name: TABLE flyer_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.flyer_offers IS 'Stores flyer offer campaigns and templates';


--
-- Name: COLUMN flyer_offers.template_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.template_id IS 'Unique template identifier for the offer';


--
-- Name: COLUMN flyer_offers.template_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.template_name IS 'Display name for the offer template';


--
-- Name: COLUMN flyer_offers.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.is_active IS 'Whether this offer is currently active';


--
-- Name: COLUMN flyer_offers.offer_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.offer_name IS 'Optional custom name for the offer, in addition to the template name';


--
-- Name: COLUMN flyer_offers.offer_name_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flyer_offers.offer_name_id IS 'Reference to predefined offer name from offer_names table';


--
-- Name: CONSTRAINT flyer_offers_dates_check ON flyer_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT flyer_offers_dates_check ON public.flyer_offers IS 'Ensures end date is not before start date';


--
-- Name: flyer_templates; Type: TABLE; Schema: public; Owner: -
--

