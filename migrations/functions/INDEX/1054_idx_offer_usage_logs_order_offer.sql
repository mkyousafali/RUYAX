CREATE INDEX idx_offer_usage_logs_order_offer ON public.offer_usage_logs USING btree (order_id, offer_id);


--
-- Name: idx_offer_usage_logs_used_at; Type: INDEX; Schema: public; Owner: -
--

