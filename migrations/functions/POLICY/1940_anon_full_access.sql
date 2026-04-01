CREATE POLICY anon_full_access ON public.flyer_offers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: flyer_templates anon_full_access; Type: POLICY; Schema: public; Owner: -
--

