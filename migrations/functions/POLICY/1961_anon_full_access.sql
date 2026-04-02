CREATE POLICY anon_full_access ON public.order_items USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: orders anon_full_access; Type: POLICY; Schema: public; Owner: -
--

