CREATE POLICY allow_update ON public.receiving_tasks FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: recurring_assignment_schedules allow_update; Type: POLICY; Schema: public; Owner: -
--

