CREATE INDEX idx_vendor_payment_schedule_pri_ref ON public.vendor_payment_schedule USING btree (pri_reference_number) WHERE (pri_reference_number IS NOT NULL);


--
-- Name: idx_vendor_payment_schedule_receiving_record_id; Type: INDEX; Schema: public; Owner: -
--

