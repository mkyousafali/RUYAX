CREATE POLICY flyer_offers_delete_policy ON public.flyer_offers FOR DELETE TO authenticated USING (true);


--
-- Name: flyer_offers flyer_offers_insert_policy; Type: POLICY; Schema: public; Owner: -
--

