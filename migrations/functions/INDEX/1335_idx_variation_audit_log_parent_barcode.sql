CREATE INDEX idx_variation_audit_log_parent_barcode ON public.variation_audit_log USING btree (parent_barcode) WHERE (parent_barcode IS NOT NULL);


--
-- Name: idx_variation_audit_log_timestamp; Type: INDEX; Schema: public; Owner: -
--

