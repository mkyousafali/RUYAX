CREATE INDEX idx_non_approved_scheduler_created_at ON public.non_approved_payment_scheduler USING btree (created_at DESC);


--
-- Name: idx_non_approved_scheduler_created_by; Type: INDEX; Schema: public; Owner: -
--

