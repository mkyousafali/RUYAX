CREATE INDEX idx_order_audit_logs_order_action ON public.order_audit_logs USING btree (order_id, action_type);


--
-- Name: idx_order_audit_logs_order_created; Type: INDEX; Schema: public; Owner: -
--

