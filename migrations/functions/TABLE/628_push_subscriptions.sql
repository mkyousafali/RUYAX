CREATE TABLE public.push_subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    subscription jsonb NOT NULL,
    endpoint text NOT NULL,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    failed_deliveries integer DEFAULT 0,
    is_active boolean DEFAULT true,
    customer_id uuid,
    CONSTRAINT chk_push_sub_user_or_customer CHECK (((user_id IS NOT NULL) OR (customer_id IS NOT NULL)))
);


--
-- Name: TABLE push_subscriptions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.push_subscriptions IS 'Stores web push notification subscriptions for users';


--
-- Name: COLUMN push_subscriptions.subscription; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.push_subscriptions.subscription IS 'Full PushSubscription object in JSON format';


--
-- Name: COLUMN push_subscriptions.endpoint; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.push_subscriptions.endpoint IS 'Push service endpoint URL for deduplication';


--
-- Name: COLUMN push_subscriptions.failed_deliveries; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.push_subscriptions.failed_deliveries IS 'Count of consecutive failed push attempts';


--
-- Name: COLUMN push_subscriptions.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.push_subscriptions.is_active IS 'Whether this subscription is active and should receive pushes';


--
-- Name: quick_task_assignments; Type: TABLE; Schema: public; Owner: -
--

