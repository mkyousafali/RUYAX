CREATE POLICY allow_public_read_bogo ON public.bogo_offer_rules FOR SELECT TO authenticated, anon USING (true);


--
-- Name: offer_bundles allow_public_read_bundles; Type: POLICY; Schema: public; Owner: -
--

