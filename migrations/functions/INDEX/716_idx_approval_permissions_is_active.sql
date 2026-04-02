CREATE INDEX idx_approval_permissions_is_active ON public.approval_permissions USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_approval_permissions_leave_requests; Type: INDEX; Schema: public; Owner: -
--

