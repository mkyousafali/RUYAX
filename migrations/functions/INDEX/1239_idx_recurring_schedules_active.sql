CREATE INDEX idx_recurring_schedules_active ON public.recurring_assignment_schedules USING btree (is_active, repeat_type);


--
-- Name: idx_recurring_schedules_assignment_id; Type: INDEX; Schema: public; Owner: -
--

