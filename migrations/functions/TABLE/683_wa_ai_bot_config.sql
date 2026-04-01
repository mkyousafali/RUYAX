CREATE TABLE public.wa_ai_bot_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    is_enabled boolean DEFAULT false,
    tone character varying(20) DEFAULT 'friendly'::character varying,
    default_language character varying(10) DEFAULT 'auto'::character varying,
    max_replies_per_conversation integer DEFAULT 10,
    handoff_keywords text[] DEFAULT '{}'::text[],
    training_data jsonb DEFAULT '[]'::jsonb,
    custom_instructions text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    token_limit integer DEFAULT 500000,
    tokens_used integer DEFAULT 0,
    prompt_tokens_used integer DEFAULT 0,
    completion_tokens_used integer DEFAULT 0,
    total_requests integer DEFAULT 0,
    training_qa jsonb DEFAULT '[]'::jsonb,
    bot_rules text DEFAULT ''::text,
    human_support_enabled boolean DEFAULT false,
    human_support_start_time time without time zone DEFAULT '12:00:00'::time without time zone,
    human_support_end_time time without time zone DEFAULT '20:00:00'::time without time zone
);


--
-- Name: wa_auto_reply_triggers; Type: TABLE; Schema: public; Owner: -
--

