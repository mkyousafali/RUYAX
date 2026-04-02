CREATE UNIQUE INDEX idx_payments_party_period ON public.lease_rent_payments USING btree (party_type, party_id, period_num);


--
-- Name: idx_pos_deduction_transfers_applied; Type: INDEX; Schema: public; Owner: -
--

