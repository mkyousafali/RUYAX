CREATE INDEX idx_orders_customer_status ON public.orders USING btree (customer_id, order_status);


--
-- Name: idx_orders_delivery_person_id; Type: INDEX; Schema: public; Owner: -
--

