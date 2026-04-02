CREATE POLICY authenticated_full_access ON public.quick_tasks USING ((auth.uid() IS NOT NULL));


--
-- Name: receiving_task_templates authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

