CREATE INDEX idx_erp_sync_logs_created_at ON public.erp_sync_logs USING btree (created_at DESC);


--
-- Name: idx_erp_synced_products_barcode; Type: INDEX; Schema: public; Owner: -
--

