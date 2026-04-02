CREATE INDEX idx_push_subscriptions_active ON public.push_subscriptions USING btree (user_id, is_active) WHERE (is_active = true);


--
-- Name: idx_push_subscriptions_customer_active; Type: INDEX; Schema: public; Owner: -
--

