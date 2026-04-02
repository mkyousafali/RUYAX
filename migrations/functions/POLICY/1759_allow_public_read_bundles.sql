CREATE POLICY allow_public_read_bundles ON public.offer_bundles FOR SELECT TO authenticated, anon USING (true);


--
-- Name: approval_permissions allow_select; Type: POLICY; Schema: public; Owner: -
--

