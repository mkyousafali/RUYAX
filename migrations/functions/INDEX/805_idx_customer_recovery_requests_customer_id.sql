CREATE INDEX idx_customer_recovery_requests_customer_id ON public.customer_recovery_requests USING btree (customer_id);


--
-- Name: idx_customer_recovery_requests_processed_by; Type: INDEX; Schema: public; Owner: -
--

