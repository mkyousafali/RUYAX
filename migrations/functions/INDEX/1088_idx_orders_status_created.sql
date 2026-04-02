CREATE INDEX idx_orders_status_created ON public.orders USING btree (order_status, created_at DESC);


--
-- Name: idx_password_history_user_created; Type: INDEX; Schema: public; Owner: -
--

