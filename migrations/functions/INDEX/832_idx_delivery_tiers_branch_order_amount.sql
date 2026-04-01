CREATE INDEX idx_delivery_tiers_branch_order_amount ON public.delivery_fee_tiers USING btree (branch_id, min_order_amount, max_order_amount) WHERE (is_active = true);


--
-- Name: idx_delivery_tiers_order; Type: INDEX; Schema: public; Owner: -
--

