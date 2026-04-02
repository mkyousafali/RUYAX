CREATE TABLE public.hr_checklists (
    id character varying(20) DEFAULT ('CL'::text || nextval('public.hr_checklists_id_seq'::regclass)) NOT NULL,
    checklist_name_en text,
    checklist_name_ar text,
    question_ids jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: hr_departments; Type: TABLE; Schema: public; Owner: -
--

