CREATE INDEX idx_order_items_order_bundle ON public.order_items USING btree (order_id, bundle_id);


--
-- Name: idx_order_items_order_id; Type: INDEX; Schema: public; Owner: -
--

