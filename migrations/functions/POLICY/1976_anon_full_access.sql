CREATE POLICY anon_full_access ON public.shelf_paper_templates USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: task_assignments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

