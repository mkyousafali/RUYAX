CREATE TABLE public.wa_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    meta_template_id text,
    name character varying(100) NOT NULL,
    category character varying(20) DEFAULT 'UTILITY'::character varying,
    language character varying(10) DEFAULT 'en'::character varying,
    status character varying(20) DEFAULT 'PENDING'::character varying,
    header_type character varying(20) DEFAULT 'none'::character varying,
    header_content text,
    body_text text,
    footer_text text,
    buttons jsonb DEFAULT '[]'::jsonb,
    meta_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: warning_main_category; Type: TABLE; Schema: public; Owner: -
--

