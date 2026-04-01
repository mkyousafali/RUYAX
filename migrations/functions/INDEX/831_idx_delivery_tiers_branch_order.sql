CREATE INDEX idx_delivery_tiers_branch_order ON public.delivery_fee_tiers USING btree (branch_id, tier_order);


--
-- Name: idx_delivery_tiers_branch_order_amount; Type: INDEX; Schema: public; Owner: -
--

