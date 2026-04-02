CREATE INDEX idx_campaigns_validity ON public.coupon_campaigns USING btree (validity_start_date, validity_end_date);


--
-- Name: idx_checklist_operations_submission_type_en; Type: INDEX; Schema: public; Owner: -
--

