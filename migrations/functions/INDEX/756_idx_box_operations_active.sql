CREATE INDEX idx_box_operations_active ON public.box_operations USING btree (branch_id, status) WHERE ((status)::text = 'in_use'::text);


--
-- Name: idx_box_operations_box; Type: INDEX; Schema: public; Owner: -
--

