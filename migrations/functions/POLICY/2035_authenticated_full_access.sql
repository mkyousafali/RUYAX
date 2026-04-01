CREATE POLICY authenticated_full_access ON public.order_items USING ((auth.uid() IS NOT NULL));


--
-- Name: orders authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

