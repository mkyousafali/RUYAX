CREATE POLICY anon_full_access ON public.non_approved_payment_scheduler USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: notification_attachments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

