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

--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

INSERT INTO public.branches VALUES (2, 'Ali Hassan bin Mohammed Sahli ', 'تموينات علي حسن بن محمد سهلي للتجارة', 'Ahad al Masarah', 'أحد المسارحة', true, false, '2025-09-24 13:52:36.726278+00', '2025-12-01 21:33:26.075523+00', NULL, NULL, '310338463100003', false, false, 15.00, true, NULL, NULL, 'التوصيل متاح على مدار الساعة', 'Delivery available 24/7', true, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.branches VALUES (1, 'Urban Market (01)', 'ايربن ماركت (01)', 'Abu Arish', 'أبو عريش', true, true, '2025-09-24 13:52:36.726278+00', '2026-02-22 01:14:18.707347+00', NULL, NULL, '310338463100003', false, true, 15.00, false, '16:47:00', '23:47:00', 'التوصيل متاح على مدار الساعة', 'Delivery available ', false, '08:56:00', '01:56:00', true, NULL, NULL, 'https://www.google.com/maps/dir//%D8%A3%D8%B3%D9%88%D8%A7%D9%82+%D8%A7%D9%8A%D8%B1%D8%A8%D9%86+%D9%85%D8%A7%D8%B1%D9%83%D8%AA,+King+Abdullah+Rd,+Abu+Arish+84526%E2%80%AD/@17.0105822,43.0097713,2889m/data=!3m1!1e3!4m8!4m7!1m0!1m5!1m1!1s0x1607f5dec7aec603:0xe4d3502e2a8326a5!2m2!1d42.829053!2d16.9395332!5m1!1e2?entry=ttu&g_ep=EgoyMDI2MDIxNi4wIKXMDSoASAFQAw%3D%3D', 16.9395332, 42.829053);
INSERT INTO public.branches VALUES (3, 'Urban Market (02)', 'ايربن ماركت (02)', 'Al-Aridhah', 'العارضة', true, false, '2025-09-24 13:52:36.726278+00', '2026-02-22 15:00:45.732185+00', NULL, NULL, '310338463100003', true, false, 15.00, true, NULL, NULL, 'التوصيل متاح على مدار الساعة', 'Delivery available 24/7', false, '08:11:00', '23:11:00', true, NULL, NULL, 'https://www.google.com/maps/dir//%D8%A7%D9%8A%D8%B1%D8%A8%D9%86+%D9%85%D8%A7%D8%B1%D9%83%D8%AA,+Al+Aridhah+83311/@17.0105822,43.0097713', 17.0109393, 43.0018582);
INSERT INTO public.branches VALUES (14, 'Urban Market (03)', 'ايربن ماركت (03)', 'Al Jaraba', 'الجربه', true, false, '2025-12-21 23:53:22.673779+00', '2026-02-19 21:14:57.719165+00', NULL, NULL, '310338463100003', false, false, 15.00, true, NULL, NULL, NULL, NULL, true, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.branches VALUES (5, 'IPSO(ايبسو)', 'ايبسو', 'Abu Arish', 'أبو عريش', false, false, '2025-10-30 09:40:08.56693+00', '2026-02-23 02:25:41.493326+00', NULL, NULL, '310338463100003', false, false, 15.00, true, NULL, NULL, 'التوصيل متاح على مدار الساعة', 'Delivery available 24/7', true, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL);


--
-- Name: branches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: supabase_admin
--

SELECT pg_catalog.setval('public.branches_id_seq', 14, true);


--
-- PostgreSQL database dump complete
--

