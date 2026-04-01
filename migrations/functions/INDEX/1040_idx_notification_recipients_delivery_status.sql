CREATE INDEX idx_notification_recipients_delivery_status ON public.notification_recipients USING btree (delivery_status) WHERE ((delivery_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('failed'::character varying)::text]));


--
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: -
--

