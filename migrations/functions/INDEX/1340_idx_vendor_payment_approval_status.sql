CREATE INDEX idx_vendor_payment_approval_status ON public.vendor_payment_schedule USING btree (approval_status) WHERE (approval_status = 'sent_for_approval'::text);


--
-- Name: idx_vendor_payment_approved_by; Type: INDEX; Schema: public; Owner: -
--

