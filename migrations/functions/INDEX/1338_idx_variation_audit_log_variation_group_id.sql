CREATE INDEX idx_variation_audit_log_variation_group_id ON public.variation_audit_log USING btree (variation_group_id) WHERE (variation_group_id IS NOT NULL);


--
-- Name: idx_vendor_payment_approval_requested_by; Type: INDEX; Schema: public; Owner: -
--

