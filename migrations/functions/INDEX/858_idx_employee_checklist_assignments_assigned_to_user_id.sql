CREATE INDEX idx_employee_checklist_assignments_assigned_to_user_id ON public.employee_checklist_assignments USING btree (assigned_to_user_id);


--
-- Name: idx_employee_checklist_assignments_branch_id; Type: INDEX; Schema: public; Owner: -
--

