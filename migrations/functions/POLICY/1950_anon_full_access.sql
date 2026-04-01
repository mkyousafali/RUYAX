CREATE POLICY anon_full_access ON public.interface_permissions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: non_approved_payment_scheduler anon_full_access; Type: POLICY; Schema: public; Owner: -
--

