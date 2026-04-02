CREATE INDEX idx_analysed_att_emp_date ON public.hr_analysed_attendance_data USING btree (employee_id, shift_date);


--
-- Name: idx_analysed_att_employee_id; Type: INDEX; Schema: public; Owner: -
--

