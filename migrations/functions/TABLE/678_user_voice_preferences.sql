CREATE TABLE public.user_voice_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    locale text NOT NULL,
    voice_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_voice_preferences_locale_check CHECK ((locale = ANY (ARRAY['en'::text, 'ar'::text])))
);


--
-- Name: variation_audit_log; Type: TABLE; Schema: public; Owner: -
--

