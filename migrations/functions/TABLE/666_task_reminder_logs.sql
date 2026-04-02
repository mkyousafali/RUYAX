CREATE TABLE public.task_reminder_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_assignment_id uuid,
    quick_task_assignment_id uuid,
    task_title text NOT NULL,
    assigned_to_user_id uuid,
    deadline timestamp with time zone NOT NULL,
    hours_overdue numeric,
    reminder_sent_at timestamp with time zone DEFAULT now(),
    notification_id uuid,
    status text DEFAULT 'sent'::text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT check_single_assignment CHECK ((((task_assignment_id IS NOT NULL) AND (quick_task_assignment_id IS NULL)) OR ((task_assignment_id IS NULL) AND (quick_task_assignment_id IS NOT NULL))))
);


--
-- Name: TABLE task_reminder_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.task_reminder_logs IS 'Logs all automatic and manual task reminders sent to users';


--
-- Name: user_audit_logs; Type: TABLE; Schema: public; Owner: -
--

