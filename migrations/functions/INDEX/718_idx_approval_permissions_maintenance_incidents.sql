CREATE INDEX idx_approval_permissions_maintenance_incidents ON public.approval_permissions USING btree (can_receive_maintenance_incidents) WHERE ((can_receive_maintenance_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_multiple_bill; Type: INDEX; Schema: public; Owner: -
--

