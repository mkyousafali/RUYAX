CREATE INDEX idx_receiving_records_warehouse_handler_user_ids ON public.receiving_records USING gin (warehouse_handler_user_ids);


--
-- Name: idx_receiving_task_templates_priority; Type: INDEX; Schema: public; Owner: -
--

