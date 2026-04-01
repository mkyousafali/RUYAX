CREATE POLICY allow_update ON public.approval_permissions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: biometric_connections allow_update; Type: POLICY; Schema: public; Owner: -
--

