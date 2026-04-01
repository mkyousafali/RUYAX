CREATE INDEX idx_denomination_transactions_created_at ON public.denomination_transactions USING btree (created_at DESC);


--
-- Name: idx_denomination_transactions_section; Type: INDEX; Schema: public; Owner: -
--

