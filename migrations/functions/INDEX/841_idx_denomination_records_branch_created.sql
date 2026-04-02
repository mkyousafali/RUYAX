CREATE INDEX idx_denomination_records_branch_created ON public.denomination_records USING btree (branch_id, created_at DESC);


--
-- Name: idx_denomination_records_branch_type; Type: INDEX; Schema: public; Owner: -
--

