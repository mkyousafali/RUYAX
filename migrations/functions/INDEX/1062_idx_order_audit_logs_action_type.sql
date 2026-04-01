CREATE INDEX idx_order_audit_logs_action_type ON public.order_audit_logs USING btree (action_type);


--
-- Name: idx_order_audit_logs_assigned_user; Type: INDEX; Schema: public; Owner: -
--

