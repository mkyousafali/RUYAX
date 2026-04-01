CREATE INDEX idx_order_audit_logs_order_created ON public.order_audit_logs USING btree (order_id, created_at DESC);


--
-- Name: idx_order_audit_logs_order_id; Type: INDEX; Schema: public; Owner: -
--

