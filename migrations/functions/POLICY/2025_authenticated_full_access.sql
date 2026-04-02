CREATE POLICY authenticated_full_access ON public.non_approved_payment_scheduler USING ((auth.uid() IS NOT NULL));


--
-- Name: notification_attachments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

