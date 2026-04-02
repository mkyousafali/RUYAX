CREATE POLICY authenticated_full_access ON public.quick_task_completions USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_task_files authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

