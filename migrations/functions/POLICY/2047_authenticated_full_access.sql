CREATE POLICY authenticated_full_access ON public.recurring_assignment_schedules USING ((auth.uid() IS NOT NULL));


--
-- Name: recurring_schedule_check_log authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

