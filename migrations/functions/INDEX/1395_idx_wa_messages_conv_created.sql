CREATE INDEX idx_wa_messages_conv_created ON public.wa_messages USING btree (conversation_id, created_at DESC);


--
-- Name: idx_wa_messages_conversation; Type: INDEX; Schema: public; Owner: -
--

