CREATE INDEX idx_variation_audit_log_action_type ON public.variation_audit_log USING btree (action_type);


--
-- Name: idx_variation_audit_log_parent_barcode; Type: INDEX; Schema: public; Owner: -
--

