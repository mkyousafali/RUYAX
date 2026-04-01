CREATE TABLE public.user_device_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    device_id character varying(100) NOT NULL,
    session_token character varying(255) NOT NULL,
    device_type character varying(20) NOT NULL,
    browser_name character varying(50),
    user_agent text,
    ip_address inet,
    is_active boolean DEFAULT true,
    login_at timestamp with time zone DEFAULT now(),
    last_activity timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '24:00:00'::interval),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_device_sessions_device_type_check CHECK (((device_type)::text = ANY (ARRAY[('mobile'::character varying)::text, ('desktop'::character varying)::text])))
);


--
-- Name: user_favorite_buttons; Type: TABLE; Schema: public; Owner: -
--

