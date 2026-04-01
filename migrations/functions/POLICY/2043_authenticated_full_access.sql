CREATE POLICY authenticated_full_access ON public.quick_task_user_preferences USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_tasks authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

