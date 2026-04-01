CREATE INDEX idx_lrrp_contract_dates ON public.lease_rent_rent_parties USING btree (contract_start_date, contract_end_date);


--
-- Name: idx_lrrp_payment_mode; Type: INDEX; Schema: public; Owner: -
--

