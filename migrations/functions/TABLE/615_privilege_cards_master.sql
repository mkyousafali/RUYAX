CREATE TABLE public.privilege_cards_master (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    card_number character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: processed_fingerprint_transactions; Type: TABLE; Schema: public; Owner: -
--

