CREATE TABLE public.branch_default_delivery_receivers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id bigint NOT NULL,
    user_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: branch_default_positions; Type: TABLE; Schema: public; Owner: -
--

