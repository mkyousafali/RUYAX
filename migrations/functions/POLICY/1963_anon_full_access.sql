CREATE POLICY anon_full_access ON public.privilege_cards_branch USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: privilege_cards_master anon_full_access; Type: POLICY; Schema: public; Owner: -
--

