CREATE TABLE public.vendors (
    erp_vendor_id integer NOT NULL,
    vendor_name text NOT NULL,
    salesman_name text,
    salesman_contact text,
    supervisor_name text,
    supervisor_contact text,
    vendor_contact_number text,
    payment_method text,
    credit_period integer,
    bank_name text,
    iban text,
    status text DEFAULT 'Active'::text,
    last_visit timestamp without time zone,
    categories text[],
    delivery_modes text[],
    place text,
    location_link text,
    return_expired_products text,
    return_expired_products_note text,
    return_near_expiry_products text,
    return_near_expiry_products_note text,
    return_over_stock text,
    return_over_stock_note text,
    return_damage_products text,
    return_damage_products_note text,
    no_return boolean DEFAULT false,
    no_return_note text,
    vat_applicable text DEFAULT 'VAT Applicable'::text,
    vat_number text,
    no_vat_note text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    branch_id bigint NOT NULL,
    payment_priority text DEFAULT 'Normal'::text,
    CONSTRAINT vendors_payment_priority_check CHECK ((payment_priority = ANY (ARRAY['Most'::text, 'Medium'::text, 'Normal'::text, 'Low'::text])))
);


--
-- Name: TABLE vendors; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.vendors IS 'Vendor management table with support for multiple payment methods, return policies, and VAT information';


--
-- Name: COLUMN vendors.payment_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.payment_method IS 'Comma-separated list of payment methods: Cash on Delivery, Bank on Delivery, Cash Credit, Bank Credit';


--
-- Name: COLUMN vendors.credit_period; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.credit_period IS 'Credit period in days for credit-based payment methods';


--
-- Name: COLUMN vendors.bank_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.bank_name IS 'Bank name for bank-related payment methods';


--
-- Name: COLUMN vendors.iban; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.iban IS 'International Bank Account Number for bank transfers';


--
-- Name: COLUMN vendors.no_return; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.no_return IS 'When TRUE, vendor does not accept any returns regardless of other return policy settings';


--
-- Name: COLUMN vendors.vat_applicable; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.vat_applicable IS 'VAT applicability status for the vendor';


--
-- Name: COLUMN vendors.vat_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.vat_number IS 'VAT registration number when VAT is applicable';


--
-- Name: COLUMN vendors.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.branch_id IS 'Branch ID that this vendor belongs to - makes vendor management branch-wise';


--
-- Name: COLUMN vendors.payment_priority; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.vendors.payment_priority IS 'Payment priority level: Most, Medium, Normal (default), Low';


--
-- Name: receiving_records_pr_excel_status; Type: VIEW; Schema: public; Owner: -
--

