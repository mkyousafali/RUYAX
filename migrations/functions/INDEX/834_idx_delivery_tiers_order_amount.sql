CREATE INDEX idx_delivery_tiers_order_amount ON public.delivery_fee_tiers USING btree (min_order_amount, max_order_amount);


--
-- Name: idx_denomination_audit_action; Type: INDEX; Schema: public; Owner: -
--

