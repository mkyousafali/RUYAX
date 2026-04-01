CREATE INDEX idx_view_offer_datetime ON public.view_offer USING btree (start_date, start_time, end_date, end_time);


--
-- Name: idx_wa_auto_reply_account; Type: INDEX; Schema: public; Owner: -
--

