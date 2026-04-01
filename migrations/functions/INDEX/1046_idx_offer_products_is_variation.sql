CREATE INDEX idx_offer_products_is_variation ON public.offer_products USING btree (is_part_of_variation_group) WHERE (is_part_of_variation_group = true);


--
-- Name: idx_offer_products_offer_id; Type: INDEX; Schema: public; Owner: -
--

