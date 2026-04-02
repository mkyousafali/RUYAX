CREATE TABLE public.user_sessions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    session_token character varying(255) NOT NULL,
    login_method character varying(20) NOT NULL,
    ip_address inet,
    user_agent text,
    is_active boolean DEFAULT true,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    ended_at timestamp with time zone,
    CONSTRAINT user_sessions_login_method_check CHECK (((login_method)::text = ANY (ARRAY[('quick_access'::character varying)::text, ('username_password'::character varying)::text])))
);


--
-- Name: user_theme_assignments; Type: TABLE; Schema: public; Owner: -
--

