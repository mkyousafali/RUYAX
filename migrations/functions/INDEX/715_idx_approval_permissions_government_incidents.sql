CREATE INDEX idx_approval_permissions_government_incidents ON public.approval_permissions USING btree (can_receive_government_incidents) WHERE ((can_receive_government_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_is_active; Type: INDEX; Schema: public; Owner: -
--

