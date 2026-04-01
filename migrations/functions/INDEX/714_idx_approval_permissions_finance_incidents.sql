CREATE INDEX idx_approval_permissions_finance_incidents ON public.approval_permissions USING btree (can_receive_finance_incidents) WHERE ((can_receive_finance_incidents = true) AND (is_active = true));


--
-- Name: idx_approval_permissions_government_incidents; Type: INDEX; Schema: public; Owner: -
--

