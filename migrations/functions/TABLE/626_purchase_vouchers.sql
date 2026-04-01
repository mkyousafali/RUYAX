CREATE TABLE public.purchase_vouchers (
    id character varying NOT NULL,
    book_number character varying NOT NULL,
    serial_start integer NOT NULL,
    serial_end integer NOT NULL,
    voucher_count integer NOT NULL,
    per_voucher_value numeric NOT NULL,
    total_value numeric NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: purchase_vouchers_book_seq; Type: SEQUENCE; Schema: public; Owner: -
--

