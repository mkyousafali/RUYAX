CREATE POLICY allow_update ON public.customer_recovery_requests FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: customers allow_update; Type: POLICY; Schema: public; Owner: -
--

