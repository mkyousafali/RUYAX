CREATE POLICY anon_full_access ON public.erp_daily_sales USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: expense_parent_categories anon_full_access; Type: POLICY; Schema: public; Owner: -
--

