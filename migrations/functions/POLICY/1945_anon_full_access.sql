CREATE POLICY anon_full_access ON public.hr_fingerprint_transactions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_levels anon_full_access; Type: POLICY; Schema: public; Owner: -
--

