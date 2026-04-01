CREATE POLICY anon_full_access ON public.expense_sub_categories USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: flyer_offer_products anon_full_access; Type: POLICY; Schema: public; Owner: -
--

