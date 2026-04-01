CREATE TABLE public.notification_read_states (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    user_id text NOT NULL,
    read_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    is_read boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN notification_read_states.is_read; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.notification_read_states.is_read IS 'Whether the notification has been read by the user';


--
-- Name: notification_recipients; Type: TABLE; Schema: public; Owner: -
--

