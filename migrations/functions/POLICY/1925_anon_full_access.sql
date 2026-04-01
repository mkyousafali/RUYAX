CREATE POLICY anon_full_access ON public.customer_access_code_history USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: customer_app_media anon_full_access; Type: POLICY; Schema: public; Owner: -
--

