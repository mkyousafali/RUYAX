CREATE TABLE public.notification_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    role character varying(100),
    branch_id character varying(255),
    is_read boolean DEFAULT false NOT NULL,
    read_at timestamp with time zone,
    is_dismissed boolean DEFAULT false NOT NULL,
    dismissed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    delivery_status character varying(20) DEFAULT 'pending'::character varying,
    delivery_attempted_at timestamp with time zone,
    error_message text,
    user_id uuid
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

