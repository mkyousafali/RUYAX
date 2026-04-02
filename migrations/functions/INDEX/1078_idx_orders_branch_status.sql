CREATE INDEX idx_orders_branch_status ON public.orders USING btree (branch_id, order_status);


--
-- Name: idx_orders_created_at; Type: INDEX; Schema: public; Owner: -
--

