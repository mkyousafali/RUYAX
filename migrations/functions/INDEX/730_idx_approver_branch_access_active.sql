CREATE INDEX idx_approver_branch_access_active ON public.approver_branch_access USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_approver_branch_access_branch_id; Type: INDEX; Schema: public; Owner: -
--

