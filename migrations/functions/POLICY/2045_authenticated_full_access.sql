CREATE POLICY authenticated_full_access ON public.receiving_task_templates USING ((auth.uid() IS NOT NULL));


--
-- Name: receiving_tasks authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

