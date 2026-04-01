CREATE TYPE public.notification_queue_status_enum AS ENUM (
    'pending',
    'processing',
    'sent',
    'failed',
    'retrying',
    'cancelled'
);


--
-- Name: notification_status_enum; Type: TYPE; Schema: public; Owner: -
--

