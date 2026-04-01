CREATE INDEX idx_lrlp_contract_dates ON public.lease_rent_lease_parties USING btree (contract_start_date, contract_end_date);


--
-- Name: idx_lrlp_payment_mode; Type: INDEX; Schema: public; Owner: -
--

