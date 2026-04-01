CREATE POLICY authenticated_full_access ON public.quick_task_comments USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_task_completions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

