CREATE TABLE public.product_request_bt (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    from_branch_id integer NOT NULL,
    to_branch_id integer NOT NULL,
    target_user_id uuid NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    document_url text
);


--
-- Name: product_request_po; Type: TABLE; Schema: public; Owner: -
--

