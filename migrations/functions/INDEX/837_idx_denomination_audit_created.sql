CREATE INDEX idx_denomination_audit_created ON public.denomination_audit_log USING btree (created_at DESC);


--
-- Name: idx_denomination_audit_record; Type: INDEX; Schema: public; Owner: -
--

