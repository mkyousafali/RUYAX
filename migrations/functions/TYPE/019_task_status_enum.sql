CREATE TYPE public.task_status_enum AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'overdue',
    'cancelled',
    'rejected',
    'approved'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

