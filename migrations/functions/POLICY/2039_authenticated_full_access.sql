CREATE POLICY authenticated_full_access ON public.quick_task_assignments USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_task_comments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

