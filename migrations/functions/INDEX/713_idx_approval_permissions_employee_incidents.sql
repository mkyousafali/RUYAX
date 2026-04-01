CREATE INDEX idx_approval_permissions_employee_incidents ON public.approval_permissions USING btree (can_receive_employee_incidents) WHERE ((can_receive_employee_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_finance_incidents; Type: INDEX; Schema: public; Owner: -
--

