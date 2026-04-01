CREATE INDEX idx_customer_recovery_requests_created_at ON public.customer_recovery_requests USING btree (created_at);


--
-- Name: idx_customer_recovery_requests_customer_id; Type: INDEX; Schema: public; Owner: -
--

