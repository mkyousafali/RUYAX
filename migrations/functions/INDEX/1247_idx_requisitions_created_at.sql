CREATE INDEX idx_requisitions_created_at ON public.expense_requisitions USING btree (created_at DESC);


--
-- Name: idx_requisitions_number; Type: INDEX; Schema: public; Owner: -
--

