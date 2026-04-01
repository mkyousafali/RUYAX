CREATE TABLE public.non_approved_payment_scheduler (
    id bigint NOT NULL,
    schedule_type text NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    expense_category_id bigint NOT NULL,
    expense_category_name_en text,
    expense_category_name_ar text,
    co_user_id uuid,
    co_user_name text,
    bill_type text,
    bill_number text,
    bill_date date,
    payment_method text,
    due_date date,
    credit_period integer,
    amount numeric NOT NULL,
    bill_file_url text,
    bank_name text,
    iban text,
    description text,
    notes text,
    recurring_type text,
    recurring_metadata jsonb,
    approver_id uuid NOT NULL,
    approver_name text NOT NULL,
    approval_status text DEFAULT 'pending'::text,
    approved_at timestamp with time zone,
    approved_by uuid,
    rejection_reason text,
    expense_scheduler_id bigint,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT check_non_approved_approval_status CHECK ((approval_status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))),
    CONSTRAINT check_non_approved_co_user_for_non_recurring CHECK (((schedule_type = 'recurring'::text) OR ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text])) AND (co_user_id IS NOT NULL) AND (co_user_name IS NOT NULL)))),
    CONSTRAINT check_non_approved_recurring_type CHECK (((recurring_type IS NULL) OR (recurring_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly_date'::text, 'monthly_day'::text, 'yearly'::text, 'half_yearly'::text, 'quarterly'::text, 'custom'::text])))),
    CONSTRAINT check_non_approved_schedule_type CHECK ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text, 'recurring'::text])))
);


--
-- Name: TABLE non_approved_payment_scheduler; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.non_approved_payment_scheduler IS 'Stores payment schedules that require approval before being posted to expense_scheduler';


--
-- Name: COLUMN non_approved_payment_scheduler.schedule_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.non_approved_payment_scheduler.schedule_type IS 'Type of schedule: single_bill, multiple_bill, or recurring';


--
-- Name: COLUMN non_approved_payment_scheduler.approval_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.non_approved_payment_scheduler.approval_status IS 'Approval status: pending, approved, rejected';


--
-- Name: COLUMN non_approved_payment_scheduler.expense_scheduler_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.non_approved_payment_scheduler.expense_scheduler_id IS 'Links to expense_scheduler after approval';


--
-- Name: non_approved_payment_scheduler_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

