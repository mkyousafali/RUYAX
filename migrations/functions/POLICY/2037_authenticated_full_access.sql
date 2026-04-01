CREATE POLICY authenticated_full_access ON public.privilege_cards_branch USING ((auth.uid() IS NOT NULL));


--
-- Name: privilege_cards_master authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

