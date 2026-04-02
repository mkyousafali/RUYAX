CREATE INDEX idx_order_audit_logs_order_id ON public.order_audit_logs USING btree (order_id);


--
-- Name: idx_order_audit_logs_performed_by; Type: INDEX; Schema: public; Owner: -
--

