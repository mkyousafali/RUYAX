CREATE TABLE public.purchase_voucher_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_voucher_id character varying NOT NULL,
    serial_number integer NOT NULL,
    value numeric NOT NULL,
    status character varying DEFAULT 'stocked'::character varying,
    issued_date timestamp with time zone,
    closed_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    stock integer DEFAULT 1,
    issue_type character varying DEFAULT 'not issued'::character varying,
    stock_location bigint,
    stock_person uuid,
    issued_to uuid,
    issued_by uuid,
    receipt_url text,
    issue_remarks text,
    close_remarks text,
    close_bill_number character varying,
    approval_status character varying,
    approver_id uuid,
    pending_stock_location bigint,
    pending_stock_person uuid
);


--
-- Name: purchase_vouchers; Type: TABLE; Schema: public; Owner: -
--

