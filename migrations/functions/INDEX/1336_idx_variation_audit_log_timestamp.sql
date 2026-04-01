CREATE INDEX idx_variation_audit_log_timestamp ON public.variation_audit_log USING btree ("timestamp" DESC);


--
-- Name: idx_variation_audit_log_user_id; Type: INDEX; Schema: public; Owner: -
--

