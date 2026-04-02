CREATE POLICY allow_update_all ON public.products FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: offers allow_update_offers; Type: POLICY; Schema: public; Owner: -
--

