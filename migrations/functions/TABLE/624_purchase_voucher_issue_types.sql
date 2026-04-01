CREATE TABLE public.purchase_voucher_issue_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type_name character varying NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: purchase_voucher_items; Type: TABLE; Schema: public; Owner: -
--

