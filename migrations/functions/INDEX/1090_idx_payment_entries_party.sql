CREATE INDEX idx_payment_entries_party ON public.lease_rent_payment_entries USING btree (party_type, party_id, period_num, column_name);


--
-- Name: idx_payments_party; Type: INDEX; Schema: public; Owner: -
--

