CREATE INDEX idx_payments_party ON public.lease_rent_payments USING btree (party_type, party_id);


--
-- Name: idx_payments_party_period; Type: INDEX; Schema: public; Owner: -
--

