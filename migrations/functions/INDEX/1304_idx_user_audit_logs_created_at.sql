CREATE INDEX idx_user_audit_logs_created_at ON public.user_audit_logs USING btree (created_at);


--
-- Name: idx_user_audit_logs_user_id; Type: INDEX; Schema: public; Owner: -
--

