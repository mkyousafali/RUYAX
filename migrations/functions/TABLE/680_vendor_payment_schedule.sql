CREATE TABLE public.vendor_payment_schedule (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    receiving_record_id uuid,
    bill_number character varying(255),
    vendor_id character varying(255),
    vendor_name character varying(255),
    branch_id integer,
    branch_name character varying(255),
    bill_date date,
    bill_amount numeric(15,2),
    final_bill_amount numeric(15,2),
    payment_method character varying(100),
    bank_name character varying(255),
    iban character varying(255),
    due_date date,
    credit_period integer,
    vat_number character varying(100),
    scheduled_date timestamp without time zone DEFAULT now(),
    paid_date timestamp without time zone,
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    original_due_date date,
    original_bill_amount numeric(15,2),
    original_final_amount numeric(15,2),
    is_paid boolean DEFAULT false,
    payment_reference character varying(255),
    task_id uuid,
    task_assignment_id uuid,
    receiver_user_id uuid,
    accountant_user_id uuid,
    verification_status text DEFAULT 'pending'::text,
    verified_by uuid,
    verified_date timestamp with time zone,
    transaction_date timestamp with time zone,
    original_bill_url text,
    created_by uuid,
    pr_excel_verified boolean DEFAULT false,
    pr_excel_verified_by uuid,
    pr_excel_verified_date timestamp with time zone,
    discount_amount numeric(15,2) DEFAULT 0,
    discount_notes text,
    grr_amount numeric(15,2) DEFAULT 0,
    grr_reference_number text,
    grr_notes text,
    pri_amount numeric(15,2) DEFAULT 0,
    pri_reference_number text,
    pri_notes text,
    last_adjustment_date timestamp with time zone,
    last_adjusted_by uuid,
    adjustment_history jsonb DEFAULT '[]'::jsonb,
    approval_status text DEFAULT 'pending'::text NOT NULL,
    approval_requested_by uuid,
    approval_requested_at timestamp with time zone,
    approved_by uuid,
    approved_at timestamp with time zone,
    approval_notes text,
    assigned_approver_id uuid,
    CONSTRAINT check_discount_amount_positive CHECK ((discount_amount >= (0)::numeric)),
    CONSTRAINT check_grr_amount_positive CHECK ((grr_amount >= (0)::numeric)),
    CONSTRAINT check_pri_amount_positive CHECK ((pri_amount >= (0)::numeric)),
    CONSTRAINT check_total_deductions_valid CHECK ((((COALESCE(discount_amount, (0)::numeric) + COALESCE(grr_amount, (0)::numeric)) + COALESCE(pri_amount, (0)::numeric)) <= COALESCE(original_final_amount, final_bill_amount, bill_amount))),
    CONSTRAINT vendor_payment_approval_status_check CHECK ((approval_status = ANY (ARRAY['pending'::text, 'sent_for_approval'::text, 'approved'::text, 'rejected'::text])))
);


--
-- Name: TABLE vendor_payment_schedule; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.vendor_payment_schedule IS 'Schedule and track vendor payments';


--
-- Name: COLUMN vendor_payment_schedule.due_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.due_date IS 'Current due date (can be rescheduled)';


--
-- Name: COLUMN vendor_payment_schedule.scheduled_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.scheduled_date IS 'When the payment was scheduled';


--
-- Name: COLUMN vendor_payment_schedule.paid_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.paid_date IS 'Timestamp when payment was marked as paid';


--
-- Name: COLUMN vendor_payment_schedule.original_due_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.original_due_date IS 'Original due date when first scheduled (never changes)';


--
-- Name: COLUMN vendor_payment_schedule.original_bill_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.original_bill_amount IS 'Original bill amount when first scheduled (never changes)';


--
-- Name: COLUMN vendor_payment_schedule.original_final_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.original_final_amount IS 'Original final amount when first scheduled (never changes)';


