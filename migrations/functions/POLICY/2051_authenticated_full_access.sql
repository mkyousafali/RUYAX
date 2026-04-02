CREATE POLICY authenticated_full_access ON public.task_assignments USING ((auth.uid() IS NOT NULL));


--
-- Name: task_completions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

