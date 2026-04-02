CREATE POLICY anon_full_access ON public.orders USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: privilege_cards_branch anon_full_access; Type: POLICY; Schema: public; Owner: -
--

