CREATE TABLE public.denomination_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    record_type character varying(30) NOT NULL,
    box_number smallint,
    counts jsonb DEFAULT '{}'::jsonb NOT NULL,
    erp_balance numeric(15,2),
    grand_total numeric(15,2) DEFAULT 0 NOT NULL,
    difference numeric(15,2),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    petty_cash_operation jsonb,
    CONSTRAINT denomination_records_box_number_check CHECK (((box_number IS NULL) OR ((box_number >= 1) AND (box_number <= 12)))),
    CONSTRAINT denomination_records_record_type_check CHECK (((record_type)::text = ANY (ARRAY['main'::text, 'advance_box'::text, 'collection_box'::text, 'paid'::text, 'received'::text, 'petty_cash_box'::text])))
);


--
-- Name: TABLE denomination_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.denomination_records IS 'Stores denomination count records for main, boxes, and other sections';


--
-- Name: COLUMN denomination_records.record_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_records.record_type IS 'Type of record: main, advance_box, collection_box, paid, received';


--
-- Name: COLUMN denomination_records.box_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_records.box_number IS 'Box or card number (1-12 for advance boxes, 1-6 for collection boxes, 1-6 for paid/received, null for main)';


--
-- Name: COLUMN denomination_records.counts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_records.counts IS 'JSONB storing denomination counts: {"d500": 10, "d200": 5, ...}';


--
-- Name: COLUMN denomination_records.petty_cash_operation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.denomination_records.petty_cash_operation IS 'JSONB column storing petty cash operation details: {transferred_from_box_number, transferred_from_user_id, closing_details}';


--
-- Name: CONSTRAINT denomination_records_record_type_check ON denomination_records; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT denomination_records_record_type_check ON public.denomination_records IS 'Allowed record types: main (main denomination), advance_box (advance manager boxes), collection_box (collection boxes), paid (paid records), received (received records), petty_cash_box (petty cash transfers)';


--
-- Name: denomination_transactions; Type: TABLE; Schema: public; Owner: -
--

