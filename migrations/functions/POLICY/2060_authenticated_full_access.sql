CREATE POLICY authenticated_full_access ON public.users USING ((auth.uid() IS NOT NULL));


--
-- Name: variation_audit_log authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

