CREATE INDEX idx_branches_vat_number ON public.branches USING btree (vat_number) WHERE (vat_number IS NOT NULL);


--
-- Name: idx_break_register_employee; Type: INDEX; Schema: public; Owner: -
--

