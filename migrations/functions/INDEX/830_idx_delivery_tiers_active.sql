CREATE INDEX idx_delivery_tiers_active ON public.delivery_fee_tiers USING btree (is_active);


--
-- Name: idx_delivery_tiers_branch_order; Type: INDEX; Schema: public; Owner: -
--

