CREATE INDEX idx_approval_permissions_vehicle_incidents ON public.approval_permissions USING btree (can_receive_vehicle_incidents) WHERE ((can_receive_vehicle_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_vendor_incidents; Type: INDEX; Schema: public; Owner: -
--

