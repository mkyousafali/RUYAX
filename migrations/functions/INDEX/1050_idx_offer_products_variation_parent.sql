CREATE INDEX idx_offer_products_variation_parent ON public.offer_products USING btree (variation_parent_barcode) WHERE (variation_parent_barcode IS NOT NULL);


--
-- Name: idx_offer_usage_logs_customer_id; Type: INDEX; Schema: public; Owner: -
--

