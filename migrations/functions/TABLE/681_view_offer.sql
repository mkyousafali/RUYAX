CREATE TABLE public.view_offer (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_name character varying(255) NOT NULL,
    branch_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    file_url text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    start_time time without time zone DEFAULT '00:00:00'::time without time zone,
    end_time time without time zone DEFAULT '23:59:00'::time without time zone,
    thumbnail_url text,
    view_button_count integer DEFAULT 0,
    page_visit_count integer DEFAULT 0
);


--
-- Name: wa_accounts; Type: TABLE; Schema: public; Owner: -
--

