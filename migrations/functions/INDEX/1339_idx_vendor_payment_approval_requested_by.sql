CREATE INDEX idx_vendor_payment_approval_requested_by ON public.vendor_payment_schedule USING btree (approval_requested_by);


--
-- Name: idx_vendor_payment_approval_status; Type: INDEX; Schema: public; Owner: -
--

