CREATE TABLE public.wa_broadcast_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    broadcast_id uuid,
    customer_id uuid,
    phone_number character varying(20) NOT NULL,
    customer_name text,
    whatsapp_message_id text,
    status character varying(20) DEFAULT 'pending'::character varying,
    error_details text,
    sent_at timestamp with time zone
);

ALTER TABLE ONLY public.wa_broadcast_recipients REPLICA IDENTITY FULL;


--
-- Name: wa_broadcasts; Type: TABLE; Schema: public; Owner: -
--

