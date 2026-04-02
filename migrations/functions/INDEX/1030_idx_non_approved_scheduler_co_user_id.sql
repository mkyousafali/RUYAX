CREATE INDEX idx_non_approved_scheduler_co_user_id ON public.non_approved_payment_scheduler USING btree (co_user_id) WHERE (co_user_id IS NOT NULL);


--
-- Name: idx_non_approved_scheduler_created_at; Type: INDEX; Schema: public; Owner: -
--

