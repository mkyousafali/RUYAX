CREATE POLICY authenticated_full_access ON public.hr_employees USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_fingerprint_transactions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

