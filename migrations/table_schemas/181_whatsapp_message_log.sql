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
-- Name: whatsapp_message_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.whatsapp_message_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone_number character varying(20) NOT NULL,
    message_type character varying(50) DEFAULT 'access_code'::character varying NOT NULL,
    template_name character varying(100),
    template_language character varying(10),
    whatsapp_message_id text,
    status character varying(20) DEFAULT 'sent'::character varying,
    customer_name text,
    error_details text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: whatsapp_message_log whatsapp_message_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.whatsapp_message_log
    ADD CONSTRAINT whatsapp_message_log_pkey PRIMARY KEY (id);


--
-- Name: idx_whatsapp_log_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_log_created ON public.whatsapp_message_log USING btree (created_at DESC);


--
-- Name: idx_whatsapp_log_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_whatsapp_log_phone ON public.whatsapp_message_log USING btree (phone_number);


--
-- Name: whatsapp_message_log Service role full access on whatsapp_message_log; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role full access on whatsapp_message_log" ON public.whatsapp_message_log USING (true) WITH CHECK (true);


--
-- Name: whatsapp_message_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.whatsapp_message_log ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE whatsapp_message_log; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT ON TABLE public.whatsapp_message_log TO anon;
GRANT SELECT ON TABLE public.whatsapp_message_log TO authenticated;
GRANT ALL ON TABLE public.whatsapp_message_log TO service_role;
GRANT SELECT ON TABLE public.whatsapp_message_log TO replication_user;


--
-- PostgreSQL database dump complete
--

