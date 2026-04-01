CREATE INDEX idx_erp_synced_products_managed_by ON public.erp_synced_products USING gin (managed_by);


--
-- Name: idx_erp_synced_products_parent_barcode; Type: INDEX; Schema: public; Owner: -
--

