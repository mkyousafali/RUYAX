CREATE INDEX idx_employee_checklist_assignments_checklist_id ON public.employee_checklist_assignments USING btree (checklist_id);


--
-- Name: idx_employee_checklist_assignments_deleted_at; Type: INDEX; Schema: public; Owner: -
--

