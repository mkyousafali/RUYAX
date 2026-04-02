CREATE INDEX idx_erp_synced_products_in_process ON public.erp_synced_products USING gin (in_process);


--
-- Name: idx_erp_synced_products_managed_by; Type: INDEX; Schema: public; Owner: -
--

