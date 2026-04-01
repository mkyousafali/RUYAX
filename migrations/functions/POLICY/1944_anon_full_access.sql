CREATE POLICY anon_full_access ON public.hr_employees USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_fingerprint_transactions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

