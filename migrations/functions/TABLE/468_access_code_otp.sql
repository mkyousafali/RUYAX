CREATE TABLE public.access_code_otp (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    otp_code character varying(6) NOT NULL,
    email character varying(255) NOT NULL,
    whatsapp_number character varying(20) NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:05:00'::interval) NOT NULL,
    verified boolean DEFAULT false,
    attempts integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: ai_chat_guide; Type: TABLE; Schema: public; Owner: -
--

