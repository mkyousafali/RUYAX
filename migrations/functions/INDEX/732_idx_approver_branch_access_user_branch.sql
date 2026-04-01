CREATE INDEX idx_approver_branch_access_user_branch ON public.approver_branch_access USING btree (user_id, branch_id);


--
-- Name: idx_approver_branch_access_user_id; Type: INDEX; Schema: public; Owner: -
--

