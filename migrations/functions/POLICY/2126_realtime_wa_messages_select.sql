CREATE POLICY realtime_wa_messages_select ON public.wa_messages FOR SELECT TO authenticated, anon USING (true);


--
-- Name: receiving_records; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.receiving_records ENABLE ROW LEVEL SECURITY;

--
-- Name: receiving_task_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.receiving_task_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: receiving_tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.receiving_tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: receiving_user_defaults; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.receiving_user_defaults ENABLE ROW LEVEL SECURITY;

--
-- Name: recurring_assignment_schedules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.recurring_assignment_schedules ENABLE ROW LEVEL SECURITY;

--
-- Name: recurring_schedule_check_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.recurring_schedule_check_log ENABLE ROW LEVEL SECURITY;

--
-- Name: regular_shift; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.regular_shift ENABLE ROW LEVEL SECURITY;

--
-- Name: requesters; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.requesters ENABLE ROW LEVEL SECURITY;

--
-- Name: branches rls_delete; Type: POLICY; Schema: public; Owner: -
--

