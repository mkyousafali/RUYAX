CREATE INDEX idx_push_subscriptions_customer_id ON public.push_subscriptions USING btree (customer_id) WHERE (customer_id IS NOT NULL);


--
-- Name: idx_push_subscriptions_user_id; Type: INDEX; Schema: public; Owner: -
--

