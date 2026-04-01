CREATE INDEX idx_order_audit_logs_assigned_user ON public.order_audit_logs USING btree (assigned_user_id);


--
-- Name: idx_order_audit_logs_created_at; Type: INDEX; Schema: public; Owner: -
--

