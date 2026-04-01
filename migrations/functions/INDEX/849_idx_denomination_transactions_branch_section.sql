CREATE INDEX idx_denomination_transactions_branch_section ON public.denomination_transactions USING btree (branch_id, section);


--
-- Name: idx_denomination_transactions_created_at; Type: INDEX; Schema: public; Owner: -
--

