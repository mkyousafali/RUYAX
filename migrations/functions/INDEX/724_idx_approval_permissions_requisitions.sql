CREATE INDEX idx_approval_permissions_requisitions ON public.approval_permissions USING btree (can_approve_requisitions) WHERE ((can_approve_requisitions = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_single_bill; Type: INDEX; Schema: public; Owner: -
--

