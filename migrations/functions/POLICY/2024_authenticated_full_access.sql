CREATE POLICY authenticated_full_access ON public.interface_permissions USING ((auth.uid() IS NOT NULL));


--
-- Name: non_approved_payment_scheduler authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

