CREATE INDEX idx_customer_recovery_requests_whatsapp ON public.customer_recovery_requests USING btree (whatsapp_number);


--
-- Name: idx_customers_access_code; Type: INDEX; Schema: public; Owner: -
--

