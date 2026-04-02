CREATE INDEX idx_wa_conversations_last_msg ON public.wa_conversations USING btree (last_message_at DESC);


--
-- Name: idx_wa_conversations_phone; Type: INDEX; Schema: public; Owner: -
--

