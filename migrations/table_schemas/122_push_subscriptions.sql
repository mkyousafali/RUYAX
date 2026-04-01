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
-- Name: push_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.push_subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    subscription jsonb NOT NULL,
    endpoint text NOT NULL,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    failed_deliveries integer DEFAULT 0,
    is_active boolean DEFAULT true,
    customer_id uuid,
    CONSTRAINT chk_push_sub_user_or_customer CHECK (((user_id IS NOT NULL) OR (customer_id IS NOT NULL)))
);


--
-- Name: TABLE push_subscriptions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.push_subscriptions IS 'Stores web push notification subscriptions for users';


--
-- Name: COLUMN push_subscriptions.subscription; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.push_subscriptions.subscription IS 'Full PushSubscription object in JSON format';


--
-- Name: COLUMN push_subscriptions.endpoint; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.push_subscriptions.endpoint IS 'Push service endpoint URL for deduplication';


--
-- Name: COLUMN push_subscriptions.failed_deliveries; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.push_subscriptions.failed_deliveries IS 'Count of consecutive failed push attempts';


--
-- Name: COLUMN push_subscriptions.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.push_subscriptions.is_active IS 'Whether this subscription is active and should receive pushes';


--
-- Name: push_subscriptions push_subscriptions_endpoint_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT push_subscriptions_endpoint_key UNIQUE (endpoint);


--
-- Name: push_subscriptions push_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT push_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: idx_push_subscriptions_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_push_subscriptions_active ON public.push_subscriptions USING btree (user_id, is_active) WHERE (is_active = true);


--
-- Name: idx_push_subscriptions_customer_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_push_subscriptions_customer_active ON public.push_subscriptions USING btree (customer_id, is_active) WHERE ((is_active = true) AND (customer_id IS NOT NULL));


--
-- Name: idx_push_subscriptions_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_push_subscriptions_customer_id ON public.push_subscriptions USING btree (customer_id) WHERE (customer_id IS NOT NULL);


--
-- Name: idx_push_subscriptions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_push_subscriptions_user_id ON public.push_subscriptions USING btree (user_id);


--
-- Name: push_subscriptions set_push_subscriptions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_push_subscriptions_updated_at BEFORE UPDATE ON public.push_subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_push_subscriptions_updated_at();


--
-- Name: push_subscriptions fk_push_sub_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_subscriptions
    ADD CONSTRAINT fk_push_sub_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: push_subscriptions Allow all access to push_subscriptions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to push_subscriptions" ON public.push_subscriptions USING (true) WITH CHECK (true);


--
-- Name: push_subscriptions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.push_subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE push_subscriptions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.push_subscriptions TO anon;
GRANT ALL ON TABLE public.push_subscriptions TO authenticated;
GRANT ALL ON TABLE public.push_subscriptions TO service_role;
GRANT SELECT ON TABLE public.push_subscriptions TO replication_user;


--
-- PostgreSQL database dump complete
--

