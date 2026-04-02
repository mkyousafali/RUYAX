CREATE POLICY authenticated_full_access ON public.task_completions USING ((auth.uid() IS NOT NULL));


--
-- Name: task_images authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

