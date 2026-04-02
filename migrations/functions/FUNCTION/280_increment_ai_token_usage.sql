CREATE FUNCTION public.increment_ai_token_usage(config_id uuid, p_tokens integer, p_prompt integer, p_completion integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  UPDATE wa_ai_bot_config SET
    tokens_used = COALESCE(tokens_used, 0) + p_tokens,
    prompt_tokens_used = COALESCE(prompt_tokens_used, 0) + p_prompt,
    completion_tokens_used = COALESCE(completion_tokens_used, 0) + p_completion,
    total_requests = COALESCE(total_requests, 0) + 1
  WHERE id = config_id;
END;
$$;


--
-- Name: increment_flyer_template_usage(); Type: FUNCTION; Schema: public; Owner: -
--

