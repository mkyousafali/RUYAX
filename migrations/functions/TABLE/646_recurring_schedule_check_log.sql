CREATE TABLE public.recurring_schedule_check_log (
    id integer NOT NULL,
    check_date date DEFAULT CURRENT_DATE NOT NULL,
    schedules_checked integer DEFAULT 0,
    notifications_sent integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE recurring_schedule_check_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.recurring_schedule_check_log IS 'Log table for recurring schedule checks. 

To manually run the check, execute:
SELECT * FROM check_and_notify_recurring_schedules_with_logging();

To set up automatic daily execution:
1. Enable pg_cron extension in Supabase (may require contacting support)
2. Create cron job: 
   SELECT cron.schedule(''check-recurring-schedules'', ''0 6 * * *'', 
   $$SELECT check_and_notify_recurring_schedules_with_logging();$$);

Alternatively, use external cron service (GitHub Actions, Vercel Cron, etc.) to call:
POST https://your-project.supabase.co/rest/v1/rpc/check_and_notify_recurring_schedules_with_logging
';


--
-- Name: recurring_schedule_check_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

