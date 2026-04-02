CREATE INDEX idx_offer_cart_tiers_amount_range ON public.offer_cart_tiers USING btree (min_amount, max_amount);


--
-- Name: idx_offer_cart_tiers_offer_id; Type: INDEX; Schema: public; Owner: -
--

