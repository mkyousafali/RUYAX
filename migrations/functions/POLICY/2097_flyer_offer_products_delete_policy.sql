CREATE POLICY flyer_offer_products_delete_policy ON public.flyer_offer_products FOR DELETE TO authenticated USING (true);


--
-- Name: flyer_offer_products flyer_offer_products_insert_policy; Type: POLICY; Schema: public; Owner: -
--

