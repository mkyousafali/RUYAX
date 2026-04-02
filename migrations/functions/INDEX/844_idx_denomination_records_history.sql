CREATE INDEX idx_denomination_records_history ON public.denomination_records USING btree (branch_id, record_type, created_at DESC);


--
-- Name: idx_denomination_records_petty_cash_operation; Type: INDEX; Schema: public; Owner: -
--

