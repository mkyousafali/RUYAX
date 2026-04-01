CREATE INDEX idx_approval_permissions_customer_incidents ON public.approval_permissions USING btree (can_receive_customer_incidents) WHERE ((can_receive_customer_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_employee_incidents; Type: INDEX; Schema: public; Owner: -
--

