CREATE INDEX idx_approval_permissions_single_bill ON public.approval_permissions USING btree (can_approve_single_bill) WHERE ((can_approve_single_bill = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_user_id; Type: INDEX; Schema: public; Owner: -
--

