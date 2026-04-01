CREATE INDEX idx_hr_employees_employee_id_branch_id ON public.hr_employees USING btree (employee_id, branch_id);


--
-- Name: idx_hr_employees_updated_at; Type: INDEX; Schema: public; Owner: -
--

