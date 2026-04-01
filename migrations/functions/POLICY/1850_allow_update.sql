CREATE POLICY allow_update ON public.customer_access_code_history FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: customer_app_media allow_update; Type: POLICY; Schema: public; Owner: -
--

