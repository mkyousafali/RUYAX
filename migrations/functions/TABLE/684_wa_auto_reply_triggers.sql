CREATE TABLE public.wa_auto_reply_triggers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text,
    trigger_words_en text[] DEFAULT '{}'::text[],
    trigger_words_ar text[] DEFAULT '{}'::text[],
    match_type character varying(20) DEFAULT 'contains'::character varying,
    reply_type character varying(20) DEFAULT 'text'::character varying,
    reply_text text,
    reply_media_url text,
    reply_template_id uuid,
    reply_buttons jsonb DEFAULT '[]'::jsonb,
    follow_up_trigger_id uuid,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    trigger_words text[] DEFAULT ARRAY[]::text[],
    response_type character varying(20) DEFAULT 'text'::character varying,
    response_content text,
    response_media_url text,
    response_template_name text,
    response_buttons jsonb DEFAULT '[]'::jsonb,
    follow_up_delay_seconds integer DEFAULT 0,
    follow_up_content text,
    priority integer DEFAULT 0
);


--
-- Name: wa_bot_flows; Type: TABLE; Schema: public; Owner: -
--

