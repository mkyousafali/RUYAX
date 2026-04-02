CREATE INDEX idx_approval_permissions_other_incidents ON public.approval_permissions USING btree (can_receive_other_incidents) WHERE ((can_receive_other_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_pos_incidents; Type: INDEX; Schema: public; Owner: -
--

