CREATE TABLE public.box_operations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    box_number smallint NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    denomination_record_id uuid NOT NULL,
    counts_before jsonb NOT NULL,
    counts_after jsonb NOT NULL,
    total_before numeric(15,2) NOT NULL,
    total_after numeric(15,2) NOT NULL,
    difference numeric(15,2) NOT NULL,
    is_matched boolean NOT NULL,
    status character varying(20) DEFAULT 'in_use'::character varying NOT NULL,
    start_time timestamp with time zone DEFAULT now() NOT NULL,
    end_time timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    closing_details jsonb,
    supervisor_verified_at timestamp with time zone,
    supervisor_id uuid,
    closing_start_date date,
    closing_start_time time without time zone,
    closing_end_date date,
    closing_end_time time without time zone,
    recharge_opening_balance numeric(15,2),
    recharge_close_balance numeric(15,2),
    recharge_sales numeric(15,2),
    bank_mada numeric(15,2),
    bank_visa numeric(15,2),
    bank_mastercard numeric(15,2),
    bank_google_pay numeric(15,2),
    bank_other numeric(15,2),
    bank_total numeric(15,2),
    system_cash_sales numeric(15,2),
    system_card_sales numeric(15,2),
    system_return numeric(15,2),
    difference_cash_sales numeric(15,2),
    difference_card_sales numeric(15,2),
    total_difference numeric(15,2),
    closing_total numeric(15,2),
    closing_cash_500 integer,
    closing_cash_200 integer,
    closing_cash_100 integer,
    closing_cash_50 integer,
    closing_cash_20 integer,
    closing_cash_10 integer,
    closing_cash_5 integer,
    closing_cash_2 integer,
    closing_cash_1 integer,
    closing_cash_050 integer,
    closing_cash_025 integer,
    closing_coins integer,
    total_cash_sales numeric(15,2),
    cash_sales_per_count numeric(15,2),
    vouchers_total numeric(15,2),
    total_erp_cash_sales numeric(15,2),
    total_erp_sales numeric(15,2),
    suspense_paid jsonb,
    suspense_received jsonb,
    pos_before_url text,
    completed_by_user_id uuid,
    completed_by_name text,
    complete_details jsonb,
    CONSTRAINT box_operations_box_number_check CHECK (((box_number >= 1) AND (box_number <= 12))),
    CONSTRAINT box_operations_status_check CHECK (((status)::text = ANY ((ARRAY['in_use'::character varying, 'pending_close'::character varying, 'completed'::character varying, 'cancelled'::character varying, 'draft'::character varying])::text[])))
);


--
-- Name: TABLE box_operations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.box_operations IS 'Tracks POS cash box operations and counter check sessions';


--
-- Name: COLUMN box_operations.difference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.difference IS 'Difference between before and after totals (before - after)';


--
-- Name: COLUMN box_operations.is_matched; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.is_matched IS 'True if counter check matched, false if there was a difference';


--
-- Name: COLUMN box_operations.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.status IS 'Operation status: in_use (active), pending_close (waiting for final close), completed, or cancelled';


--
-- Name: COLUMN box_operations.closing_details; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.closing_details IS 'JSON containing all closing form data';


--
-- Name: COLUMN box_operations.supervisor_verified_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.supervisor_verified_at IS 'Timestamp when supervisor code was verified';


--
-- Name: COLUMN box_operations.supervisor_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.supervisor_id IS 'ID of supervisor who verified the closing';


--
-- Name: COLUMN box_operations.difference_cash_sales; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.difference_cash_sales IS 'Difference between total cash sales and system cash sales';


--
-- Name: COLUMN box_operations.difference_card_sales; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.difference_card_sales IS 'Difference between bank total and system card sales';


--
-- Name: COLUMN box_operations.total_difference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.total_difference IS 'Total of cash and card differences';


--
-- Name: COLUMN box_operations.pos_before_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.box_operations.pos_before_url IS 'URL to the stored POS before closing image in pos-before storage bucket';


--
-- Name: branch_default_delivery_receivers; Type: TABLE; Schema: public; Owner: -
--

