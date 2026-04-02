CREATE INDEX idx_customer_product_requests_requester ON public.customer_product_requests USING btree (requester_user_id);


--
-- Name: idx_customer_product_requests_status; Type: INDEX; Schema: public; Owner: -
--

