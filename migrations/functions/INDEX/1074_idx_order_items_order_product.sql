CREATE INDEX idx_order_items_order_product ON public.order_items USING btree (order_id, product_id);


--
-- Name: idx_order_items_product_id; Type: INDEX; Schema: public; Owner: -
--

