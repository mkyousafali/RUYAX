CREATE INDEX idx_offer_products_variation_group_id ON public.offer_products USING btree (variation_group_id) WHERE (variation_group_id IS NOT NULL);


--
-- Name: idx_offer_products_variation_parent; Type: INDEX; Schema: public; Owner: -
--

