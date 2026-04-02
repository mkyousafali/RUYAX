--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: wa_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid,
    wa_account_id uuid,
    whatsapp_message_id text,
    direction character varying(10) DEFAULT 'outbound'::character varying NOT NULL,
    message_type character varying(20) DEFAULT 'text'::character varying,
    content text,
    media_url text,
    media_mime_type character varying(50),
    template_name character varying(100),
    template_language character varying(10),
    status character varying(20) DEFAULT 'sent'::character varying,
    sent_by character varying(20) DEFAULT 'user'::character varying,
    sent_by_user_id uuid,
    error_details text,
    created_at timestamp with time zone DEFAULT now(),
    delivered_at timestamp with time zone,
    read_at timestamp with time zone,
    metadata jsonb
);


--
-- Name: wa_messages wa_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_pkey PRIMARY KEY (id);


--
-- Name: idx_wa_messages_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_messages_account ON public.wa_messages USING btree (wa_account_id);


--
-- Name: idx_wa_messages_conv_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_messages_conv_created ON public.wa_messages USING btree (conversation_id, created_at DESC);


--
-- Name: idx_wa_messages_conversation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_messages_conversation ON public.wa_messages USING btree (conversation_id);


--
-- Name: idx_wa_messages_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_messages_created ON public.wa_messages USING btree (created_at DESC);


--
-- Name: idx_wa_messages_direction; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_messages_direction ON public.wa_messages USING btree (direction);


--
-- Name: idx_wa_messages_wa_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_messages_wa_id ON public.wa_messages USING btree (whatsapp_message_id);


--
-- Name: wa_messages wa_messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.wa_conversations(id) ON DELETE CASCADE;


--
-- Name: wa_messages wa_messages_wa_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_messages
    ADD CONSTRAINT wa_messages_wa_account_id_fkey FOREIGN KEY (wa_account_id) REFERENCES public.wa_accounts(id) ON DELETE CASCADE;


--
-- Name: wa_messages Service role full access on wa_messages; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on wa_messages" ON public.wa_messages USING (true) WITH CHECK (true);


--
-- Name: wa_messages realtime_wa_messages_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY realtime_wa_messages_select ON public.wa_messages FOR SELECT TO authenticated, anon USING (true);


--
-- Name: wa_messages; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_messages ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_messages; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_messages TO anon;
GRANT ALL ON TABLE public.wa_messages TO authenticated;
GRANT ALL ON TABLE public.wa_messages TO service_role;
GRANT SELECT ON TABLE public.wa_messages TO replication_user;


--
-- PostgreSQL database dump complete
--

