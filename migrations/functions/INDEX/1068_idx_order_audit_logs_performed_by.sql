CREATE INDEX idx_order_audit_logs_performed_by ON public.order_audit_logs USING btree (performed_by);


--
-- Name: idx_order_items_bundle_id; Type: INDEX; Schema: public; Owner: -
--

