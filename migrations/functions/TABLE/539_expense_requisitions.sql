CREATE TABLE public.expense_requisitions (
    id bigint NOT NULL,
    requisition_number text NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    approver_id uuid,
    approver_name text,
    expense_category_id bigint,
    expense_category_name_en text,
    expense_category_name_ar text,
    requester_id text NOT NULL,
    requester_name text NOT NULL,
    requester_contact text NOT NULL,
    vat_applicable boolean DEFAULT false,
    amount numeric(15,2) NOT NULL,
    payment_category text NOT NULL,
    description text,
    status text DEFAULT 'pending'::text,
    image_url text,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    credit_period integer,
    bank_name text,
    iban text,
    used_amount numeric DEFAULT 0,
    remaining_balance numeric DEFAULT 0,
    requester_ref_id uuid,
    is_active boolean DEFAULT true NOT NULL,
    due_date date,
    internal_user_id uuid,
    request_type text DEFAULT 'external'::text,
    vendor_id integer,
    vendor_name text,
    CONSTRAINT expense_requisitions_request_type_check CHECK ((request_type = ANY (ARRAY['external'::text, 'internal'::text, 'vendor'::text])))
);


--
-- Name: TABLE expense_requisitions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.expense_requisitions IS 'Expense requisitions with approval workflow and image storage';


--
-- Name: COLUMN expense_requisitions.requisition_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.requisition_number IS 'Unique requisition number in format REQ-YYYYMMDD-XXXX';


--
-- Name: COLUMN expense_requisitions.expense_category_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.expense_category_id IS 'Expense category - can be null initially and assigned when closing the request';


--
-- Name: COLUMN expense_requisitions.payment_category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.payment_category IS 'Payment method: advance_cash, advance_bank, advance_cash_credit, advance_bank_credit, cash, bank, cash_credit, bank_credit, stock_purchase_advance_cash, stock_purchase_advance_bank, stock_purchase_cash, stock_purchase_bank';


--
-- Name: COLUMN expense_requisitions.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.status IS 'Requisition status: pending, approved, rejected, completed';


--
-- Name: COLUMN expense_requisitions.credit_period; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.credit_period IS 'Credit period in days (required for credit payment methods: advance_cash_credit, advance_bank_credit, cash_credit, bank_credit)';


--
-- Name: COLUMN expense_requisitions.bank_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.bank_name IS 'Bank name (optional for all bank payment methods)';


--
-- Name: COLUMN expense_requisitions.iban; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.iban IS 'IBAN number (optional for all bank payment methods)';


--
-- Name: COLUMN expense_requisitions.used_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.used_amount IS 'Total amount used from this requisition across all scheduled bills';


--
-- Name: COLUMN expense_requisitions.remaining_balance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.remaining_balance IS 'Remaining balance available for new bills (amount - used_amount)';


--
-- Name: COLUMN expense_requisitions.requester_ref_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.requester_ref_id IS 'Reference to the requesters table for normalized requester data';


--
-- Name: COLUMN expense_requisitions.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.is_active IS 'Indicates if the requisition is active. Deactivated requisitions are excluded from filters and scheduling.';


--
-- Name: COLUMN expense_requisitions.due_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.due_date IS 'Automatically calculated due date based on payment method and credit period';


--
-- Name: COLUMN expense_requisitions.vendor_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.vendor_id IS 'Vendor ERP ID when request type is vendor';


--
-- Name: COLUMN expense_requisitions.vendor_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_requisitions.vendor_name IS 'Vendor name when request type is vendor';


--
-- Name: expense_requisitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