--
-- Name: COLUMN vendor_payment_schedule.is_paid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.is_paid IS 'Boolean flag: true=paid, false=not paid';


--
-- Name: COLUMN vendor_payment_schedule.payment_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.payment_reference IS 'Payment reference number (migrated from payment_transactions). Format: CP#XXXX or AUTO-COD-XXXXX';


--
-- Name: COLUMN vendor_payment_schedule.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.task_id IS 'Task created for accountant when payment is marked as paid';


--
-- Name: COLUMN vendor_payment_schedule.task_assignment_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.task_assignment_id IS 'Task assignment for the accountant';


--
-- Name: COLUMN vendor_payment_schedule.receiver_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.receiver_user_id IS 'User who received the goods (from receiving_records)';


--
-- Name: COLUMN vendor_payment_schedule.accountant_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.accountant_user_id IS 'Accountant assigned to process this payment';


--
-- Name: COLUMN vendor_payment_schedule.verification_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.verification_status IS 'Payment verification status: pending, verified, rejected';


--
-- Name: COLUMN vendor_payment_schedule.verified_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.verified_by IS 'User who verified the payment';


--
-- Name: COLUMN vendor_payment_schedule.verified_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.verified_date IS 'Date when payment was verified';


--
-- Name: COLUMN vendor_payment_schedule.transaction_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.transaction_date IS 'Actual transaction/payment date';


--
-- Name: COLUMN vendor_payment_schedule.original_bill_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.original_bill_url IS 'URL to the original bill/invoice document';


--
-- Name: COLUMN vendor_payment_schedule.discount_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.discount_amount IS 'Discount amount deducted from bill';


--
-- Name: COLUMN vendor_payment_schedule.discount_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.discount_notes IS 'Notes explaining the discount';


--
-- Name: COLUMN vendor_payment_schedule.grr_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_amount IS 'Goods Receipt Return amount deducted from bill';


--
-- Name: COLUMN vendor_payment_schedule.grr_reference_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_reference_number IS 'Reference number for GRR document';


--
-- Name: COLUMN vendor_payment_schedule.grr_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_notes IS 'Notes for GRR adjustment';


--
-- Name: COLUMN vendor_payment_schedule.pri_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_amount IS 'Purchase Return Invoice amount deducted from bill';


--
-- Name: COLUMN vendor_payment_schedule.pri_reference_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_reference_number IS 'Reference number for PRI document';


--
-- Name: COLUMN vendor_payment_schedule.pri_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_notes IS 'Notes for PRI adjustment';


--
-- Name: COLUMN vendor_payment_schedule.last_adjustment_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.last_adjustment_date IS 'Date of last adjustment';


--
-- Name: COLUMN vendor_payment_schedule.last_adjusted_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.last_adjusted_by IS 'User ID who made the last adjustment (stores auth.users.id without FK constraint)';


--
-- Name: COLUMN vendor_payment_schedule.adjustment_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.adjustment_history IS 'JSON array of all adjustment history';


--
-- Name: COLUMN vendor_payment_schedule.approval_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_status IS 'Approval workflow status: pending, sent_for_approval, approved, rejected';


--
-- Name: COLUMN vendor_payment_schedule.approval_requested_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_requested_by IS 'User who requested approval';


--
-- Name: COLUMN vendor_payment_schedule.approval_requested_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_requested_at IS 'Timestamp when approval was requested';


--
-- Name: COLUMN vendor_payment_schedule.approved_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.approved_by IS 'User who approved the payment';


--
-- Name: COLUMN vendor_payment_schedule.approved_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.approved_at IS 'Timestamp when payment was approved';


--
-- Name: COLUMN vendor_payment_schedule.approval_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_notes IS 'Optional notes about the approval decision';


--
-- Name: COLUMN vendor_payment_schedule.assigned_approver_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendor_payment_schedule.assigned_approver_id IS 'The specific user assigned to approve this vendor payment';


--
-- Name: view_offer; Type: TABLE; Schema: public; Owner: -
--

