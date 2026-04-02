CREATE POLICY admin_all_offer_cart_tiers ON public.offer_cart_tiers USING (true) WITH CHECK (true);


--
-- Name: ai_chat_guide; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_chat_guide ENABLE ROW LEVEL SECURITY;

--
-- Name: lease_rent_special_changes allow_all_lease_rent_special_changes; Type: POLICY; Schema: public; Owner: -
--

