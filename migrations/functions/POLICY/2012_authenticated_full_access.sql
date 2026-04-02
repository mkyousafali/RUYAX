CREATE POLICY authenticated_full_access ON public.expense_sub_categories USING ((auth.uid() IS NOT NULL));


--
-- Name: flyer_offer_products authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

