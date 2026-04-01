CREATE INDEX idx_hr_employee_master_employee_mapping ON public.hr_employee_master USING gin (employee_id_mapping);


--
-- Name: idx_hr_employee_master_health_card_expiry_date; Type: INDEX; Schema: public; Owner: -
--

