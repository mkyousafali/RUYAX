CREATE INDEX idx_flyer_templates_is_default ON public.flyer_templates USING btree (is_default) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: idx_flyer_templates_tags; Type: INDEX; Schema: public; Owner: -
--

