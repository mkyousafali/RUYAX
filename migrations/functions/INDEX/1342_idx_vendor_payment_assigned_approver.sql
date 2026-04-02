CREATE INDEX idx_vendor_payment_assigned_approver ON public.vendor_payment_schedule USING btree (assigned_approver_id);


--
-- Name: idx_vendor_payment_schedule_accountant_user_id; Type: INDEX; Schema: public; Owner: -
--

