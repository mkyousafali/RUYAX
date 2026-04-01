CREATE POLICY anon_full_access ON public.view_offer USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: access_code_otp anon_insert; Type: POLICY; Schema: public; Owner: -
--

