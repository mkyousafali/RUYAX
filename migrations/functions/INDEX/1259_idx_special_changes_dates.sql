CREATE INDEX idx_special_changes_dates ON public.lease_rent_special_changes USING btree (effective_from, effective_until);


--
-- Name: idx_special_changes_party; Type: INDEX; Schema: public; Owner: -
--

