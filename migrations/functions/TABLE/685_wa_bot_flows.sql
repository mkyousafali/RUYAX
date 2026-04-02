CREATE TABLE public.wa_bot_flows (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text NOT NULL,
    trigger_words_en text[] DEFAULT ARRAY[]::text[],
    trigger_words_ar text[] DEFAULT ARRAY[]::text[],
    match_type character varying(20) DEFAULT 'contains'::character varying,
    nodes jsonb DEFAULT '[]'::jsonb,
    edges jsonb DEFAULT '[]'::jsonb,
    is_active boolean DEFAULT true,
    priority integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: wa_broadcast_recipients; Type: TABLE; Schema: public; Owner: -
--

