class OpenaiService
  include HTTParty
  base_uri 'https://api.openai.com/v1'

  def initialize
    api_key = Rails.application.credentials.openai_api_key || ENV['OPENAI_API_KEY']
    @headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{api_key}"
    }
    @api_key_present = api_key.present?
  end

  def marketing_intelligence
    @marketing_intelligence ||= MarketingIntelligenceService.new
  end

  def grade_copy(brand:, node_data:, node_type:)
    # Fallback to mock response if no API key
    unless @api_key_present
      return generate_mock_grading_response(brand, node_data, node_type)
    end

    begin
      prompt = build_copy_grading_prompt(brand, node_data, node_type)

      response = self.class.post('/chat/completions', {
        headers: @headers,
        body: {
          model: 'gpt-3.5-turbo', # Use gpt-3.5-turbo instead of gpt-4 for cost efficiency
          messages: [
            {
              role: 'system',
              content: get_copy_grading_system_prompt
            },
            {
              role: 'user',
              content: prompt
            }
          ],
          temperature: 0.3,
          max_tokens: 1000
        }.to_json
      })

      if response.success?
        content = response.parsed_response.dig('choices', 0, 'message', 'content')
        base_grading = parse_grading_response(content)

        # Enhance with platform-specific intelligence if it's a social node
        if node_data.dig('data', 'platform').present? && %w[facebook instagram tiktok twitter].include?(node_data.dig('data', 'platform'))
          platform_analysis = marketing_intelligence.analyze_platform_content(
            node_data.dig('data', 'platform'),
            node_data,
            brand
          )

          base_grading[:platform_analysis] = platform_analysis
          base_grading[:enhanced_suggestions] = generate_enhanced_copy_suggestions(brand, node_data, node_type)
        end

        base_grading
      else
        Rails.logger.error "OpenAI API Error: #{response.code} - #{response.body}"
        generate_mock_grading_response(brand, node_data, node_type)
      end
    rescue StandardError => e
      Rails.logger.error "OpenAI API Error: #{e.message}"
      generate_mock_grading_response(brand, node_data, node_type)
    end
  end

  def grade_email_copy(email_data, brand = nil, campaign_type = 'newsletter')
    subject_line = email_data.dig('subject') || email_data.dig('subject_line') || ''
    body = email_data.dig('body') || ''
    preview_text = email_data.dig('preview_text') || ''

    prompt = build_email_grading_prompt(subject_line, body, preview_text, brand, campaign_type)

    response = self.class.post('/chat/completions', {
      headers: @headers,
      body: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: get_email_grading_system_prompt
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.3,
        max_tokens: 1200
      }.to_json
    })

    if response.success?
      content = response.parsed_response.dig('choices', 0, 'message', 'content')
      parse_email_grading_response(content, email_data)
    else
      { error: 'Failed to grade email copy' }
    end
  end

  def generate_email_variations(email_data, brand = nil, campaign_type = 'newsletter', variation_type = 'subject_line')
    case variation_type
    when 'subject_line'
      generate_subject_line_variations(email_data.dig('subject') || email_data.dig('subject_line'), brand, campaign_type)
    when 'preview_text'
      generate_preview_text_variations(email_data.dig('preview_text'), email_data.dig('subject'), brand)
    when 'body'
      generate_email_body_variations(email_data.dig('body'), brand, campaign_type)
    when 'cta'
      generate_cta_variations(email_data.dig('body'), brand, campaign_type)
    else
      { error: "Unsupported variation type: #{variation_type}" }
    end
  end

  def optimize_email_for_deliverability(email_content, brand = nil)
    prompt = build_deliverability_optimization_prompt(email_content, brand)

    response = self.class.post('/chat/completions', {
      headers: @headers,
      body: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: get_deliverability_system_prompt
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.2,
        max_tokens: 800
      }.to_json
    })

    if response.success?
      content = response.parsed_response.dig('choices', 0, 'message', 'content')
      parse_deliverability_response(content)
    else
      { error: 'Failed to optimize deliverability' }
    end
  end

  def analyze_funnel(brand:, campaign_structure:)
    prompt = build_funnel_analysis_prompt(brand, campaign_structure)

    response = self.class.post('/chat/completions', {
      headers: @headers,
      body: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: 'You are a marketing funnel optimization expert. Analyze funnels for conversion opportunities, user experience flow, and brand alignment. Focus on practical, actionable insights.'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.4,
        max_tokens: 800
      }.to_json
    })

    if response.success?
      response.parsed_response.dig('choices', 0, 'message', 'content')
    else
      'Unable to analyze funnel at this time.'
    end
  end

  def generate_enhanced_copy_suggestions(brand, node_data, node_type)
    platform = node_data.dig('data', 'platform')
    return [] unless platform

    prompt = build_enhancement_prompt(brand, node_data, node_type, platform)

    response = self.class.post('/chat/completions', {
      headers: @headers,
      body: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: get_copy_enhancement_system_prompt
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.6,
        max_tokens: 600
      }.to_json
    })

    if response.success?
      response.parsed_response.dig('choices', 0, 'message', 'content')
    else
      'Unable to generate enhanced copy suggestions at this time.'
    end
  end

  def optimize_for_platform(brand:, content:, platform:, content_type:)
    prompt = build_platform_optimization_prompt(brand, content, platform, content_type)

    response = self.class.post('/chat/completions', {
      headers: @headers,
      body: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: get_platform_optimization_system_prompt
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.7,
        max_tokens: 1000
      }.to_json
    })

    if response.success?
      content = response.parsed_response.dig('choices', 0, 'message', 'content')
      parse_optimization_response(content)
    else
      { error: 'Failed to optimize for platform' }
    end
  end

  private

  def get_copy_grading_system_prompt
    "You are an expert marketing copy analyst with deep knowledge of conversion optimization, platform-specific best practices, and brand voice alignment.

    Grade marketing copy on a scale of 1-100 based on:
    - Clarity and readability (25%)
    - Persuasiveness and emotional appeal (25%)
    - Brand voice alignment (20%)
    - Platform optimization (15%)
    - Call-to-action effectiveness (15%)

    Always provide specific, actionable feedback and suggestions for improvement."
  end

  def get_email_grading_system_prompt
    "You are an expert email marketing strategist with deep knowledge of deliverability, engagement optimization, and industry best practices from leading sources like Analytify, SendGrid, and Litmus.

    Grade email campaigns based on:
    - Subject line effectiveness (25%)
    - Content quality and structure (25%)
    - Brand voice and personalization (20%)
    - Deliverability factors (15%)
    - Mobile optimization and design (10%)
    - Call-to-action clarity (5%)

    Reference current email marketing best practices including:
    - Character limits and mobile optimization
    - A/B testing opportunities
    - Segmentation potential
    - Automation possibilities
    - GDPR compliance
    - Spam trigger avoidance

    Provide actionable insights for improving open rates, click-through rates, and conversions."
  end

  def get_deliverability_system_prompt
    "You are an email deliverability expert with comprehensive knowledge of:
    - Spam filter algorithms and triggers
    - Sender reputation factors
    - Authentication requirements (SPF, DKIM, DMARC)
    - Content optimization for inbox placement
    - List hygiene best practices
    - Engagement optimization

    Analyze email content and provide specific recommendations to maximize deliverability and avoid spam folders."
  end

  def get_copy_enhancement_system_prompt
    "You are a conversion copywriting expert specializing in platform-specific optimization.

    For each platform and brand, consider:
    - Character limits and formatting constraints
    - Platform algorithm preferences
    - Audience behavior patterns
    - Brand voice consistency
    - Conversion optimization techniques

    Provide enhanced copy versions that maintain authenticity while maximizing platform performance."
  end

  def get_platform_optimization_system_prompt
    "You are an expert marketing strategist optimizing content for maximum platform performance.

    Provide optimization suggestions for:
    - Clarity and readability
    - Persuasiveness and emotional appeal
    - Brand voice alignment
    - Platform-specific best practices
    - Call-to-action effectiveness

    Focus on practical, actionable steps to maximize platform performance."
  end

  def build_copy_grading_prompt(brand, node_data, node_type)
    brand_voice = get_brand_voice(brand)
    target_user = get_target_user(brand)
    platform_context = get_platform_context(node_data)

    case node_type
    when 'email'
      subject = node_data.dig('data', 'subject')
      body = node_data.dig('data', 'body')

      "You are an expert marketing copywriter and brand strategist for #{brand.capitalize}, #{get_brand_description(brand)}.\n\n" +
      "The brand voice of #{brand.capitalize} is: #{brand_voice}\n\n" +
      "The target user for this message is #{target_user}.\n\n" +
      "Analyze the following copy and provide feedback in JSON format. The JSON object must contain two keys: \"score\" (an integer from 1 to 10) and \"feedback\" (an array of strings with specific, actionable suggestions).\n\n" +
      "Consider email marketing best practices: subject line optimization, personalization, clear CTAs, mobile optimization, and deliverability.\n\n" +
      "Here is the copy to analyze:\n" +
      "Subject: #{subject}\n" +
      "Body: #{body}"
    when 'push'
      title = node_data.dig('data', 'title')
      body = node_data.dig('data', 'body')

      "You are an expert marketing copywriter and brand strategist for #{brand.capitalize}, #{get_brand_description(brand)}.\n\n" +
      "The brand voice of #{brand.capitalize} is: #{brand_voice}\n\n" +
      "Analyze the following push notification copy and provide feedback in JSON format. The JSON object must contain two keys: \"score\" (an integer from 1 to 10) and \"feedback\" (an array of strings with specific, actionable suggestions).\n\n" +
      "Consider push notification best practices: brevity, urgency, personalization, timing, and clear value proposition.\n\n" +
      "Here is the push notification to analyze:\n" +
      "Title: #{title}\n" +
      "Body: #{body}"
    when 'social'
      platform = node_data.dig('data', 'platform')
      caption = node_data.dig('data', 'caption') || node_data.dig('data', 'text')

      platform_best_practices = get_platform_best_practices(platform)

      "You are an expert #{platform} marketing strategist for #{brand.capitalize}, #{get_brand_description(brand)}.\n\n" +
      "The brand voice of #{brand.capitalize} is: #{brand_voice}\n\n" +
      "#{platform_context}\n\n" +
      "Platform-specific best practices for #{platform}:\n#{platform_best_practices}\n\n" +
      "Analyze the following #{platform} content and provide feedback in JSON format. The JSON object must contain two keys: \"score\" (an integer from 1 to 10) and \"feedback\" (an array of strings with specific, actionable suggestions).\n\n" +
      "Content: #{caption}\n\n" +
      "Consider character limits, hashtag strategy, engagement tactics, and visual content recommendations."
    when 'ad'
      platform = node_data.dig('data', 'platform')
      headline = node_data.dig('data', 'headline')
      primary_text = node_data.dig('data', 'primary_text')

      "You are an expert #{platform} advertising strategist for #{brand.capitalize}, #{get_brand_description(brand)}.\n\n" +
      "The brand voice of #{brand.capitalize} is: #{brand_voice}\n\n" +
      "#{platform_context}\n\n" +
      "Analyze the following #{platform} ad copy and provide feedback in JSON format. The JSON object must contain two keys: \"score\" (an integer from 1 to 10) and \"feedback\" (an array of strings with specific, actionable suggestions).\n\n" +
      "Headline: #{headline}\n" +
      "Primary Text: #{primary_text}\n\n" +
      "Consider ad performance metrics, conversion optimization, audience targeting, and platform-specific ad formats."
    else
      "Please provide feedback on this #{node_type} content for #{brand.capitalize}."
    end
  end

  def build_funnel_analysis_prompt(brand, campaign_structure)
    business_goals = get_business_goals(brand)
    channels = extract_channels_from_structure(campaign_structure)

    utm_recommendations = @marketing_intelligence.generate_utm_recommendations(
      campaign_structure.dig('name') || 'campaign',
      brand,
      channels
    )

    "You are a marketing funnel expert specializing in #{get_industry_context(brand)}. You are analyzing a campaign for #{brand.capitalize}, #{get_brand_description(brand)}.\n\n" +
    "The business goals are: #{business_goals}\n\n" +
    "Channels being used: #{channels.join(', ')}\n\n" +
    "UTM Tracking Recommendations: #{utm_recommendations[:best_practices].first(3).join('; ')}\n\n" +
    "Analyze the following campaign flow, provided as a JSON object of nodes and edges. Identify critical gaps in the user journey, missed opportunities for engagement, platform-specific optimizations, and suggest specific new nodes (email, push, etc.) to add to improve the campaign's performance against the business goals.\n\n" +
    "Consider modern marketing best practices including:\n" +
    "- Cross-platform consistency and messaging\n" +
    "- Attribution and tracking setup\n" +
    "- Platform-specific content optimization\n" +
    "- User journey personalization\n" +
    "- Performance measurement and optimization\n\n" +
    "Provide your response as a JSON object with the following keys:\n" +
    "- \"suggestions\": array of objects with \"title\" and \"description\"\n" +
    "- \"missing_touchpoints\": array of recommended new nodes to add\n" +
    "- \"optimization_opportunities\": platform-specific improvements\n\n" +
    "Here is the campaign flow:\n" +
    "#{campaign_structure.to_json}"
  end

  def build_enhancement_prompt(brand, node_data, node_type, platform)
    brand_voice = get_brand_voice(brand)
    current_content = extract_content_from_node(node_data)
    platform_best_practices = get_platform_best_practices(platform)

    "You are an expert #{platform} copywriter for #{brand.capitalize}. Your brand voice is: #{brand_voice}\n\n" +
    "Platform best practices for #{platform}:\n#{platform_best_practices}\n\n" +
    "Current content: #{current_content}\n\n" +
    "Create 3 improved versions of this content that:\n" +
    "1. Better align with #{platform} best practices\n" +
    "2. Maintain the #{brand} brand voice\n" +
    "3. Are more engaging and conversion-focused\n\n" +
    "Provide your response as a JSON array of objects, each with 'version' and 'rationale' keys."
  end

  def build_platform_optimization_prompt(brand, content, platform, content_type)
    brand_voice = get_brand_voice(brand)
    platform_best_practices = get_platform_best_practices(platform)

    "You are an expert #{platform} marketing strategist optimizing #{content_type} for #{brand.capitalize}.\n\n" +
    "Brand voice: #{brand_voice}\n\n" +
    "Platform best practices:\n#{platform_best_practices}\n\n" +
    "Original content: #{content}\n\n" +
    "Optimize this content for maximum #{platform} performance. Provide:\n" +
    "1. Optimized version\n" +
    "2. Key improvements made\n" +
    "3. Expected performance impact\n\n" +
    "Response format: JSON with 'optimized_content', 'improvements', and 'expected_impact' keys."
  end

  def build_email_grading_prompt(subject_line, body, preview_text, brand, campaign_type)
    brand_context = get_brand_context(brand)

    "EMAIL CAMPAIGN ANALYSIS
    Campaign Type: #{campaign_type}
    Brand: #{brand}

    SUBJECT LINE: #{subject_line}
    PREVIEW TEXT: #{preview_text}
    BODY CONTENT: #{body}

    #{brand_context}

    Analyze this email against 2025 email marketing best practices and provide a comprehensive grade in JSON format:
    {
      \"overall_score\": <number 1-100>,
      \"breakdown\": {
        \"subject_line\": <score>,
        \"content_quality\": <score>,
        \"brand_personalization\": <score>,
        \"deliverability\": <score>,
        \"mobile_optimization\": <score>,
        \"cta_effectiveness\": <score>
      },
      \"subject_line_analysis\": {
        \"length_optimal\": <boolean>,
        \"has_personalization\": <boolean>,
        \"urgency_level\": \"low/medium/high\",
        \"curiosity_factor\": <score 1-10>,
        \"spam_risk\": \"low/medium/high\"
      },
      \"content_analysis\": {
        \"readability_score\": <score>,
        \"brand_voice_strength\": <score>,
        \"cta_clarity\": <score>,
        \"personalization_level\": <score>
      },
      \"deliverability_factors\": {
        \"spam_triggers\": [\"list of potential triggers\"],
        \"authentication_hints\": [\"recommendations\"],
        \"content_balance\": \"text_to_image_ratio_assessment\"
      },
      \"improvement_suggestions\": [\"specific actionable improvements\"],
      \"ab_testing_opportunities\": [\"elements to test\"],
      \"automation_potential\": \"assessment of automation opportunities\"
    }"
  end

  def get_platform_context(node_data)
    platform = node_data.dig('data', 'platform')
    return "" unless platform

    case platform
    when 'facebook'
      "Facebook prioritizes authentic, engaging content that generates meaningful social interactions. Video content performs 135% better than photos."
    when 'instagram'
      "Instagram is a highly visual platform where aesthetic quality and authenticity drive engagement. Stories and Reels get maximum reach."
    when 'tiktok'
      "TikTok rewards authentic, entertaining content that follows trends. The first 3 seconds are crucial for hook retention."
    when 'twitter'
      "Twitter/X is ideal for real-time conversations, news, and thought leadership. Engagement happens through replies and retweets."
    else
      ""
    end
  end

  def get_platform_best_practices(platform)
    return "" unless platform

    practices = MarketingIntelligenceService::PLATFORM_BEST_PRACTICES[platform.to_sym]
    return "" unless practices

    practices[:best_practices].first(5).map { |practice| "- #{practice}" }.join("\n")
  end

  def extract_campaign_goal(campaign_structure)
    campaign_structure.dig('goal') ||
    campaign_structure.dig('name') ||
    'engagement'
  end

  def extract_channels_from_structure(campaign_structure)
    nodes = campaign_structure.dig('nodes') || []
    channels = nodes.map do |node|
      case node['type']
      when 'email'
        'email'
      when 'push'
        'push'
      when 'social'
        node.dig('data', 'platform') || 'social'
      when 'ad'
        node.dig('data', 'platform') || 'advertising'
      else
        node['type']
      end
    end.compact.uniq

    channels
  end

  def extract_content_from_node(node_data)
    content_fields = %w[subject body title caption text primary_text headline]
    content_pieces = []

    content_fields.each do |field|
      value = node_data.dig('data', field)
      content_pieces << "#{field.capitalize}: #{value}" if value.present?
    end

    content_pieces.join("\n")
  end

  def parse_grading_response(content)
    begin
      JSON.parse(content)
    rescue JSON::ParserError
      {
        overall_score: extract_score_from_text(content),
        analysis: content,
        error: 'Could not parse structured response'
      }
    end
  end

  def parse_email_grading_response(content, email_data)
    begin
      parsed = JSON.parse(content)

      # Add additional context
      parsed['email_data'] = {
        'subject_length' => (email_data.dig('subject') || email_data.dig('subject_line') || '').length,
        'body_word_count' => (email_data.dig('body') || '').split.length,
        'has_preview_text' => email_data.dig('preview_text').present?
      }

      parsed
    rescue JSON::ParserError
      {
        overall_score: extract_score_from_text(content),
        analysis: content,
        email_data: email_data,
        error: 'Could not parse structured response'
      }
    end
  end

  def parse_optimization_response(content)
    begin
      JSON.parse(content)
    rescue JSON::ParserError
      {
        "optimized_content" => "Optimization failed",
        "improvements" => ["Unable to process optimization request"],
        "expected_impact" => "Please try again"
      }
    end
  end

  def parse_deliverability_response(content)
    # Parse deliverability recommendations from AI response
    {
      analysis: content,
      recommendations: extract_recommendations_from_text(content),
      risk_level: assess_risk_level_from_text(content)
    }
  end

  def get_brand_voice(brand)
    case brand
    when 'everclear'
      'empathetic, insightful, trustworthy, and slightly mystical, but never cheesy. We empower users to find their own clarity. Avoid overly transactional or aggressive sales language.'
    when 'phrendly'
      'playful, flirtatious, confident, and social. We create connections through fun interactions. The tone should be engaging and encourage social interaction while maintaining respect.'
    else
      'professional and engaging'
    end
  end

  def get_brand_description(brand)
    case brand
    when 'everclear'
      'a platform where users connect with psychic advisors for guidance on life, love, and career'
    when 'phrendly'
      'a platform where users can chat and flirt by buying and "sipping" virtual drinks. Users can also be "Phrends" who earn money by chatting'
    else
      'a platform'
    end
  end

  def get_target_user(brand)
    case brand
    when 'everclear'
      'a brand new user who just signed up'
    when 'phrendly'
      'a new user looking to connect and have fun conversations'
    else
      'a new user'
    end
  end

  def get_business_goals(brand)
    case brand
    when 'everclear'
      'increase user-to-advisor connection rates, drive first-time reading purchases, and improve user engagement with the platform'
    when 'phrendly'
      'increase user-to-user interaction, drive first-time "drink" purchases, and encourage new "Phrends" to complete their profiles to start earning'
    else
      'improve user engagement and conversion'
    end
  end

  def get_industry_context(brand)
    case brand
    when 'everclear'
      'spiritual guidance and advisor platforms'
    when 'phrendly'
      'two-sided marketplaces and social platforms'
    else
      'digital platforms'
    end
  end

  def get_brand_context(brand)
    case brand
    when 'everclear'
      "BRAND CONTEXT (Everclear): Spiritual guidance platform focusing on psychic readings and life clarity. Voice should be empathetic, mystical yet accessible, trustworthy, and focused on personal growth and insight. Avoid overly commercial language. Emphasize transformation, clarity, and spiritual connection."
    when 'phrendly'
      "BRAND CONTEXT (Phrendly): Social connection platform emphasizing fun, flirtation, and social interaction. Voice should be playful, confident, slightly flirtatious but respectful, engaging, and focused on social connection and entertainment. Emphasize fun, connection, and social experiences."
    else
      "BRAND CONTEXT: Maintain professional, engaging tone that builds trust and drives action."
    end
  end

  def extract_score_from_text(text)
    # Extract numeric score from text response
    score_match = text.match(/(\d+)\/100|\b(\d+)\s*%|\bScore:\s*(\d+)|\b(\d+)\s*out of 100/i)
    if score_match
      score_match.captures.compact.first.to_i
    else
      75 # Default score if none found
    end
  end

  def extract_recommendations_from_text(text)
    # Extract bullet points or numbered recommendations
    recommendations = []

    text.split("\n").each do |line|
      line = line.strip
      if line.match(/^[-•*]\s+/) || line.match(/^\d+\.\s+/)
        recommendations << line.gsub(/^[-•*\d.\s]+/, '').strip
      end
    end

    recommendations.any? ? recommendations : ['Review content for spam triggers', 'Ensure proper authentication', 'Maintain list hygiene']
  end

  def assess_risk_level_from_text(text)
    if text.downcase.include?('high risk') || text.downcase.include?('likely spam')
      'high'
    elsif text.downcase.include?('medium risk') || text.downcase.include?('some concerns')
      'medium'
    else
      'low'
    end
  end

  def generate_subject_line_variations(original_subject, brand, campaign_type)
    brand_context = get_brand_context(brand)

    prompt = "Generate 5 high-performing subject line variations for this email:

    Original: #{original_subject}
    Campaign Type: #{campaign_type}
    #{brand_context}

    Create variations that test different psychological triggers:
    1. Curiosity-driven
    2. Urgency/scarcity
    3. Personalized
    4. Benefit-focused
    5. Question-based

    Keep each under 50 characters for mobile optimization. Avoid spam triggers."

    response = self.class.post('/chat/completions', {
      headers: @headers,
      body: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: 'You are an email marketing expert specializing in high-converting subject lines. Focus on psychology, mobile optimization, and brand alignment.'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.7,
        max_tokens: 400
      }.to_json
    })

    if response.success?
      content = response.parsed_response.dig('choices', 0, 'message', 'content')
      parse_subject_line_variations(content)
    else
      { error: 'Failed to generate subject line variations' }
    end
  end

  def generate_preview_text_variations(original_preview, subject_line, brand)
    brand_context = get_brand_context(brand)

    prompt = "Create 3 preview text variations (under 140 characters) that complement this subject line:

    Subject: #{subject_line}
    Original Preview: #{original_preview}
    #{brand_context}

    Each variation should:
    - Complement, not repeat the subject line
    - Create additional curiosity or value
    - Maintain brand voice
    - Be mobile-optimized"

    response = self.class.post('/chat/completions', {
      headers: @headers,
      body: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: 'You are an email preview text specialist focused on maximizing open rates through compelling preview text that works with subject lines.'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.6,
        max_tokens: 300
      }.to_json
    })

    if response.success?
      content = response.parsed_response.dig('choices', 0, 'message', 'content')
      parse_preview_text_variations(content)
    else
      { error: 'Failed to generate preview text variations' }
    end
  end

  def build_deliverability_optimization_prompt(email_content, brand)
    brand_context = get_brand_context(brand)

    "DELIVERABILITY OPTIMIZATION REQUEST

    Email Content:
    #{email_content}

    #{brand_context}

    Analyze this email for deliverability risks and provide optimization recommendations:
    1. Identify potential spam triggers
    2. Suggest content improvements
    3. Recommend sender reputation best practices
    4. Provide authentication guidance
    5. Suggest list management improvements

    Focus on practical, actionable steps to maximize inbox placement."
  end

  def parse_subject_line_variations(content)
    variations = []

    # Extract variations from the response
    lines = content.split("\n").select { |line| line.match(/^\d+\./) }

    lines.each_with_index do |line, index|
      clean_line = line.gsub(/^\d+\.\s*/, '').strip
      variations << {
        version: (index + 1).to_s,
        subject_line: clean_line,
        type: determine_variation_type(clean_line, index)
      }
    end

    {
      variations: variations,
      original_analysis: content
    }
  end

  def parse_preview_text_variations(content)
    variations = []

    # Extract variations from the response
    lines = content.split("\n").select { |line| line.match(/^\d+\./) }

    lines.each_with_index do |line, index|
      clean_line = line.gsub(/^\d+\.\s*/, '').strip
      variations << {
        version: (index + 1).to_s,
        preview_text: clean_line,
        character_count: clean_line.length
      }
    end

    {
      variations: variations,
      original_analysis: content
    }
  end

  def determine_variation_type(subject_line, index)
    types = ['curiosity', 'urgency', 'personalized', 'benefit', 'question']
    types[index] || 'general'
  end

  def generate_mock_grading_response(brand, node_data, node_type)
    # Generate intelligent mock responses based on content analysis
    content = extract_content_from_node(node_data)

    # Basic scoring based on content length and structure
    base_score = 7
    base_score += 1 if content.length > 50 # Has substantial content
    base_score += 1 if content.match?(/[!?]/) # Has engaging punctuation
    base_score -= 1 if content.length < 20 # Too short
    base_score = [base_score, 10].min # Cap at 10
    base_score = [base_score, 1].max # Floor at 1

    feedback = []

    case node_type
    when 'email'
      subject = node_data.dig('data', 'subject') || ''
      body = node_data.dig('data', 'body') || ''

      if subject.empty?
        feedback << "Add a compelling subject line to improve open rates"
        base_score -= 2
      elsif subject.length > 50
        feedback << "Consider shortening subject line for mobile optimization"
      end

      if body.empty?
        feedback << "Add engaging body content to drive action"
        base_score -= 2
      elsif !body.include?('http') && !body.downcase.include?('click')
        feedback << "Consider adding a clear call-to-action"
      end

      feedback << "Personalize content for #{brand} brand voice" if feedback.empty?

    when 'push'
      title = node_data.dig('data', 'title') || ''
      body = node_data.dig('data', 'body') || ''

      if title.empty?
        feedback << "Add an attention-grabbing title"
        base_score -= 2
      end

      if body.empty?
        feedback << "Add compelling body text to drive engagement"
        base_score -= 2
      elsif body.length > 120
        feedback << "Consider shortening message for better mobile display"
      end

    else
      feedback << "Review content for #{brand} brand alignment"
      feedback << "Ensure clear value proposition"
      feedback << "Add compelling call-to-action"
    end

    # Ensure we have at least some feedback
    if feedback.empty?
      feedback = [
        "Strong foundation - consider A/B testing variations",
        "Align messaging with #{brand} brand voice",
        "Test different emotional appeals"
      ]
    end

    {
      score: [base_score, 10].min,
      feedback: feedback.first(3), # Limit to 3 pieces of feedback
      analysis: "Mock analysis - upgrade to premium for AI-powered insights",
      recommendations: feedback
    }
  end
end
