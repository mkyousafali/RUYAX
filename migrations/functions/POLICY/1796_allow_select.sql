CREATE POLICY allow_select ON public.non_approved_payment_scheduler FOR SELECT USING (true);


--
-- Name: notification_attachments allow_select; Type: POLICY; Schema: public; Owner: -
--

