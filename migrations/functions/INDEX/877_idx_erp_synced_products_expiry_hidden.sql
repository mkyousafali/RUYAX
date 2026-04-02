CREATE INDEX idx_erp_synced_products_expiry_hidden ON public.erp_synced_products USING btree (expiry_hidden) WHERE (expiry_hidden = true);


--
-- Name: idx_erp_synced_products_in_process; Type: INDEX; Schema: public; Owner: -
--

