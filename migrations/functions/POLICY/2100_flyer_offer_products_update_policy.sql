CREATE POLICY flyer_offer_products_update_policy ON public.flyer_offer_products FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: flyer_offers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.flyer_offers ENABLE ROW LEVEL SECURITY;

--
-- Name: flyer_offers flyer_offers_delete_policy; Type: POLICY; Schema: public; Owner: -
--

