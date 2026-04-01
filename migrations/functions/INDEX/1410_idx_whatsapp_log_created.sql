CREATE INDEX idx_whatsapp_log_created ON public.whatsapp_message_log USING btree (created_at DESC);


--
-- Name: idx_whatsapp_log_phone; Type: INDEX; Schema: public; Owner: -
--

