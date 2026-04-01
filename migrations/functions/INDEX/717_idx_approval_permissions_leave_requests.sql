CREATE INDEX idx_approval_permissions_leave_requests ON public.approval_permissions USING btree (can_approve_leave_requests) WHERE ((can_approve_leave_requests = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_maintenance_incidents; Type: INDEX; Schema: public; Owner: -
--

