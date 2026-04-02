CREATE INDEX idx_orders_delivery_person_id ON public.orders USING btree (delivery_person_id);


--
-- Name: idx_orders_fulfillment_method; Type: INDEX; Schema: public; Owner: -
--

