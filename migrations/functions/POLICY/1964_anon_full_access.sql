CREATE POLICY anon_full_access ON public.privilege_cards_master USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_assignments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

