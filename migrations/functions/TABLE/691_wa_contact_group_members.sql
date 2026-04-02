CREATE TABLE public.wa_contact_group_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    group_id uuid,
    customer_id uuid,
    added_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_contact_groups; Type: TABLE; Schema: public; Owner: -
--

