CREATE INDEX idx_approval_permissions_add_missing_punches ON public.approval_permissions USING btree (can_add_missing_punches) WHERE ((can_add_missing_punches = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_customer_incidents; Type: INDEX; Schema: public; Owner: -
--

