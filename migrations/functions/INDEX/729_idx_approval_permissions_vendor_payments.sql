CREATE INDEX idx_approval_permissions_vendor_payments ON public.approval_permissions USING btree (can_approve_vendor_payments) WHERE ((can_approve_vendor_payments = true) AND (is_active = true));


--
-- Name: idx_approver_branch_access_active; Type: INDEX; Schema: public; Owner: -
--

