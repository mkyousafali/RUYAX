CREATE INDEX idx_approval_permissions_pos_incidents ON public.approval_permissions USING btree (can_receive_pos_incidents) WHERE ((can_receive_pos_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_purchase_vouchers; Type: INDEX; Schema: public; Owner: -
--

