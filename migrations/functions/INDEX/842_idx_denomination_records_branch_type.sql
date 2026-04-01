CREATE INDEX idx_denomination_records_branch_type ON public.denomination_records USING btree (branch_id, record_type);


--
-- Name: idx_denomination_records_created_at; Type: INDEX; Schema: public; Owner: -
--

