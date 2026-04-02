CREATE INDEX idx_task_assignments_overdue ON public.task_assignments USING btree (deadline_datetime, status) WHERE ((deadline_datetime IS NOT NULL) AND (status <> ALL (ARRAY['completed'::text, 'cancelled'::text])));


--
-- Name: idx_task_assignments_reassignable; Type: INDEX; Schema: public; Owner: -
--

