CREATE POLICY allow_update_offers ON public.offers FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: approval_permissions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

