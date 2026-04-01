CREATE INDEX idx_customer_product_requests_target ON public.customer_product_requests USING btree (target_user_id);


--
-- Name: idx_customer_recovery_requests_created_at; Type: INDEX; Schema: public; Owner: -
--

