CREATE TABLE public.approval_permissions (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    can_approve_requisitions boolean DEFAULT false NOT NULL,
    requisition_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_single_bill boolean DEFAULT false NOT NULL,
    single_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_multiple_bill boolean DEFAULT false NOT NULL,
    multiple_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_recurring_bill boolean DEFAULT false NOT NULL,
    recurring_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_vendor_payments boolean DEFAULT false NOT NULL,
    vendor_payment_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_leave_requests boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    can_approve_purchase_vouchers boolean DEFAULT false NOT NULL,
    can_add_missing_punches boolean DEFAULT false NOT NULL,
    can_receive_customer_incidents boolean DEFAULT false NOT NULL,
    can_receive_employee_incidents boolean DEFAULT false NOT NULL,
    can_receive_maintenance_incidents boolean DEFAULT false NOT NULL,
    can_receive_vendor_incidents boolean DEFAULT false NOT NULL,
    can_receive_vehicle_incidents boolean DEFAULT false NOT NULL,
    can_receive_government_incidents boolean DEFAULT false NOT NULL,
    can_receive_other_incidents boolean DEFAULT false NOT NULL,
    can_receive_finance_incidents boolean DEFAULT false NOT NULL,
    can_receive_pos_incidents boolean DEFAULT false NOT NULL,
    CONSTRAINT approval_permissions_multiple_bill_limit_check CHECK ((multiple_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_recurring_bill_limit_check CHECK ((recurring_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_requisition_limit_check CHECK ((requisition_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_single_bill_limit_check CHECK ((single_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_vendor_payment_limit_check CHECK ((vendor_payment_amount_limit >= (0)::numeric))
);


--
-- Name: TABLE approval_permissions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.approval_permissions IS 'Stores granular approval permissions for different types of requests (requisitions, schedules, vendor payments, etc.)';


--
-- Name: COLUMN approval_permissions.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.user_id IS 'Reference to the user who has these approval permissions';


--
-- Name: COLUMN approval_permissions.can_approve_requisitions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_requisitions IS 'Whether user can approve expense requisitions';


--
-- Name: COLUMN approval_permissions.requisition_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.requisition_amount_limit IS 'Maximum amount user can approve for requisitions (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_single_bill; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_single_bill IS 'Whether user can approve single bill payment schedules';


--
-- Name: COLUMN approval_permissions.single_bill_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.single_bill_amount_limit IS 'Maximum amount user can approve for single bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_multiple_bill; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_multiple_bill IS 'Whether user can approve multiple bill payment schedules';


--
-- Name: COLUMN approval_permissions.multiple_bill_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.multiple_bill_amount_limit IS 'Maximum amount user can approve for multiple bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_recurring_bill; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_recurring_bill IS 'Whether user can approve recurring bill payment schedules';


--
-- Name: COLUMN approval_permissions.recurring_bill_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.recurring_bill_amount_limit IS 'Maximum amount user can approve for recurring bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_vendor_payments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_approve_vendor_payments IS 'Whether user can approve vendor payments';


--
-- Name: COLUMN approval_permissions.vendor_payment_amount_limit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.vendor_payment_amount_limit IS 'Maximum amount user can approve for vendor payments (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.is_active IS 'Whether these permissions are currently active';


--
-- Name: COLUMN approval_permissions.can_receive_customer_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_customer_incidents IS 'Permission to receive and review customer-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_employee_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_employee_incidents IS 'Permission to receive and review employee-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_maintenance_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_maintenance_incidents IS 'Permission to receive and review maintenance-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_vendor_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_vendor_incidents IS 'Permission to receive and review vendor-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_vehicle_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_vehicle_incidents IS 'Permission to receive and review vehicle-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_government_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_government_incidents IS 'Permission to receive and review government-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_other_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_other_incidents IS 'Permission to receive and review other types of incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_finance_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_finance_incidents IS 'Permission to receive and review finance department incident reports (IN8)';


--
-- Name: COLUMN approval_permissions.can_receive_pos_incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.approval_permissions.can_receive_pos_incidents IS 'Permission to receive and review customer/POS incident reports (IN9)';


--
-- Name: approval_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

