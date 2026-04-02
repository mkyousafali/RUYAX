CREATE POLICY authenticated_full_access ON public.hr_fingerprint_transactions USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_levels authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

