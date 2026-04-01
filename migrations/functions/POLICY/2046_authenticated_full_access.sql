CREATE POLICY authenticated_full_access ON public.receiving_tasks USING ((auth.uid() IS NOT NULL));


--
-- Name: recurring_assignment_schedules authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

