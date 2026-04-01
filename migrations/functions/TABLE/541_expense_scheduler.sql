CREATE TABLE public.expense_scheduler (
    id bigint NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    expense_category_id bigint,
    expense_category_name_en text,
    expense_category_name_ar text,
    requisition_id bigint,
    requisition_number text,
    co_user_id uuid,
    co_user_name text,
    bill_type text NOT NULL,
    bill_number text,
    bill_date date,
    payment_method text,
    due_date date,
    credit_period integer,
    amount numeric NOT NULL,
    bill_file_url text,
    description text,
    notes text,
    is_paid boolean DEFAULT false,
    paid_date timestamp with time zone,
    status text DEFAULT 'pending'::text,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    bank_name text,
    iban text,
    payment_reference character varying(255),
    schedule_type text DEFAULT 'single_bill'::text,
    recurring_type text,
    recurring_metadata jsonb,
    approver_id uuid,
    approver_name text,
    vendor_id integer,
    vendor_name text,
    CONSTRAINT check_approver_for_recurring CHECK (((schedule_type <> 'recurring'::text) OR ((schedule_type = 'recurring'::text) AND (approver_id IS NOT NULL) AND (approver_name IS NOT NULL)))),
    CONSTRAINT check_co_user_for_non_recurring CHECK (((schedule_type = 'recurring'::text) OR (schedule_type = 'expense_requisition'::text) OR (schedule_type = 'closed_requisition_bill'::text) OR ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text])) AND (co_user_id IS NOT NULL) AND (co_user_name IS NOT NULL)))),
    CONSTRAINT check_recurring_type_values CHECK ((((schedule_type <> 'recurring'::text) AND (recurring_type IS NULL)) OR ((schedule_type = 'recurring'::text) AND (recurring_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly_date'::text, 'monthly_day'::text, 'yearly'::text, 'half_yearly'::text, 'quarterly'::text, 'custom'::text]))))),
    CONSTRAINT check_schedule_type_values CHECK ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text, 'recurring'::text, 'expense_requisition'::text, 'closed_requisition_bill'::text])))
);


--
-- Name: TABLE expense_scheduler; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.expense_scheduler IS 'Unified table for all scheduled expenses including bills from closed requisitions. 
Bills from closed requisitions have schedule_type = closed_requisition_bill and is_paid = true.';


--
-- Name: COLUMN expense_scheduler.expense_category_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.expense_category_id IS 'Can be NULL for requisitions created without categories - category will be assigned when closing the request with bills';


--
-- Name: COLUMN expense_scheduler.due_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.due_date IS 'Payment due date - calculated based on bill_date or created_at plus credit_period';


--
-- Name: COLUMN expense_scheduler.payment_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.payment_reference IS 'Payment reference number or transaction ID for tracking purposes';


--
-- Name: COLUMN expense_scheduler.schedule_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.schedule_type IS 'Types: single_bill, multiple_bill, recurring, expense_requisition, closed_requisition_bill';


--
-- Name: COLUMN expense_scheduler.recurring_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.recurring_type IS 'Type of recurring schedule: daily, weekly, monthly_date, monthly_day, yearly, half_yearly, quarterly, custom. Only applies when schedule_type is recurring';


--
-- Name: COLUMN expense_scheduler.recurring_metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.recurring_metadata IS 'JSON metadata for recurring schedule details (until_date, weekday, month_position, etc.)';


--
-- Name: COLUMN expense_scheduler.approver_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.approver_id IS 'User ID of the approver for recurring schedules. Required for recurring schedules.';


--
-- Name: COLUMN expense_scheduler.approver_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.approver_name IS 'Name of the approver for recurring schedules. Required for recurring schedules.';


--
-- Name: COLUMN expense_scheduler.vendor_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.vendor_id IS 'Vendor ERP ID when schedule is for a vendor expense';


--
-- Name: COLUMN expense_scheduler.vendor_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_scheduler.vendor_name IS 'Vendor name when schedule is for a vendor expense';


--
-- Name: CONSTRAINT check_co_user_for_non_recurring ON expense_scheduler; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT check_co_user_for_non_recurring ON public.expense_scheduler IS 'Ensures CO user is required for single_bill and multiple_bill, but not for recurring, expense_requisition, or closed_requisition_bill schedule types';


--
-- Name: CONSTRAINT check_schedule_type_values ON expense_scheduler; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT check_schedule_type_values ON public.expense_scheduler IS 'Allowed schedule types: single_bill, multiple_bill, recurring, expense_requisition, closed_requisition_bill';


--
-- Name: expense_scheduler_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

