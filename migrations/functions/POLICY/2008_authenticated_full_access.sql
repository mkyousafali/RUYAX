CREATE POLICY authenticated_full_access ON public.erp_daily_sales USING ((auth.uid() IS NOT NULL));


--
-- Name: expense_parent_categories authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

