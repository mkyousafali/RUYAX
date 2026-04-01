CREATE POLICY allow_update ON public.recurring_assignment_schedules FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: recurring_schedule_check_log allow_update; Type: POLICY; Schema: public; Owner: -
--

