CREATE INDEX idx_recurring_schedules_next_execution ON public.recurring_assignment_schedules USING btree (next_execution_at, is_active) WHERE (is_active = true);


--
-- Name: idx_regular_shift_created_at; Type: INDEX; Schema: public; Owner: -
--

