CREATE INDEX idx_customer_recovery_requests_request_type ON public.customer_recovery_requests USING btree (request_type);


--
-- Name: idx_customer_recovery_requests_verification_status; Type: INDEX; Schema: public; Owner: -
--

