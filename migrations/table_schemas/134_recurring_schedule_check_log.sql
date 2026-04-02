--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: recurring_schedule_check_log; Type: TABLE; Schema: public; Owner: -
--

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

CREATE SEQUENCE public.recurring_schedule_check_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recurring_schedule_check_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recurring_schedule_check_log_id_seq OWNED BY public.recurring_schedule_check_log.id;


--
-- Name: recurring_schedule_check_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_schedule_check_log ALTER COLUMN id SET DEFAULT nextval('public.recurring_schedule_check_log_id_seq'::regclass);


--
-- Name: recurring_schedule_check_log recurring_schedule_check_log_check_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_schedule_check_log
    ADD CONSTRAINT recurring_schedule_check_log_check_date_key UNIQUE (check_date);


--
-- Name: recurring_schedule_check_log recurring_schedule_check_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurring_schedule_check_log
    ADD CONSTRAINT recurring_schedule_check_log_pkey PRIMARY KEY (id);


--
-- Name: recurring_schedule_check_log Allow anon insert recurring_schedule_check_log; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow anon insert recurring_schedule_check_log" ON public.recurring_schedule_check_log FOR INSERT TO anon WITH CHECK (true);


--
-- Name: recurring_schedule_check_log Only global users can view check logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Only global users can view check logs" ON public.recurring_schedule_check_log FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));


--
-- Name: recurring_schedule_check_log allow_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_all_operations ON public.recurring_schedule_check_log USING (true) WITH CHECK (true);


--
-- Name: recurring_schedule_check_log allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.recurring_schedule_check_log FOR DELETE USING (true);


--
-- Name: recurring_schedule_check_log allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.recurring_schedule_check_log FOR INSERT WITH CHECK (true);


--
-- Name: recurring_schedule_check_log allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.recurring_schedule_check_log FOR SELECT USING (true);


--
-- Name: recurring_schedule_check_log allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.recurring_schedule_check_log FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: recurring_schedule_check_log anon_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY anon_full_access ON public.recurring_schedule_check_log USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: recurring_schedule_check_log authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY authenticated_full_access ON public.recurring_schedule_check_log USING ((auth.uid() IS NOT NULL));


--
-- Name: recurring_schedule_check_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.recurring_schedule_check_log ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE recurring_schedule_check_log; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.recurring_schedule_check_log TO anon;
GRANT SELECT ON TABLE public.recurring_schedule_check_log TO authenticated;
GRANT ALL ON TABLE public.recurring_schedule_check_log TO service_role;
GRANT SELECT ON TABLE public.recurring_schedule_check_log TO replication_user;


--
-- Name: SEQUENCE recurring_schedule_check_log_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.recurring_schedule_check_log_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.recurring_schedule_check_log_id_seq TO anon;
GRANT ALL ON SEQUENCE public.recurring_schedule_check_log_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.recurring_schedule_check_log_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

