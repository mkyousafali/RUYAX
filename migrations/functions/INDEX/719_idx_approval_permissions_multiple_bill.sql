CREATE INDEX idx_approval_permissions_multiple_bill ON public.approval_permissions USING btree (can_approve_multiple_bill) WHERE ((can_approve_multiple_bill = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_other_incidents; Type: INDEX; Schema: public; Owner: -
--

