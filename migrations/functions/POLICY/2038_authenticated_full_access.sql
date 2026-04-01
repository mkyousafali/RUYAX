CREATE POLICY authenticated_full_access ON public.privilege_cards_master USING ((auth.uid() IS NOT NULL));


--
-- Name: quick_task_assignments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

