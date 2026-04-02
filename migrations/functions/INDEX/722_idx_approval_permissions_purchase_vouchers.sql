CREATE INDEX idx_approval_permissions_purchase_vouchers ON public.approval_permissions USING btree (can_approve_purchase_vouchers) WHERE ((can_approve_purchase_vouchers = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_recurring_bill; Type: INDEX; Schema: public; Owner: -
--

