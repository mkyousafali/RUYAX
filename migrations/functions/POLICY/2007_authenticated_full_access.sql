CREATE POLICY authenticated_full_access ON public.erp_connections USING ((auth.uid() IS NOT NULL));


--
-- Name: erp_daily_sales authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

