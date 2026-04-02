CREATE TABLE public.shelf_paper_fonts (
    name character varying(255) NOT NULL,
    font_url text NOT NULL,
    file_name character varying(255),
    file_size integer,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    id character varying(20) DEFAULT ('F'::text || (nextval('public.shelf_paper_fonts_id_seq'::regclass))::text) NOT NULL,
    original_file_name character varying(500)
);


--
-- Name: shelf_paper_templates; Type: TABLE; Schema: public; Owner: -
--

