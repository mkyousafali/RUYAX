CREATE POLICY flyer_offer_products_select_policy ON public.flyer_offer_products FOR SELECT USING (true);


--
-- Name: POLICY flyer_offer_products_select_policy ON flyer_offer_products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY flyer_offer_products_select_policy ON public.flyer_offer_products IS 'Allows public read access to flyer offer products';


--
-- Name: flyer_offer_products flyer_offer_products_update_policy; Type: POLICY; Schema: public; Owner: -
--

