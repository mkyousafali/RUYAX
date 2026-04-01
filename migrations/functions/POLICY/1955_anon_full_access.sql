CREATE POLICY anon_full_access ON public.notifications USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: offer_bundles anon_full_access; Type: POLICY; Schema: public; Owner: -
--

