CREATE TABLE public.day_off_weekday (
    id text NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT day_off_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);


--
-- Name: default_incident_users; Type: TABLE; Schema: public; Owner: -
--

