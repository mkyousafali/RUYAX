CREATE INDEX idx_receiving_records_expired_vendor_document_number ON public.receiving_records USING btree (expired_vendor_document_number);


--
-- Name: idx_receiving_records_final_bill_amount; Type: INDEX; Schema: public; Owner: -
--

