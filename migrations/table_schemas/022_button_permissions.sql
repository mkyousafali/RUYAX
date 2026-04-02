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
-- Name: button_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.button_permissions (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    button_id bigint NOT NULL,
    is_enabled boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: button_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.button_permissions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: button_permissions button_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT button_permissions_pkey PRIMARY KEY (id);


--
-- Name: button_permissions button_permissions_user_id_button_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT button_permissions_user_id_button_id_key UNIQUE (user_id, button_id);


--
-- Name: idx_button_permissions_button; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_button_permissions_button ON public.button_permissions USING btree (button_id);


--
-- Name: idx_button_permissions_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_button_permissions_user ON public.button_permissions USING btree (user_id);


--
-- Name: button_permissions fk_button; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT fk_button FOREIGN KEY (button_id) REFERENCES public.sidebar_buttons(id) ON DELETE CASCADE;


--
-- Name: button_permissions fk_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.button_permissions
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: button_permissions allow_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_delete ON public.button_permissions FOR DELETE USING (true);


--
-- Name: button_permissions allow_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_insert ON public.button_permissions FOR INSERT WITH CHECK (true);


--
-- Name: button_permissions allow_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_select ON public.button_permissions FOR SELECT USING (true);


--
-- Name: button_permissions allow_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY allow_update ON public.button_permissions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: button_permissions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.button_permissions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE button_permissions; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.button_permissions TO anon;
GRANT SELECT ON TABLE public.button_permissions TO authenticated;
GRANT ALL ON TABLE public.button_permissions TO service_role;
GRANT SELECT ON TABLE public.button_permissions TO replication_user;


--
-- Name: SEQUENCE button_permissions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.button_permissions_id_seq TO service_role;
GRANT SELECT,USAGE ON SEQUENCE public.button_permissions_id_seq TO anon;
GRANT SELECT,USAGE ON SEQUENCE public.button_permissions_id_seq TO authenticated;
GRANT SELECT ON SEQUENCE public.button_permissions_id_seq TO replication_user;


--
-- PostgreSQL database dump complete
--

