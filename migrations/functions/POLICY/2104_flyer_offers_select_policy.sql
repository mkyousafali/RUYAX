CREATE POLICY flyer_offers_select_policy ON public.flyer_offers FOR SELECT USING ((is_active = true));


--
-- Name: POLICY flyer_offers_select_policy ON flyer_offers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY flyer_offers_select_policy ON public.flyer_offers IS 'Allows public read access to active flyer offers only';


--
-- Name: flyer_offers flyer_offers_update_policy; Type: POLICY; Schema: public; Owner: -
--

