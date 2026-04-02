CREATE INDEX idx_receiving_records_vat_numbers_match ON public.receiving_records USING btree (vat_numbers_match);


--
-- Name: idx_receiving_records_vendor_id; Type: INDEX; Schema: public; Owner: -
--

