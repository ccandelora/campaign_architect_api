class Api::V1::MarketingIntelligenceController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:analyze_campaign, :suggest_ga4_events, :generate_utm_recommendations]

  def analyze_platform_content
    platform = params[:platform]
    content_data = params[:content_data]
    brand = params[:brand]

    unless %w[facebook instagram tiktok twitter email].include?(platform)
      return render json: { error: "Unsupported platform: #{platform}" }, status: :bad_request
    end

    service = MarketingIntelligenceService.new

    if platform == 'email'
      campaign_type = params[:campaign_type] || 'newsletter'
      result = service.analyze_email_content(content_data, brand, campaign_type)
    else
      result = service.analyze_platform_content(platform, content_data, brand)
    end

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def analyze_email_deliverability
    sender_domain = params[:sender_domain]
    email_content = params[:email_content]
    sending_practices = params[:sending_practices] || {}

    unless sender_domain.present?
      return render json: { error: "Sender domain is required" }, status: :bad_request
    end

    service = MarketingIntelligenceService.new
    result = service.analyze_email_deliverability(sender_domain, email_content, sending_practices)

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def suggest_email_segmentation
    campaign_goal = params[:campaign_goal] || 'engagement'
    brand = params[:brand]
    subscriber_data = params[:subscriber_data] || {}

    service = MarketingIntelligenceService.new
    result = service.suggest_email_segmentation_strategy(campaign_goal, brand, subscriber_data)

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def generate_email_automation
    campaign_type = params[:campaign_type] || 'welcome'
    brand = params[:brand]
    user_journey = params[:user_journey] || []

    service = MarketingIntelligenceService.new
    result = service.generate_email_automation_recommendations(campaign_type, brand, user_journey)

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def get_email_metrics_benchmarks
    industry = params[:industry] || 'general'

    # Return email marketing benchmarks from the service
    metrics = MarketingIntelligenceService::EMAIL_MARKETING_METRICS

    render json: {
      metrics: metrics,
      industry_context: get_industry_email_benchmarks(industry),
      improvement_tips: get_metrics_improvement_tips
    }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def get_email_best_practices
    email_type = params[:email_type] || 'newsletter'
    brand = params[:brand]

    practices = MarketingIntelligenceService::PLATFORM_BEST_PRACTICES[:email]

    render json: {
      email_type: email_type,
      character_limits: practices[:character_limits],
      best_practices: practices[:best_practices],
      design_guidelines: practices[:design_guidelines],
      deliverability_factors: practices[:deliverability_factors],
      automation_opportunities: practices[:automation_opportunities],
      testing_strategies: practices[:testing_strategies],
      brand_specific_tips: get_brand_email_tips(brand)
    }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def email_ab_testing_suggestions
    test_element = params[:test_element] || 'subject_line'
    current_content = params[:current_content]
    brand = params[:brand]

    suggestions = generate_ab_test_suggestions(test_element, current_content, brand)

    render json: {
      test_element: test_element,
      suggestions: suggestions,
      testing_methodology: get_testing_methodology(test_element),
      success_metrics: get_test_success_metrics(test_element)
    }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def email_compliance_check
    email_content = params[:email_content]
    region = params[:region] || 'gdpr'

    service = MarketingIntelligenceService.new

    compliance_result = case region.downcase
    when 'gdpr'
      service.verify_gdpr_compliance(email_content)
    else
      { error: "Unsupported region: #{region}" }
    end

    render json: {
      region: region,
      compliance_result: compliance_result,
      checklist: MarketingIntelligenceService::GDPR_COMPLIANCE_CHECKLIST,
      recommended_actions: get_compliance_actions(compliance_result)
    }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def optimize_content
    platform = params[:platform]
    content_data = params[:content_data]
    brand = params[:brand]

    service = MarketingIntelligenceService.new

    if platform == 'email'
      result = service.analyze_email_content(content_data, brand)
    else
      result = service.enhance_copy_with_platform_best_practices(platform, content_data, brand)
    end

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def suggest_ga4_events
    campaign_goal = @campaign.goal
    nodes = @campaign.nodes

    service = MarketingIntelligenceService.new
    result = service.suggest_ga4_events(campaign_goal, nodes)

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def generate_utm_recommendations
    campaign_name = @campaign.name
    brand = @campaign.brand

    # Extract channels from campaign structure
    channels = extract_channels_from_campaign(@campaign)

    service = MarketingIntelligenceService.new
    result = service.generate_utm_recommendations(campaign_name, brand, channels)

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def analyze_campaign
    service = OpenaiService.new
    result = service.analyze_funnel(brand: @campaign.brand, campaign_structure: @campaign.structure)

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def get_platform_best_practices
    platform = params[:platform]

    practices = MarketingIntelligenceService::PLATFORM_BEST_PRACTICES[platform.to_sym]

    if practices
      render json: {
        platform: platform,
        character_limits: practices[:character_limits],
        best_practices: practices[:best_practices],
        additional_guidance: practices[:audience_targeting] || practices[:content_strategy] || practices[:content_pillars] || practices[:content_types] || practices[:design_guidelines] || []
      }
    else
      render json: { error: "Platform not supported: #{platform}" }, status: :bad_request
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def get_utm_examples
    brand = params[:brand]
    channels = params[:channels] || %w[email facebook instagram twitter]

    service = MarketingIntelligenceService.new
    result = service.generate_utm_recommendations('sample-campaign', brand, channels)

    render json: {
      examples: result[:recommendations],
      best_practices: result[:best_practices],
      naming_conventions: result[:naming_conventions]
    }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def get_ga4_event_recommendations
    campaign_goal = params[:campaign_goal] || 'engagement'

    service = MarketingIntelligenceService.new

    # Create sample nodes based on goal
    sample_nodes = generate_sample_nodes_for_goal(campaign_goal)
    result = service.suggest_ga4_events(campaign_goal, sample_nodes)

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def enhance_node_copy
    node_data = params[:node_data]
    brand = params[:brand]
    node_type = params[:node_type]

    service = OpenaiService.new
    result = service.generate_enhanced_copy_suggestions(brand, node_data, node_type)

    render json: { enhanced_suggestions: result }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def platform_preview
    platform = params[:platform]
    content_data = params[:content_data]

    # Generate a preview object based on platform requirements
    preview = generate_platform_preview(platform, content_data)

    render json: preview
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_campaign
    @campaign = current_user.campaigns.find(params[:campaign_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Campaign not found' }, status: :not_found
  end

  def extract_channels_from_campaign(campaign)
    nodes = campaign.nodes
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

  def generate_sample_nodes_for_goal(goal)
    case goal.downcase
    when /purchase|buy|shop|ecommerce/
      [
        { 'id' => '1', 'type' => 'email', 'data' => { 'subject' => 'Complete your purchase' } },
        { 'id' => '2', 'type' => 'social', 'data' => { 'platform' => 'facebook' } },
        { 'id' => '3', 'type' => 'ad', 'data' => { 'platform' => 'google' } }
      ]
    when /signup|register|lead/
      [
        { 'id' => '1', 'type' => 'email', 'data' => { 'subject' => 'Welcome to our platform' } },
        { 'id' => '2', 'type' => 'push', 'data' => { 'title' => 'Complete your profile' } }
      ]
    else
      [
        { 'id' => '1', 'type' => 'social', 'data' => { 'platform' => 'instagram' } },
        { 'id' => '2', 'type' => 'email', 'data' => { 'subject' => 'Stay engaged' } }
      ]
    end
  end

  def generate_platform_preview(platform, content_data)
    case platform
    when 'facebook'
      generate_facebook_preview(content_data)
    when 'instagram'
      generate_instagram_preview(content_data)
    when 'tiktok'
      generate_tiktok_preview(content_data)
    when 'twitter'
      generate_twitter_preview(content_data)
    when 'email'
      generate_email_preview(content_data)
    else
      { error: "Preview not available for platform: #{platform}" }
    end
  end

  def generate_email_preview(content_data)
    subject_line = content_data.dig('data', 'subject') || content_data.dig('data', 'subject_line') || ''
    preview_text = content_data.dig('data', 'preview_text') || ''
    sender_name = content_data.dig('data', 'sender_name') || 'Your Company'
    body = content_data.dig('data', 'body') || ''

    {
      platform: 'email',
      preview_type: 'inbox_preview',
      elements: {
        sender_name: sender_name,
        subject_line: subject_line,
        preview_text: preview_text,
        body_preview: body.length > 150 ? "#{body[0..150]}..." : body,
        timestamp: 'Just now'
      },
      character_counts: {
        subject_line: subject_line.length,
        subject_line_limit: 50,
        preview_text: preview_text.length,
        preview_text_limit: 140,
        sender_name: sender_name.length,
        sender_name_limit: 25
      },
      mobile_preview: {
        subject_truncated: subject_line.length > 40,
        preview_truncated: preview_text.length > 90
      }
    }
  end

  # Email-specific helper methods
  def get_industry_email_benchmarks(industry)
    benchmarks = {
      'general' => {
        open_rate: '21.33%',
        click_rate: '2.62%',
        unsubscribe_rate: '0.26%'
      },
      'technology' => {
        open_rate: '23.9%',
        click_rate: '3.26%',
        unsubscribe_rate: '0.18%'
      },
      'healthcare' => {
        open_rate: '24.79%',
        click_rate: '3.1%',
        unsubscribe_rate: '0.24%'
      },
      'retail' => {
        open_rate: '18.39%',
        click_rate: '2.25%',
        unsubscribe_rate: '0.29%'
      }
    }

    benchmarks[industry] || benchmarks['general']
  end

  def get_metrics_improvement_tips
    [
      "Use A/B testing for subject lines to improve open rates",
      "Segment your audience for more relevant content",
      "Optimize send times based on subscriber behavior",
      "Use clear, compelling call-to-action buttons",
      "Personalize content with subscriber data",
      "Maintain list hygiene with regular cleaning",
      "Test email frequency to find optimal cadence"
    ]
  end

  def get_brand_email_tips(brand)
    case brand
    when 'everclear'
      [
        "Use mystical but accessible language in subject lines",
        "Include testimonials and success stories",
        "Focus on personal growth and clarity themes",
        "Use calming, trustworthy design elements"
      ]
    when 'phrendly'
      [
        "Use playful, flirtatious language appropriately",
        "Emphasize fun and social connection",
        "Include interactive elements and gamification",
        "Use vibrant, social design elements"
      ]
    else
      [
        "Maintain consistent brand voice",
        "Use brand colors and visual identity",
        "Include clear value propositions",
        "Follow platform-specific best practices"
      ]
    end
  end

  def generate_ab_test_suggestions(test_element, current_content, brand)
    case test_element
    when 'subject_line'
      [
        {
          version: 'A',
          content: current_content,
          description: 'Original version'
        },
        {
          version: 'B',
          content: add_urgency_to_subject(current_content),
          description: 'Added urgency and scarcity'
        },
        {
          version: 'C',
          content: add_personalization_to_subject(current_content),
          description: 'Added personalization'
        },
        {
          version: 'D',
          content: add_curiosity_to_subject(current_content),
          description: 'Added curiosity gap'
        }
      ]
    when 'cta_button'
      [
        {
          version: 'A',
          content: current_content,
          description: 'Original CTA'
        },
        {
          version: 'B',
          content: 'Get Started Now',
          description: 'Action-oriented with urgency'
        },
        {
          version: 'C',
          content: 'Claim Your Spot',
          description: 'Exclusive positioning'
        }
      ]
    else
      []
    end
  end

  def get_testing_methodology(test_element)
    {
      sample_size: "Ensure statistical significance (minimum 1000 subscribers per variant)",
      duration: "Run test for at least 24-48 hours to account for timing variations",
      metrics: get_test_success_metrics(test_element),
      best_practices: [
        "Test one element at a time",
        "Ensure random sample distribution",
        "Wait for statistical significance before declaring winner",
        "Document learnings for future campaigns"
      ]
    }
  end

  def get_test_success_metrics(test_element)
    case test_element
    when 'subject_line'
      ['Open Rate', 'Click-through Rate']
    when 'cta_button'
      ['Click-through Rate', 'Conversion Rate']
    when 'send_time'
      ['Open Rate', 'Click-through Rate', 'Unsubscribe Rate']
    else
      ['Open Rate', 'Click-through Rate', 'Conversion Rate']
    end
  end

  def get_compliance_actions(compliance_result)
    return [] unless compliance_result.is_a?(Hash)

    actions = []

    if compliance_result.dig(:compliance_score).to_i < 80
      actions << "Review and update privacy policy links"
      actions << "Ensure clear unsubscribe mechanisms"
      actions << "Verify sender identification information"
      actions << "Add consent reminder language"
    end

    actions
  end

  def add_urgency_to_subject(subject)
    urgency_words = ['Limited Time', 'Act Fast', 'Ends Soon', 'Last Chance']
    "#{urgency_words.sample}: #{subject}"
  end

  def add_personalization_to_subject(subject)
    "{{first_name}}, #{subject.downcase}"
  end

  def add_curiosity_to_subject(subject)
    "The secret to #{subject.downcase}?"
  end

  def generate_facebook_preview(content_data)
    {
      platform: 'facebook',
      preview_type: 'post',
      elements: {
        profile_image: 'https://via.placeholder.com/40x40',
        profile_name: content_data.dig('data', 'page_name') || 'Your Page',
        post_time: 'Just now',
        primary_text: content_data.dig('data', 'primary_text') || content_data.dig('data', 'caption') || '',
        media: {
          type: content_data.dig('data', 'media_type') || 'image',
          url: content_data.dig('data', 'media_url') || 'https://via.placeholder.com/500x300'
        },
        link_preview: {
          title: content_data.dig('data', 'link_title') || '',
          description: content_data.dig('data', 'link_description') || '',
          url: content_data.dig('data', 'link_url') || ''
        }
      },
      character_counts: {
        primary_text: (content_data.dig('data', 'primary_text') || '').length,
        primary_text_limit: 125
      }
    }
  end

  def generate_instagram_preview(content_data)
    caption = content_data.dig('data', 'caption') || ''
    hashtags = caption.scan(/#\w+/)

    {
      platform: 'instagram',
      preview_type: 'feed_post',
      elements: {
        profile_image: 'https://via.placeholder.com/32x32',
        username: content_data.dig('data', 'username') || 'your_account',
        media: {
          type: content_data.dig('data', 'media_type') || 'image',
          url: content_data.dig('data', 'media_url') || 'https://via.placeholder.com/400x400'
        },
        caption: caption,
        hashtags: hashtags,
        location: content_data.dig('data', 'location') || ''
      },
      character_counts: {
        caption: caption.length,
        caption_limit: 2200,
        hashtag_count: hashtags.length,
        hashtag_limit: 30
      }
    }
  end

  def generate_tiktok_preview(content_data)
    caption = content_data.dig('data', 'caption') || ''

    {
      platform: 'tiktok',
      preview_type: 'video',
      elements: {
        username: content_data.dig('data', 'username') || '@your_account',
        video: {
          thumbnail: content_data.dig('data', 'thumbnail_url') || 'https://via.placeholder.com/300x400',
          description: content_data.dig('data', 'video_concept') || 'Video concept not specified'
        },
        caption: caption,
        sound: content_data.dig('data', 'sound') || 'Original sound',
        hashtags: caption.scan(/#\w+/)
      },
      character_counts: {
        caption: caption.length,
        caption_limit: 300
      }
    }
  end

  def generate_twitter_preview(content_data)
    text = content_data.dig('data', 'text') || content_data.dig('data', 'caption') || ''

    {
      platform: 'twitter',
      preview_type: 'tweet',
      elements: {
        profile_image: 'https://via.placeholder.com/40x40',
        display_name: content_data.dig('data', 'display_name') || 'Your Brand',
        username: content_data.dig('data', 'username') || '@your_account',
        text: text,
        media: {
          type: content_data.dig('data', 'media_type'),
          url: content_data.dig('data', 'media_url')
        },
        timestamp: 'Just now'
      },
      character_counts: {
        text: text.length,
        text_limit: 280
      }
    }
  end
end
