CREATE INDEX idx_offer_products_active_lookup ON public.offer_products USING btree (offer_id, product_id);


--
-- Name: idx_offer_products_is_variation; Type: INDEX; Schema: public; Owner: -
--

