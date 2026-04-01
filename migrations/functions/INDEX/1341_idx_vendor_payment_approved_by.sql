CREATE INDEX idx_vendor_payment_approved_by ON public.vendor_payment_schedule USING btree (approved_by);


--
-- Name: idx_vendor_payment_assigned_approver; Type: INDEX; Schema: public; Owner: -
--

