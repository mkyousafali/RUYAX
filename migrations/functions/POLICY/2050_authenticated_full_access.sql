CREATE POLICY authenticated_full_access ON public.shelf_paper_templates USING ((auth.uid() IS NOT NULL));


--
-- Name: task_assignments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

