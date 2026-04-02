CREATE INDEX idx_customer_access_code_history_created_at ON public.customer_access_code_history USING btree (created_at);


--
-- Name: idx_customer_access_code_history_customer_id; Type: INDEX; Schema: public; Owner: -
--

