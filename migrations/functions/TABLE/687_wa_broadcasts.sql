CREATE TABLE public.wa_broadcasts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text,
    template_id uuid,
    recipient_filter character varying(20) DEFAULT 'all'::character varying,
    recipient_group_id uuid,
    total_recipients integer DEFAULT 0,
    sent_count integer DEFAULT 0,
    delivered_count integer DEFAULT 0,
    read_count integer DEFAULT 0,
    failed_count integer DEFAULT 0,
    status character varying(20) DEFAULT 'draft'::character varying,
    scheduled_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.wa_broadcasts REPLICA IDENTITY FULL;


--
-- Name: wa_catalog_orders; Type: TABLE; Schema: public; Owner: -
--

