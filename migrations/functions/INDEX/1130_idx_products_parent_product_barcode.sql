CREATE INDEX idx_products_parent_product_barcode ON public.products USING btree (parent_product_barcode);


--
-- Name: idx_products_unit_id; Type: INDEX; Schema: public; Owner: -
--

