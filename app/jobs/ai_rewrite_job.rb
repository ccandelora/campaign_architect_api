class AiRewriteJob < ApplicationJob
  queue_as :default

  def perform(campaign_id, text, intent, node_type, job_id)
    campaign = Campaign.find(campaign_id)
    background_job = campaign.background_jobs.find_by(job_id: job_id)

    return unless background_job

    begin
      background_job.update!(status: 'processing')

      # Build the prompt based on intent and brand
      prompt = build_rewrite_prompt(campaign.brand, text, intent, node_type)

      # Call OpenAI API
      client = OpenAI::Client.new(access_token: Rails.application.credentials.openai_api_key)

      response = client.chat(
        parameters: {
          model: "gpt-4",
          messages: [{ role: "user", content: prompt }],
          max_tokens: 500,
          temperature: 0.7
        }
      )

      result = JSON.parse(response.dig("choices", 0, "message", "content"))

      background_job.update!(
        status: 'completed',
        result: {
          original_text: text,
          intent: intent,
          suggestions: result['suggestions'] || [],
          rewritten_text: result['rewritten_text']
        }
      )

    rescue => e
      background_job.update!(
        status: 'failed',
        result: { error: e.message }
      )
    end
  end

  private

  def build_rewrite_prompt(brand, text, intent, node_type)
    brand_voice = case brand
    when 'everclear'
      "empathetic, insightful, trustworthy, and slightly mystical, but never cheesy. We empower users to find their own clarity. Avoid overly transactional or aggressive sales language."
    when 'phrendly'
      "playful, flirty, fun, and social. We help people connect and have engaging conversations. Use warm, inviting language that encourages interaction."
    end

    case intent
    when 'improve'
      prompt = "You are an expert copywriter for #{brand.capitalize}, a platform with this brand voice: #{brand_voice}\n\n"
      prompt += "Improve the following #{node_type} copy to be more engaging and effective while maintaining the brand voice:\n\n"
      prompt += "Original: #{text}\n\n"
      prompt += "Provide your response as JSON with this format: {\"rewritten_text\": \"improved version here\"}"

    when 'make_empathetic'
      prompt = "You are an expert copywriter for #{brand.capitalize}. Make the following text more empathetic and understanding:\n\n"
      prompt += "Original: #{text}\n\n"
      prompt += "Provide your response as JSON with this format: {\"rewritten_text\": \"more empathetic version here\"}"

    when 'make_playful'
      prompt = "You are an expert copywriter for #{brand.capitalize}. Make the following text more playful and fun:\n\n"
      prompt += "Original: #{text}\n\n"
      prompt += "Provide your response as JSON with this format: {\"rewritten_text\": \"more playful version here\"}"

    when 'shorten'
      prompt = "You are an expert copywriter. Make the following text more concise while keeping the key message:\n\n"
      prompt += "Original: #{text}\n\n"
      prompt += "Provide your response as JSON with this format: {\"rewritten_text\": \"shorter version here\"}"

    when 'lengthen'
      prompt = "You are an expert copywriter for #{brand.capitalize}. Expand the following text with more detail and persuasive elements:\n\n"
      prompt += "Original: #{text}\n\n"
      prompt += "Provide your response as JSON with this format: {\"rewritten_text\": \"longer version here\"}"

    when 'suggest_headlines'
      prompt = "You are an expert copywriter for #{brand.capitalize}, a platform with this brand voice: #{brand_voice}\n\n"
      prompt += "Create 5 alternative headlines/subject lines for this content:\n\n"
      prompt += "Original: #{text}\n\n"
      prompt += "Provide your response as JSON with this format: {\"suggestions\": [\"headline 1\", \"headline 2\", \"headline 3\", \"headline 4\", \"headline 5\"]}"
    end

    prompt
  end
end
