CREATE TABLE public.wa_contact_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    customer_count integer DEFAULT 0,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_conversations; Type: TABLE; Schema: public; Owner: -
--

