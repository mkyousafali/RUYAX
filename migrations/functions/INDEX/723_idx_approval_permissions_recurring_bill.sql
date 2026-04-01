CREATE INDEX idx_approval_permissions_recurring_bill ON public.approval_permissions USING btree (can_approve_recurring_bill) WHERE ((can_approve_recurring_bill = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_requisitions; Type: INDEX; Schema: public; Owner: -
--

