require 'openai'
require 'net/http'
require 'json'

class Api::V1::AiController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:chat] # Allow public access for demo

  def chat
    begin
      user_message = params[:message]
      conversation_history = params[:conversation_history] || []
      current_campaign_id = params[:current_campaign_id]
      current_brand = params[:current_brand] || 'everclear'

      # Build context for the AI
      system_prompt = build_system_prompt(current_brand, current_campaign_id)

      # Prepare messages for OpenAI
      messages = [
        { role: 'system', content: system_prompt },
        *format_conversation_history(conversation_history),
        { role: 'user', content: user_message }
      ]

      # Call OpenAI API
      response = call_openai_chat(messages)

      # Check if AI wants to call a function
      if response.dig('choices', 0, 'message', 'function_call')
        function_result = handle_function_call(response['choices'][0]['message']['function_call'])

        # Send function result back to AI for final response
        messages << { role: 'assistant', content: nil, function_call: response['choices'][0]['message']['function_call'] }
        messages << { role: 'function', name: response['choices'][0]['message']['function_call']['name'], content: function_result.to_json }

        final_response = call_openai_chat(messages)
        ai_message = final_response.dig('choices', 0, 'message', 'content')
      else
        ai_message = response.dig('choices', 0, 'message', 'content')
      end

      render json: {
        message: ai_message,
        conversation_id: SecureRandom.uuid,
        timestamp: Time.current.iso8601
      }

    rescue => e
      Rails.logger.error "AI Chat Error: #{e.message}"
      render json: {
        error: 'Sorry, I encountered an error. Please try again.',
        details: Rails.env.development? ? e.message : nil
      }, status: :internal_server_error
    end
  end

  private

  def build_system_prompt(brand, campaign_id = nil)
    base_prompt = <<~PROMPT
      You are 'The AI Strategist', a world-class marketing expert and strategic advisor for Campaign Architect.
      Your purpose is to help marketers at Everclear and Phrendly build successful campaigns.

      You are helpful, data-driven, concise, and strategic. You provide actionable advice based on marketing best practices.

      BRAND CONTEXT:
      #{get_brand_context(brand)}

      CAPABILITIES:
      - Analyze campaign performance and suggest improvements
      - Create new campaign drafts and templates
      - Optimize copy for different platforms (email, social media, ads)
      - Provide strategic recommendations based on goals and audience
      - Suggest A/B testing strategies
      - Recommend automation workflows

      RESPONSE STYLE:
      - Be conversational but professional
      - Provide specific, actionable recommendations
      - Include relevant metrics and benchmarks when available
      - Ask clarifying questions when needed
      - Offer to take actions (create campaigns, update copy, etc.)

      IMPORTANT: If you don't have specific data, say so. Don't invent statistics.
    PROMPT

    # Add campaign context if available
    if campaign_id.present?
      campaign = Campaign.find_by(id: campaign_id)
      if campaign
        base_prompt += "\n\nCURRENT CAMPAIGN CONTEXT:\n"
        base_prompt += "Campaign: #{campaign.name}\n"
        base_prompt += "Brand: #{campaign.brand}\n"
        base_prompt += "Goal: #{campaign.goal}\n"
        base_prompt += "Structure: #{campaign.structure.to_json}\n"
      end
    end

    base_prompt
  end

  def get_brand_context(brand)
    case brand.downcase
    when 'everclear'
      <<~CONTEXT
        Everclear is a spiritual guidance platform connecting users with advisors for life clarity.

        Brand Voice: Empathetic, wise, supportive, authentic
        Target Audience: Millennials and Gen Z seeking spiritual guidance, life direction, and personal growth
        Key Values: Authenticity, empowerment, spiritual growth, life clarity

        Typical Goals: User acquisition, advisor onboarding, engagement, retention
        Common Campaigns: Welcome series, advisor matching, spiritual content, life guidance
      CONTEXT
    when 'phrendly'
      <<~CONTEXT
        Phrendly is a social connection platform where users can chat and earn money through conversations.

        Brand Voice: Fun, engaging, empowering, social
        Target Audience: Social individuals looking to connect and earn, chat enthusiasts
        Key Values: Social connection, earning potential, fun interactions, community

        Typical Goals: User acquisition, earner onboarding, engagement, monetization
        Common Campaigns: Earning potential, social features, chat engagement, community building
      CONTEXT
    else
      "Brand information not available for #{brand}."
    end
  end

  def format_conversation_history(history)
    return [] unless history.is_a?(Array)

    history.map do |message|
      {
        role: message['role'] || 'user',
        content: message['content'] || message['message']
      }
    end
  end

  def call_openai_chat(messages)
    api_key = Rails.application.credentials.openai_api_key || ENV['OPENAI_API_KEY']

    # Fallback mode if no API key is configured
    unless api_key.present?
      user_message = messages&.last&.dig(:content) || messages&.last&.dig('content') || ""
      return generate_mock_response(user_message)
    end

    begin
      # Direct HTTP request to OpenAI API
      uri = URI('https://api.openai.com/v1/chat/completions')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request['Authorization'] = "Bearer #{api_key}"

      request.body = {
        model: 'gpt-3.5-turbo',
        messages: messages,
        max_tokens: 1000,
        temperature: 0.7
      }.to_json

      response = http.request(request)

      if response.code == '200'
        return JSON.parse(response.body)
      else
        Rails.logger.error "OpenAI API Error: #{response.code} - #{response.body}"
        # Fall back to mock response
        user_message = messages&.last&.dig(:content) || messages&.last&.dig('content') || ""
        return generate_mock_response(user_message)
      end

    rescue StandardError => e
      Rails.logger.error "OpenAI API Error: #{e.message}"
      # Fall back to mock response for any other errors
      user_message = messages&.last&.dig(:content) || messages&.last&.dig('content') || ""
      return generate_mock_response(user_message)
    end
  end

  def generate_mock_response(user_message)
    # Provide intelligent mock responses based on the user's question
    response_content = case user_message.downcase
    when /performance|performing|metrics|analytics/
      "Great question! To determine if your campaign is performing optimally, I'd recommend tracking these key metrics:\n\n• **Open Rate**: Aim for 20-25% for email campaigns\n• **Click-through Rate**: Target 2-5% depending on your industry\n• **Conversion Rate**: Monitor how many clicks turn into actions\n• **ROI**: Calculate revenue generated vs. campaign cost\n\nWould you like me to analyze a specific campaign's performance data?"
    when /improve|optimize|better/
      "I can help you optimize your campaigns! Here are some proven strategies:\n\n• **A/B test subject lines** - Try different approaches\n• **Segment your audience** - Personalize based on behavior\n• **Optimize send times** - Test different days/hours\n• **Improve call-to-action** - Make buttons more compelling\n\nWhat specific aspect would you like to focus on?"
    when /create|build|new campaign/
      "I'd be happy to help you create a new campaign! Let me know:\n\n• **Campaign goal** (acquisition, engagement, retention)\n• **Target audience** (demographics, interests)\n• **Brand** (Everclear or Phrendly)\n• **Preferred channels** (email, social, ads)\n\nI can then suggest a campaign structure and copy that aligns with your objectives."
    else
      "I'm here to help you with your marketing campaigns! I can assist with:\n\n• **Campaign Performance Analysis** - Review metrics and suggest improvements\n• **Copy Optimization** - Enhance your messaging for better results\n• **Campaign Creation** - Build new campaigns from scratch\n• **Strategic Recommendations** - Provide data-driven insights\n\nWhat would you like to work on today?"
    end

    {
      'choices' => [
        {
          'message' => {
            'content' => response_content
          }
        }
      ]
    }
  end

  def get_available_functions
    [
      {
        name: 'create_campaign_draft',
        description: 'Create a new campaign draft with specified parameters',
        parameters: {
          type: 'object',
          properties: {
            name: { type: 'string', description: 'Campaign name' },
            brand: { type: 'string', enum: ['everclear', 'phrendly'] },
            goal: { type: 'string', description: 'Campaign goal' },
            description: { type: 'string', description: 'Campaign description' }
          },
          required: ['name', 'brand', 'goal']
        }
      },
      {
        name: 'get_campaign_performance',
        description: 'Get performance data for campaigns',
        parameters: {
          type: 'object',
          properties: {
            campaign_id: { type: 'integer', description: 'Campaign ID' },
            metric: { type: 'string', description: 'Specific metric to retrieve' }
          }
        }
      },
              {
          name: 'suggest_copy_improvements',
          description: 'Analyze and suggest improvements for campaign copy',
          parameters: {
            type: 'object',
            properties: {
              content: { type: 'string', description: 'Content to analyze' },
              platform: { type: 'string', description: 'Platform (email, facebook, instagram, etc.)' }
            },
            required: ['content']
          }
        },
        {
          name: 'predict_campaign_success',
          description: 'Predict the success probability of a campaign based on its structure',
          parameters: {
            type: 'object',
            properties: {
              campaign_id: { type: 'integer', description: 'Campaign ID to analyze' },
              brand: { type: 'string', enum: ['everclear', 'phrendly'] },
              goal: { type: 'string', description: 'Campaign goal' }
            },
            required: ['campaign_id']
          }
        }
    ]
  end

  def handle_function_call(function_call)
    function_name = function_call['name']
    arguments = JSON.parse(function_call['arguments'])

    case function_name
    when 'create_campaign_draft'
      create_campaign_draft(arguments)
    when 'get_campaign_performance'
      get_campaign_performance(arguments)
    when 'suggest_copy_improvements'
      suggest_copy_improvements(arguments)
    when 'predict_campaign_success'
      predict_campaign_success(arguments)
    else
      { error: "Unknown function: #{function_name}" }
    end
  end

  def create_campaign_draft(args)
    # Create a basic campaign structure
    campaign = Campaign.new(
      name: args['name'],
      brand: args['brand'],
      goal: args['goal'],
      structure: {
        nodes: [
          {
            id: 'start',
            type: 'email',
            position: { x: 100, y: 100 },
            data: {
              name: 'Welcome Email',
              subject: 'Welcome to your new campaign!',
              body: 'This is a draft campaign created by the AI Strategist.'
            }
          }
        ],
        edges: []
      }
    )

    if campaign.save
      { success: true, campaign_id: campaign.id, message: "Created campaign '#{campaign.name}'" }
    else
      { success: false, errors: campaign.errors.full_messages }
    end
  end

  def get_campaign_performance(args)
    analytics_service = CampaignAnalyticsService.new

    if args['campaign_id']
      analytics_service.analyze_campaign_performance(args['campaign_id'])
    else
      { error: 'Campaign ID is required' }
    end
  end

  def suggest_copy_improvements(args)
    # Use existing copy grading service
    marketing_service = MarketingIntelligenceService.new
    analysis = marketing_service.analyze_content_for_platform(
      args['content'],
      args['platform'] || 'email'
    )

    {
      original_content: args['content'],
      analysis: analysis,
      suggestions: [
        'Consider adding more emotional appeal',
        'Include a stronger call-to-action',
        'Personalize the message for better engagement'
      ]
    }
  end

  def predict_campaign_success(args)
    campaign = Campaign.find_by(id: args['campaign_id'])
    return { error: 'Campaign not found' } unless campaign

    analytics_service = CampaignAnalyticsService.new
    analytics_service.predict_campaign_success(
      campaign.structure,
      args['brand'] || campaign.brand,
      args['goal'] || campaign.goal
    )
  end
end
