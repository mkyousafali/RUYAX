CREATE INDEX idx_erp_synced_products_expiry_dates ON public.erp_synced_products USING gin (expiry_dates);


--
-- Name: idx_erp_synced_products_expiry_hidden; Type: INDEX; Schema: public; Owner: -
--

