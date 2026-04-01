CREATE POLICY authenticated_full_access ON public.orders USING ((auth.uid() IS NOT NULL));


--
-- Name: privilege_cards_branch authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

