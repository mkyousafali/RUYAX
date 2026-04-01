CREATE INDEX idx_employee_checklist_assignments_deleted_at ON public.employee_checklist_assignments USING btree (deleted_at);


--
-- Name: idx_employee_checklist_assignments_employee_id; Type: INDEX; Schema: public; Owner: -
--

