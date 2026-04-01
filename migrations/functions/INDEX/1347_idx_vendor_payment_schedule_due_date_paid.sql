CREATE INDEX idx_vendor_payment_schedule_due_date_paid ON public.vendor_payment_schedule USING btree (due_date, is_paid);


--
-- Name: idx_vendor_payment_schedule_grr_ref; Type: INDEX; Schema: public; Owner: -
--

