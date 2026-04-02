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
-- Name: wa_broadcast_recipients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wa_broadcast_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    broadcast_id uuid,
    customer_id uuid,
    phone_number character varying(20) NOT NULL,
    customer_name text,
    whatsapp_message_id text,
    status character varying(20) DEFAULT 'pending'::character varying,
    error_details text,
    sent_at timestamp with time zone
);

ALTER TABLE ONLY public.wa_broadcast_recipients REPLICA IDENTITY FULL;


--
-- Name: wa_broadcast_recipients wa_broadcast_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_pkey PRIMARY KEY (id);


--
-- Name: idx_wa_broadcast_recip_broadcast; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_broadcast_recip_broadcast ON public.wa_broadcast_recipients USING btree (broadcast_id);


--
-- Name: idx_wa_broadcast_recip_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wa_broadcast_recip_status ON public.wa_broadcast_recipients USING btree (status);


--
-- Name: wa_broadcast_recipients wa_broadcast_recipients_broadcast_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_broadcast_id_fkey FOREIGN KEY (broadcast_id) REFERENCES public.wa_broadcasts(id) ON DELETE CASCADE;


--
-- Name: wa_broadcast_recipients wa_broadcast_recipients_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wa_broadcast_recipients
    ADD CONSTRAINT wa_broadcast_recipients_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: wa_broadcast_recipients Allow all access to wa_broadcast_recipients; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to wa_broadcast_recipients" ON public.wa_broadcast_recipients USING (true) WITH CHECK (true);


--
-- Name: wa_broadcast_recipients; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wa_broadcast_recipients ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE wa_broadcast_recipients; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.wa_broadcast_recipients TO anon;
GRANT ALL ON TABLE public.wa_broadcast_recipients TO authenticated;
GRANT ALL ON TABLE public.wa_broadcast_recipients TO service_role;
GRANT SELECT ON TABLE public.wa_broadcast_recipients TO replication_user;


--
-- PostgreSQL database dump complete
--

