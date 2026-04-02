CREATE INDEX idx_approval_permissions_vendor_incidents ON public.approval_permissions USING btree (can_receive_vendor_incidents) WHERE ((can_receive_vendor_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_vendor_payments; Type: INDEX; Schema: public; Owner: -
--

