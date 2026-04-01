CREATE INDEX idx_vendor_payment_schedule_adjustments ON public.vendor_payment_schedule USING btree (last_adjustment_date) WHERE (last_adjustment_date IS NOT NULL);


--
-- Name: idx_vendor_payment_schedule_branch_id; Type: INDEX; Schema: public; Owner: -
--

