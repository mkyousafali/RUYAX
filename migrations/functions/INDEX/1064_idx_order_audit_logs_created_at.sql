CREATE INDEX idx_order_audit_logs_created_at ON public.order_audit_logs USING btree (created_at DESC);


--
-- Name: idx_order_audit_logs_order_action; Type: INDEX; Schema: public; Owner: -
--

