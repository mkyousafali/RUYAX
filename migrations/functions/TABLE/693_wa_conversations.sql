CREATE TABLE public.wa_conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    customer_id uuid,
    customer_phone character varying(20) NOT NULL,
    customer_name text,
    last_message_at timestamp with time zone,
    last_message_preview text,
    unread_count integer DEFAULT 0,
    is_bot_handling boolean DEFAULT false,
    bot_type character varying(20),
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    branch_id uuid,
    handled_by character varying(20) DEFAULT 'bot'::character varying,
    window_expires_at timestamp with time zone,
    needs_human boolean DEFAULT false,
    is_sos boolean DEFAULT false
);


--
-- Name: wa_messages; Type: TABLE; Schema: public; Owner: -
--

