CREATE TABLE public.wa_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid,
    wa_account_id uuid,
    whatsapp_message_id text,
    direction character varying(10) DEFAULT 'outbound'::character varying NOT NULL,
    message_type character varying(20) DEFAULT 'text'::character varying,
    content text,
    media_url text,
    media_mime_type character varying(50),
    template_name character varying(100),
    template_language character varying(10),
    status character varying(20) DEFAULT 'sent'::character varying,
    sent_by character varying(20) DEFAULT 'user'::character varying,
    sent_by_user_id uuid,
    error_details text,
    created_at timestamp with time zone DEFAULT now(),
    delivered_at timestamp with time zone,
    read_at timestamp with time zone,
    metadata jsonb
);


--
-- Name: wa_settings; Type: TABLE; Schema: public; Owner: -
--

