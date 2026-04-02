CREATE INDEX idx_customer_recovery_requests_processed_by ON public.customer_recovery_requests USING btree (processed_by);


--
-- Name: idx_customer_recovery_requests_request_type; Type: INDEX; Schema: public; Owner: -
--

