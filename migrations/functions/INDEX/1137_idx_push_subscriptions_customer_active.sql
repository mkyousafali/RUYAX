CREATE INDEX idx_push_subscriptions_customer_active ON public.push_subscriptions USING btree (customer_id, is_active) WHERE ((is_active = true) AND (customer_id IS NOT NULL));


--
-- Name: idx_push_subscriptions_customer_id; Type: INDEX; Schema: public; Owner: -
--

