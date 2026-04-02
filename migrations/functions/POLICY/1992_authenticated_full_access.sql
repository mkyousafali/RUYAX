CREATE POLICY authenticated_full_access ON public.approval_permissions USING ((auth.uid() IS NOT NULL));


--
-- Name: biometric_connections authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

