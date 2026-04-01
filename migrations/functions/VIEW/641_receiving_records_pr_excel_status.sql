CREATE VIEW public.receiving_records_pr_excel_status AS
 SELECT rr.id,
    rr.bill_number,
    rr.vendor_id,
    v.vendor_name,
    rr.pr_excel_file_url,
        CASE
            WHEN (rr.pr_excel_file_url IS NOT NULL) THEN 'Uploaded'::text
            ELSE 'Not Uploaded'::text
        END AS pr_excel_status,
    rr.updated_at
   FROM (public.receiving_records rr
     LEFT JOIN public.vendors v ON ((v.erp_vendor_id = rr.vendor_id)))
  ORDER BY rr.updated_at DESC;


--
-- Name: VIEW receiving_records_pr_excel_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.receiving_records_pr_excel_status IS 'Simple view showing only PR Excel upload status for receiving records';


--
-- Name: receiving_task_templates; Type: TABLE; Schema: public; Owner: -
--

