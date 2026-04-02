CREATE POLICY flyer_offers_select_all_policy ON public.flyer_offers FOR SELECT TO authenticated USING (true);


--
-- Name: POLICY flyer_offers_select_all_policy ON flyer_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY flyer_offers_select_all_policy ON public.flyer_offers IS 'Allows authenticated users to view all flyer offers including inactive';


--
-- Name: flyer_offers flyer_offers_select_policy; Type: POLICY; Schema: public; Owner: -
--

