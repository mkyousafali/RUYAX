CREATE POLICY allow_update ON public.non_approved_payment_scheduler FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: notification_attachments allow_update; Type: POLICY; Schema: public; Owner: -
--

