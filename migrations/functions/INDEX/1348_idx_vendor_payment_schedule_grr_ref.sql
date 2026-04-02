CREATE INDEX idx_vendor_payment_schedule_grr_ref ON public.vendor_payment_schedule USING btree (grr_reference_number) WHERE (grr_reference_number IS NOT NULL);


--
-- Name: idx_vendor_payment_schedule_is_paid; Type: INDEX; Schema: public; Owner: -
--

