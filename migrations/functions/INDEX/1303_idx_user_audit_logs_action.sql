CREATE INDEX idx_user_audit_logs_action ON public.user_audit_logs USING btree (action);


--
-- Name: idx_user_audit_logs_created_at; Type: INDEX; Schema: public; Owner: -
--

