CREATE FUNCTION public.increment_social_link_click(_branch_id bigint, _platform text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_count BIGINT;
BEGIN
  IF _platform = 'facebook' THEN
    UPDATE social_links SET facebook_clicks = facebook_clicks + 1 WHERE branch_id = _branch_id;
    SELECT facebook_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'whatsapp' THEN
    UPDATE social_links SET whatsapp_clicks = whatsapp_clicks + 1 WHERE branch_id = _branch_id;
    SELECT whatsapp_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'instagram' THEN
    UPDATE social_links SET instagram_clicks = instagram_clicks + 1 WHERE branch_id = _branch_id;
    SELECT instagram_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'tiktok' THEN
    UPDATE social_links SET tiktok_clicks = tiktok_clicks + 1 WHERE branch_id = _branch_id;
    SELECT tiktok_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'snapchat' THEN
    UPDATE social_links SET snapchat_clicks = snapchat_clicks + 1 WHERE branch_id = _branch_id;
    SELECT snapchat_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'website' THEN
    UPDATE social_links SET website_clicks = website_clicks + 1 WHERE branch_id = _branch_id;
    SELECT website_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'location_link' THEN
    UPDATE social_links SET location_link_clicks = location_link_clicks + 1 WHERE branch_id = _branch_id;
    SELECT location_link_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  END IF;

  RETURN json_build_object('branch_id', _branch_id, 'platform', _platform, 'click_count', v_count);
END;
$$;


--
-- Name: increment_view_button_count(uuid); Type: FUNCTION; Schema: public; Owner: -
--

