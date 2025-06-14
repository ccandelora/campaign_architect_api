class MarketingIntelligenceService
  PLATFORM_BEST_PRACTICES = {
    facebook: {
      character_limits: {
        primary_text: 125,
        headline: 27,
        description: 27,
        link_description: 30
      },
      best_practices: [
        "Use authentic, user-generated content when possible",
        "Include clear, compelling calls-to-action",
        "Test different ad formats (carousel, video, single image)",
        "Use Facebook Pixel for conversion tracking",
        "Target lookalike audiences based on your best customers",
        "Use emotional triggers and storytelling",
        "Include social proof and testimonials",
        "Test mobile-first creative designs"
      ],
      audience_targeting: [
        "Create Custom Audiences from website visitors",
        "Use Lookalike Audiences (1-10% similarity)",
        "Layer interests with behaviors for precision",
        "Test broad audiences vs. detailed targeting",
        "Use life events targeting when relevant"
      ]
    },
    instagram: {
      character_limits: {
        caption: 2200,
        hashtags: 30,
        story_text: 160,
        bio_link_text: 30
      },
      best_practices: [
        "Post consistently during peak engagement hours",
        "Use high-quality, visually appealing content",
        "Include relevant and trending hashtags",
        "Engage with your audience through comments and DMs",
        "Use Instagram Stories for behind-the-scenes content",
        "Collaborate with influencers and user-generated content",
        "Create shoppable posts for e-commerce",
        "Use Instagram Reels for maximum reach"
      ],
      content_strategy: [
        "Mix of educational, entertaining, and promotional content",
        "Use carousel posts for higher engagement",
        "Post user-generated content and testimonials",
        "Share behind-the-scenes content",
        "Use Instagram Shopping features"
      ]
    },
    tiktok: {
      character_limits: {
        caption: 300,
        bio: 80,
        username: 24
      },
      best_practices: [
        "Jump on trending sounds and challenges quickly",
        "Create authentic, unpolished content",
        "Hook viewers in the first 3 seconds",
        "Use trending hashtags and participate in challenges",
        "Post consistently (1-4 times per day)",
        "Engage with comments and create response videos",
        "Collaborate with TikTok creators",
        "Use TikTok's editing tools and effects"
      ],
      content_pillars: [
        "Educational content (how-tos, tips)",
        "Entertainment (funny, relatable content)",
        "Trending challenges and dances",
        "Behind-the-scenes content",
        "User-generated content",
        "Product demonstrations"
      ]
    },
    twitter: {
      character_limits: {
        tweet: 280,
        dm: 10000,
        bio: 160,
        name: 50
      },
      best_practices: [
        "Tweet during peak hours for your audience",
        "Use relevant hashtags (1-2 per tweet)",
        "Engage in real-time conversations",
        "Share timely, newsworthy content",
        "Use Twitter Threads for longer content",
        "Retweet and engage with influencers",
        "Use Twitter Polls for engagement",
        "Monitor trending topics for opportunities"
      ],
      content_types: [
        "News and industry updates",
        "Quick tips and insights",
        "Live-tweeting events",
        "Customer service responses",
        "Thought leadership content"
      ]
    },
    email: {
      character_limits: {
        subject_line: 50,
        preview_text: 140,
        sender_name: 25,
        header: 100
      },
      best_practices: [
        "Craft compelling subject lines that create urgency or curiosity",
        "Use responsive design templates for mobile optimization",
        "Personalize content based on subscriber behavior and preferences",
        "Include clear, prominent call-to-action buttons",
        "Optimize images for fast loading and accessibility",
        "Maintain consistent brand voice and visual identity",
        "Use proper sender authentication (SPF, DKIM, DMARC)",
        "Segment your audience for targeted messaging"
      ],
      design_guidelines: [
        "Use single-column layout for mobile responsiveness",
        "Keep font sizes at least 16px for body text",
        "Ensure CTA buttons are at least 44x44 pixels",
        "Use high contrast colors for accessibility",
        "Optimize images and use alt text",
        "Include a clear email signature",
        "Test across multiple email clients"
      ],
      deliverability_factors: [
        "Maintain clean email lists with regular hygiene",
        "Use double opt-in for new subscribers",
        "Monitor sender reputation and engagement metrics",
        "Avoid spam trigger words in subject lines and content",
        "Include unsubscribe links in all emails",
        "Use consistent sending patterns",
        "Authenticate your domain properly"
      ],
      automation_opportunities: [
        "Welcome email series for new subscribers",
        "Abandoned cart recovery sequences",
        "Birthday and anniversary campaigns",
        "Re-engagement campaigns for inactive subscribers",
        "Post-purchase follow-up sequences",
        "Educational drip campaigns",
        "Behavioral trigger campaigns"
      ],
      testing_strategies: [
        "A/B test subject lines for open rate optimization",
        "Test send times and days of the week",
        "Test different CTA button colors and text",
        "Test email length and content format",
        "Test personalization elements",
        "Test different sender names",
        "Test email frequency for different segments"
      ]
    }
  }.freeze

  GA4_RECOMMENDED_EVENTS = {
    ecommerce: [
      'view_item', 'add_to_cart', 'begin_checkout', 'purchase',
      'view_item_list', 'select_item', 'add_payment_info',
      'add_shipping_info', 'remove_from_cart'
    ],
    content: [
      'page_view', 'scroll', 'click', 'file_download',
      'video_start', 'video_progress', 'video_complete'
    ],
    engagement: [
      'login', 'sign_up', 'search', 'select_content',
      'share', 'join_group', 'generate_lead'
    ],
    monetization: [
      'ad_impression', 'earn_virtual_currency', 'spend_virtual_currency',
      'unlock_achievement', 'post_score', 'level_up'
    ]
  }.freeze

  UTM_PARAMETER_RECOMMENDATIONS = {
    source_examples: {
      'newsletter' => 'Use for email campaigns',
      'facebook' => 'For Facebook ads and posts',
      'instagram' => 'For Instagram content',
      'tiktok' => 'For TikTok campaigns',
      'twitter' => 'For Twitter/X campaigns',
      'google' => 'For Google Ads',
      'linkedin' => 'For LinkedIn content'
    },
    medium_examples: {
      'email' => 'Email marketing campaigns',
      'cpc' => 'Cost-per-click advertising',
      'social' => 'Organic social media posts',
      'display' => 'Display advertising',
      'affiliate' => 'Affiliate marketing',
      'referral' => 'Referral programs'
    }
  }.freeze

  EMAIL_MARKETING_METRICS = {
    primary_metrics: {
      open_rate: {
        description: "Percentage of recipients who opened the email",
        benchmark_ranges: {
          excellent: "> 25%",
          good: "20-25%",
          average: "15-20%",
          needs_improvement: "< 15%"
        }
      },
      click_through_rate: {
        description: "Percentage of recipients who clicked on links in the email",
        benchmark_ranges: {
          excellent: "> 5%",
          good: "3-5%",
          average: "2-3%",
          needs_improvement: "< 2%"
        }
      },
      conversion_rate: {
        description: "Percentage of recipients who completed the desired action",
        benchmark_ranges: {
          excellent: "> 3%",
          good: "2-3%",
          average: "1-2%",
          needs_improvement: "< 1%"
        }
      },
      unsubscribe_rate: {
        description: "Percentage of recipients who unsubscribed",
        benchmark_ranges: {
          excellent: "< 0.2%",
          good: "0.2-0.5%",
          average: "0.5-1%",
          needs_improvement: "> 1%"
        }
      }
    },
    advanced_metrics: {
      deliverability_rate: "Percentage of emails that reached inboxes",
      bounce_rate: "Percentage of emails that couldn't be delivered",
      spam_complaint_rate: "Percentage of recipients who marked email as spam",
      list_growth_rate: "Rate at which your email list is growing",
      email_sharing_rate: "Percentage of recipients who shared your email",
      overall_roi: "Return on investment from email campaigns"
    }
  }.freeze

  EMAIL_SEGMENTATION_STRATEGIES = {
    demographic: [
      "Age and generation",
      "Gender identity",
      "Location and timezone",
      "Income level",
      "Job title and industry"
    ],
    behavioral: [
      "Purchase history and frequency",
      "Website browsing behavior",
      "Email engagement patterns",
      "Product preferences",
      "Lifecycle stage"
    ],
    psychographic: [
      "Interests and hobbies",
      "Values and beliefs",
      "Lifestyle preferences",
      "Personality traits",
      "Brand affinity"
    ],
    engagement_based: [
      "Highly engaged subscribers",
      "Moderately engaged subscribers",
      "At-risk subscribers",
      "Win-back candidates",
      "New subscribers"
    ]
  }.freeze

  EMAIL_AUTOMATION_WORKFLOWS = {
    welcome_series: {
      description: "Onboard new subscribers with valuable content",
      emails: [
        { sequence: 1, timing: "Immediately", purpose: "Welcome and set expectations" },
        { sequence: 2, timing: "2 days later", purpose: "Introduce your brand story" },
        { sequence: 3, timing: "5 days later", purpose: "Provide valuable resources" },
        { sequence: 4, timing: "1 week later", purpose: "Showcase social proof" }
      ]
    },
    abandoned_cart: {
      description: "Recover potential lost sales",
      emails: [
        { sequence: 1, timing: "1 hour after", purpose: "Gentle reminder" },
        { sequence: 2, timing: "24 hours after", purpose: "Add urgency or incentive" },
        { sequence: 3, timing: "3 days after", purpose: "Final reminder with strong offer" }
      ]
    },
    re_engagement: {
      description: "Win back inactive subscribers",
      emails: [
        { sequence: 1, timing: "After 30 days inactive", purpose: "We miss you message" },
        { sequence: 2, timing: "1 week later", purpose: "Special offer or content" },
        { sequence: 3, timing: "2 weeks later", purpose: "Last chance / unsubscribe option" }
      ]
    },
    post_purchase: {
      description: "Enhance customer experience after purchase",
      emails: [
        { sequence: 1, timing: "Immediately", purpose: "Order confirmation" },
        { sequence: 2, timing: "When shipped", purpose: "Shipping notification" },
        { sequence: 3, timing: "After delivery", purpose: "Review request" },
        { sequence: 4, timing: "2 weeks later", purpose: "Related product recommendations" }
      ]
    }
  }.freeze

  GDPR_COMPLIANCE_CHECKLIST = [
    "Use clear, unambiguous consent language",
    "Provide easy unsubscribe options",
    "Include privacy policy links",
    "Allow data access and deletion requests",
    "Use double opt-in for new subscribers",
    "Document consent and opt-in timestamps",
    "Regularly audit and clean email lists",
    "Implement data retention policies"
  ].freeze

  def initialize
    # Lazy load OpenaiService to avoid circular dependency
  end

  def openai_service
    @openai_service ||= OpenaiService.new
  end

  def analyze_platform_content(platform, content_data, brand)
    platform_key = platform.to_sym
    practices = PLATFORM_BEST_PRACTICES[platform_key]

    return { error: "Unsupported platform: #{platform}" } unless practices

    analysis = {
      platform: platform,
      character_count_analysis: analyze_character_limits(content_data, practices[:character_limits]),
      best_practices_compliance: check_best_practices_compliance(content_data, practices[:best_practices], brand),
      recommendations: generate_platform_recommendations(platform, content_data, brand),
      optimization_score: calculate_optimization_score(content_data, practices, brand)
    }

    analysis
  end

  def suggest_ga4_events(campaign_goal, user_journey_nodes)
    relevant_events = case campaign_goal.downcase
    when /purchase|buy|shop|ecommerce/
      GA4_RECOMMENDED_EVENTS[:ecommerce]
    when /content|read|view|engagement/
      GA4_RECOMMENDED_EVENTS[:content] + GA4_RECOMMENDED_EVENTS[:engagement]
    when /signup|register|lead/
      GA4_RECOMMENDED_EVENTS[:engagement]
    when /game|virtual|reward/
      GA4_RECOMMENDED_EVENTS[:monetization]
    else
      GA4_RECOMMENDED_EVENTS[:engagement]
    end

    # Generate event suggestions based on user journey
    event_suggestions = user_journey_nodes.map do |node|
      case node['type']
      when 'email'
        { event_name: 'email_open', trigger: 'Email opened', node_id: node['id'] }
      when 'push'
        { event_name: 'push_notification_open', trigger: 'Push notification opened', node_id: node['id'] }
      when 'social'
        { event_name: 'social_content_view', trigger: 'Social content viewed', node_id: node['id'] }
      when 'ad'
        { event_name: 'ad_click', trigger: 'Advertisement clicked', node_id: node['id'] }
      end
    end.compact

    {
      recommended_events: relevant_events,
      journey_events: event_suggestions,
      setup_guide: generate_ga4_setup_guide(relevant_events)
    }
  end

  def generate_utm_recommendations(campaign_name, brand, channels)
    base_campaign = campaign_name.parameterize

    recommendations = channels.map do |channel|
      {
        channel: channel,
        utm_source: suggest_utm_source(channel, brand),
        utm_medium: suggest_utm_medium(channel),
        utm_campaign: base_campaign,
        utm_content: "auto-generated-from-node-name",
        example_url: build_example_utm_url(channel, base_campaign, brand)
      }
    end

    {
      recommendations: recommendations,
      best_practices: utm_best_practices,
      naming_conventions: utm_naming_conventions
    }
  end

  def enhance_copy_with_platform_best_practices(platform, content_data, brand)
    platform_practices = PLATFORM_BEST_PRACTICES[platform.to_sym]
    return content_data unless platform_practices

    prompt = build_platform_optimization_prompt(platform, content_data, brand, platform_practices)

    # This would call OpenAI to get enhanced copy suggestions
    enhanced_suggestions = get_ai_enhanced_copy(prompt)

    {
      original: content_data,
      enhanced_suggestions: enhanced_suggestions,
      platform_specific_tips: platform_practices[:best_practices].sample(3)
    }
  end

  def analyze_email_content(content_data, brand, campaign_type = 'newsletter')
    analysis = {
      email_type: campaign_type,
      character_count_analysis: analyze_email_character_limits(content_data),
      subject_line_analysis: analyze_subject_line(content_data.dig('data', 'subject')),
      content_analysis: analyze_email_content_quality(content_data, brand),
      design_compliance: check_email_design_compliance(content_data),
      deliverability_score: calculate_deliverability_score(content_data, brand),
      personalization_opportunities: identify_personalization_opportunities(content_data),
      automation_recommendations: suggest_automation_workflows(campaign_type, brand),
      compliance_check: verify_gdpr_compliance(content_data),
      optimization_score: calculate_email_optimization_score(content_data, brand)
    }

    analysis
  end

  def suggest_email_segmentation_strategy(campaign_goal, brand, subscriber_data = {})
    strategies = []

    case campaign_goal.downcase
    when /welcome|onboard/
      strategies = EMAIL_SEGMENTATION_STRATEGIES[:engagement_based] +
                  ["Sign-up source", "Subscription preferences"]
    when /promotional|sale/
      strategies = EMAIL_SEGMENTATION_STRATEGIES[:behavioral] +
                  EMAIL_SEGMENTATION_STRATEGIES[:demographic]
    when /educational|content/
      strategies = EMAIL_SEGMENTATION_STRATEGIES[:psychographic] +
                  ["Content engagement history", "Topic preferences"]
    when /retention|winback/
      strategies = EMAIL_SEGMENTATION_STRATEGIES[:engagement_based] +
                  ["Last purchase date", "Engagement decline pattern"]
    else
      strategies = EMAIL_SEGMENTATION_STRATEGIES[:behavioral]
    end

    {
      recommended_segments: strategies,
      brand_specific_segments: get_brand_specific_segments(brand),
      implementation_guide: generate_segmentation_guide(strategies),
      expected_improvements: calculate_segmentation_benefits(strategies)
    }
  end

  def generate_email_automation_recommendations(campaign_type, brand, user_journey = [])
    automation_type = map_campaign_to_automation(campaign_type)
    base_workflow = EMAIL_AUTOMATION_WORKFLOWS[automation_type]

    return {} unless base_workflow

    customized_workflow = customize_workflow_for_brand(base_workflow, brand)

    {
      workflow_type: automation_type,
      description: customized_workflow[:description],
      email_sequence: customized_workflow[:emails],
      brand_customizations: get_brand_automation_customizations(brand, automation_type),
      success_metrics: get_automation_success_metrics(automation_type),
      implementation_timeline: generate_implementation_timeline(customized_workflow)
    }
  end

  def analyze_email_deliverability(sender_domain, email_content, sending_practices = {})
    deliverability_factors = {
      sender_reputation: analyze_sender_reputation(sender_domain),
      content_analysis: analyze_content_for_spam_triggers(email_content),
      authentication_status: check_email_authentication(sender_domain),
      list_hygiene: evaluate_list_hygiene_practices(sending_practices),
      sending_patterns: analyze_sending_patterns(sending_practices)
    }

    recommendations = generate_deliverability_recommendations(deliverability_factors)

    {
      overall_score: calculate_deliverability_score(deliverability_factors),
      factor_analysis: deliverability_factors,
      recommendations: recommendations,
      action_items: prioritize_deliverability_actions(deliverability_factors)
    }
  end

  private

  def analyze_character_limits(content_data, limits)
    analysis = {}

    limits.each do |field, limit|
      content = content_data.dig('data', field.to_s) || ''
      char_count = content.length

      analysis[field] = {
        current_count: char_count,
        limit: limit,
        remaining: limit - char_count,
        status: char_count <= limit ? 'within_limit' : 'exceeds_limit',
        percentage_used: (char_count.to_f / limit * 100).round(1)
      }
    end

    analysis
  end

  def check_best_practices_compliance(content_data, practices, brand)
    # This would be expanded with more sophisticated NLP analysis
    content_text = extract_all_text(content_data)

    compliance_score = 0
    checks = []

    # Basic compliance checks
    if content_text.include?('http') || content_text.include?('www')
      compliance_score += 10
      checks << { practice: "Includes links/URLs", status: "pass" }
    end

    if content_text.match?(/\b(click|tap|shop|buy|learn|discover|get|try)\b/i)
      compliance_score += 15
      checks << { practice: "Contains call-to-action verbs", status: "pass" }
    end

    # Brand voice compliance
    brand_words = get_brand_keywords(brand)
    if brand_words.any? { |word| content_text.downcase.include?(word) }
      compliance_score += 10
      checks << { practice: "Aligns with brand voice", status: "pass" }
    end

    {
      score: compliance_score,
      max_score: 100,
      checks: checks,
      suggestions: generate_compliance_suggestions(checks, practices)
    }
  end

  def generate_platform_recommendations(platform, content_data, brand)
    case platform
    when 'facebook'
      facebook_specific_recommendations(content_data, brand)
    when 'instagram'
      instagram_specific_recommendations(content_data, brand)
    when 'tiktok'
      tiktok_specific_recommendations(content_data, brand)
    when 'twitter'
      twitter_specific_recommendations(content_data, brand)
    else
      []
    end
  end

  def facebook_specific_recommendations(content_data, brand)
    recommendations = []

    # Check for video content
    if content_data.dig('data', 'media_type') != 'video'
      recommendations << "Consider using video content - Facebook videos get 135% more organic reach than photos"
    end

    # Check for storytelling elements
    content_text = extract_all_text(content_data)
    unless content_text.match?(/\b(story|journey|experience|discovered|learned)\b/i)
      recommendations << "Add storytelling elements to increase emotional connection"
    end

    # Brand-specific recommendations
    if brand == 'everclear'
      recommendations << "Include testimonials or success stories to build trust"
      recommendations << "Use mystical but accessible language that resonates with your audience"
    elsif brand == 'phrendly'
      recommendations << "Emphasize the fun, social aspect of connecting with others"
      recommendations << "Include playful language that encourages interaction"
    end

    recommendations
  end

  def instagram_specific_recommendations(content_data, brand)
    recommendations = []

    # Check for hashtag strategy
    content_text = extract_all_text(content_data)
    hashtag_count = content_text.scan(/#\w+/).length

    if hashtag_count < 5
      recommendations << "Add more relevant hashtags (aim for 5-10 targeted hashtags)"
    elsif hashtag_count > 15
      recommendations << "Reduce hashtag count - quality over quantity works better"
    end

    # Visual content recommendations
    unless content_data.dig('data', 'visual_elements')
      recommendations << "Ensure high-quality, visually appealing images or videos"
      recommendations << "Consider using carousel format for multiple products/features"
    end

    recommendations
  end

  def tiktok_specific_recommendations(content_data, brand)
    recommendations = [
      "Hook viewers in the first 3 seconds with a compelling opening",
      "Keep content authentic and unpolished - perfection isn't the goal",
      "Use trending sounds and participate in challenges",
      "Include captions for accessibility and silent viewing"
    ]

    if brand == 'phrendly'
      recommendations << "Create content that encourages duets and responses"
      recommendations << "Show real user interactions and success stories"
    end

    recommendations
  end

  def twitter_specific_recommendations(content_data, brand)
    recommendations = []

    content_text = extract_all_text(content_data)

    # Check for engagement elements
    unless content_text.match?(/\?|what|how|which|poll/i)
      recommendations << "Add questions or polls to increase engagement"
    end

    # Check for hashtag usage
    if content_text.scan(/#\w+/).length > 2
      recommendations << "Limit hashtags to 1-2 per tweet for better engagement"
    end

    recommendations << "Consider creating a thread for longer-form content"
    recommendations << "Engage with replies within the first hour of posting"

    recommendations
  end

  def calculate_optimization_score(content_data, practices, brand)
    # Complex scoring algorithm based on multiple factors
    base_score = 50

    # Character limit compliance
    char_analysis = analyze_character_limits(content_data, practices[:character_limits])
    char_score = char_analysis.values.count { |v| v[:status] == 'within_limit' }.to_f / char_analysis.length * 30

    # Best practices compliance
    compliance = check_best_practices_compliance(content_data, practices[:best_practices], brand)
    compliance_score = compliance[:score] * 0.2

    (base_score + char_score + compliance_score).round
  end

  def extract_all_text(content_data)
    text_fields = %w[subject body title caption text content]
    all_text = ""

    text_fields.each do |field|
      value = content_data.dig('data', field)
      all_text += " #{value}" if value.is_a?(String)
    end

    all_text.strip
  end

  def get_brand_keywords(brand)
    case brand
    when 'everclear'
      %w[clarity insight guidance spiritual mystical trust empowerment]
    when 'phrendly'
      %w[fun flirt connect chat social playful drinks phrends]
    else
      []
    end
  end

  def generate_compliance_suggestions(checks, practices)
    failed_checks = checks.select { |check| check[:status] == 'fail' }

    suggestions = failed_checks.map do |check|
      "Improve: #{check[:practice]}"
    end

    suggestions + practices.sample(2)
  end

  def suggest_utm_source(channel, brand)
    case channel
    when 'email'
      "#{brand}-newsletter"
    when 'facebook', 'instagram', 'tiktok', 'twitter'
      "#{brand}-#{channel}"
    else
      "#{brand}-#{channel}"
    end
  end

  def suggest_utm_medium(channel)
    case channel
    when 'email'
      'email'
    when 'facebook', 'instagram', 'tiktok', 'twitter'
      'social'
    else
      'marketing'
    end
  end

  def build_example_utm_url(channel, campaign, brand)
    base_url = "https://example.com/landing"
    source = suggest_utm_source(channel, brand)
    medium = suggest_utm_medium(channel)

    "#{base_url}?utm_source=#{source}&utm_medium=#{medium}&utm_campaign=#{campaign}&utm_content=example-content"
  end

  def utm_best_practices
    [
      "Use consistent naming conventions across all campaigns",
      "Keep UTM parameters lowercase and use hyphens instead of spaces",
      "Be specific but concise with utm_content to identify different creative versions",
      "Always use utm_source and utm_medium at minimum",
      "Create a UTM tracking spreadsheet to maintain consistency",
      "Test your UTM links before launching campaigns",
      "Use URL shorteners for social media to avoid long, cluttered links"
    ]
  end

  def utm_naming_conventions
    {
      campaign: "Use format: goal-timeframe-descriptor (e.g., 'signup-q4-holiday')",
      source: "Identify the specific website or platform (e.g., 'facebook', 'newsletter')",
      medium: "Identify the marketing medium (e.g., 'email', 'cpc', 'social')",
      content: "Differentiate similar content or links (e.g., 'header-cta', 'footer-link')"
    }
  end

  def generate_ga4_setup_guide(events)
    {
      overview: "Set up these recommended events to track user behavior effectively",
      events: events.map do |event|
        {
          event_name: event,
          description: get_ga4_event_description(event),
          implementation: get_ga4_implementation_guide(event)
        }
      end,
      next_steps: [
        "Install GA4 tracking code on your website",
        "Set up Google Tag Manager for easier event management",
        "Create custom conversions based on your business goals",
        "Set up attribution reporting to understand customer journeys"
      ]
    }
  end

  def get_ga4_event_description(event)
    descriptions = {
      'page_view' => 'Tracks when users view pages on your website',
      'purchase' => 'Tracks completed purchases with transaction details',
      'add_to_cart' => 'Tracks when items are added to shopping cart',
      'begin_checkout' => 'Tracks when checkout process is initiated',
      'sign_up' => 'Tracks user registration or account creation',
      'login' => 'Tracks user login events',
      'search' => 'Tracks internal site searches',
      'video_start' => 'Tracks when video playback begins',
      'file_download' => 'Tracks file downloads from your site'
    }

    descriptions[event] || "Custom event for tracking specific user interactions"
  end

  def get_ga4_implementation_guide(event)
    case event
    when 'purchase'
      "gtag('event', 'purchase', { transaction_id: 'T12345', value: 25.42, currency: 'USD', items: [...] });"
    when 'sign_up'
      "gtag('event', 'sign_up', { method: 'email' });"
    when 'login'
      "gtag('event', 'login', { method: 'email' });"
    else
      "gtag('event', '#{event}');"
    end
  end

  def build_platform_optimization_prompt(platform, content_data, brand, practices)
    content_text = extract_all_text(content_data)

    "You are an expert #{platform} marketing strategist. Optimize the following content for #{brand}:\n\n" +
    "Content: #{content_text}\n\n" +
    "Platform best practices to follow: #{practices[:best_practices].join(', ')}\n\n" +
    "Provide 3 optimized versions that are more engaging and follow #{platform} best practices."
  end

  def get_ai_enhanced_copy(prompt)
    # This would integrate with OpenAI to get enhanced copy suggestions
    # For now, return placeholder
    [
      "Enhanced version 1 with improved engagement",
      "Enhanced version 2 with stronger CTA",
      "Enhanced version 3 with better platform optimization"
    ]
  end

  def analyze_email_character_limits(content_data)
    email_limits = PLATFORM_BEST_PRACTICES[:email][:character_limits]
    analysis = {}

    email_limits.each do |field, limit|
      content = content_data.dig('data', field.to_s) || ''
      char_count = content.length

      analysis[field] = {
        current_count: char_count,
        limit: limit,
        remaining: limit - char_count,
        status: char_count <= limit ? 'within_limit' : 'exceeds_limit',
        percentage_used: (char_count.to_f / limit * 100).round(1),
        recommendations: get_character_limit_recommendations(field, char_count, limit)
      }
    end

    analysis
  end

  def analyze_subject_line(subject_line)
    return {} unless subject_line

    analysis = {
      length_analysis: {
        character_count: subject_line.length,
        word_count: subject_line.split.length,
        optimal_range: subject_line.length.between?(30, 50),
        mobile_friendly: subject_line.length <= 40
      },
      content_analysis: {
        has_personalization: subject_line.include?('{{') || subject_line.include?('%'),
        has_urgency: !!(subject_line.match(/\b(urgent|limited|expires|last chance|hurry)\b/i)),
        has_curiosity: subject_line.include?('?') || subject_line.match(/\b(secret|revealed|discover)\b/i),
        has_numbers: !!(subject_line.match(/\d+/)),
        has_emojis: !!(subject_line.match(/[\u{1F600}-\u{1F6FF}]/))
      },
      spam_triggers: identify_spam_triggers(subject_line),
      engagement_predictors: predict_engagement_factors(subject_line)
    }

    analysis[:recommendations] = generate_subject_line_recommendations(analysis)
    analysis
  end

  def analyze_email_content_quality(content_data, brand)
    content_body = content_data.dig('data', 'body') || ''

    quality_factors = {
      readability: analyze_readability(content_body),
      brand_voice_alignment: check_brand_voice_alignment(content_body, brand),
      cta_analysis: analyze_call_to_actions(content_body),
      personalization_level: assess_personalization_level(content_data),
      value_proposition: evaluate_value_proposition(content_body, brand),
      content_structure: analyze_content_structure(content_body)
    }

    {
      overall_quality_score: calculate_content_quality_score(quality_factors),
      factor_breakdown: quality_factors,
      improvement_suggestions: generate_content_improvements(quality_factors, brand)
    }
  end

  def check_email_design_compliance(content_data)
    design_guidelines = PLATFORM_BEST_PRACTICES[:email][:design_guidelines]

    compliance_checks = {
      mobile_responsive: check_mobile_responsiveness(content_data),
      font_size_compliance: check_font_sizes(content_data),
      cta_button_size: check_cta_button_specifications(content_data),
      color_contrast: assess_color_contrast(content_data),
      image_optimization: check_image_optimization(content_data),
      alt_text_present: verify_alt_text_presence(content_data)
    }

    compliance_score = compliance_checks.values.count(true).to_f / compliance_checks.length * 100

    {
      compliance_score: compliance_score.round,
      checks: compliance_checks,
      recommendations: generate_design_recommendations(compliance_checks),
      priority_fixes: identify_priority_design_fixes(compliance_checks)
    }
  end

  def calculate_deliverability_score(content_data, brand)
    factors = {
      content_quality: 30,
      sender_reputation: 25,
      list_hygiene: 20,
      authentication: 15,
      engagement_history: 10
    }

    # Simplified scoring based on available data
    base_score = 70
    content_body = content_data.dig('data', 'body') || ''
    subject_line = content_data.dig('data', 'subject') || ''

    # Adjust based on spam triggers
    spam_triggers = identify_spam_triggers(subject_line + ' ' + content_body)
    base_score -= spam_triggers.length * 5

    # Adjust based on content quality
    if has_clear_cta?(content_body)
      base_score += 5
    end

    if has_proper_unsubscribe?(content_body)
      base_score += 5
    end

    [base_score, 100].min
  end

  def identify_personalization_opportunities(content_data)
    opportunities = []
    content_body = content_data.dig('data', 'body') || ''
    subject_line = content_data.dig('data', 'subject') || ''

    unless subject_line.include?('{{') || subject_line.include?('%')
      opportunities << {
        type: 'subject_line',
        suggestion: 'Add recipient name personalization',
        impact: 'Can increase open rates by 15-25%'
      }
    end

    unless content_body.match(/\{\{.*name.*\}\}/i)
      opportunities << {
        type: 'greeting',
        suggestion: 'Personalize email greeting with recipient name',
        impact: 'Improves engagement and click-through rates'
      }
    end

    opportunities << {
      type: 'content',
      suggestion: 'Include behavioral-based content recommendations',
      impact: 'Can increase click-through rates by 30-50%'
    }

    opportunities << {
      type: 'timing',
      suggestion: 'Send emails based on recipient timezone and engagement patterns',
      impact: 'Can improve open rates by 10-20%'
    }

    opportunities
  end

  def suggest_automation_workflows(campaign_type, brand)
    case campaign_type.downcase
    when /welcome|onboard/
      EMAIL_AUTOMATION_WORKFLOWS[:welcome_series]
    when /cart|abandon/
      EMAIL_AUTOMATION_WORKFLOWS[:abandoned_cart]
    when /retention|winback/
      EMAIL_AUTOMATION_WORKFLOWS[:re_engagement]
    when /purchase|order/
      EMAIL_AUTOMATION_WORKFLOWS[:post_purchase]
    else
      EMAIL_AUTOMATION_WORKFLOWS[:welcome_series]
    end
  end

  def verify_gdpr_compliance(content_data)
    content_body = content_data.dig('data', 'body') || ''

    compliance_checks = {
      has_unsubscribe_link: has_proper_unsubscribe?(content_body),
      has_privacy_policy_link: content_body.include?('privacy policy'),
      clear_sender_identification: content_data.dig('data', 'sender_name').present?,
      consent_reminder: content_body.match(/subscribed|opted.?in/i).present?
    }

    compliance_score = compliance_checks.values.count(true).to_f / compliance_checks.length * 100

    {
      compliance_score: compliance_score.round,
      checks: compliance_checks,
      missing_requirements: GDPR_COMPLIANCE_CHECKLIST.select.with_index { |_, i| !compliance_checks.values[i] },
      recommendations: generate_compliance_recommendations(compliance_checks)
    }
  end

  def calculate_email_optimization_score(content_data, brand)
    factors = {
      subject_line_quality: analyze_subject_line_score(content_data.dig('data', 'subject')),
      content_quality: analyze_content_score(content_data.dig('data', 'body'), brand),
      design_compliance: check_design_score(content_data),
      personalization: assess_personalization_score(content_data),
      deliverability: calculate_deliverability_score(content_data, brand)
    }

    # Weighted average
    total_score = (
      factors[:subject_line_quality] * 0.25 +
      factors[:content_quality] * 0.30 +
      factors[:design_compliance] * 0.20 +
      factors[:personalization] * 0.15 +
      factors[:deliverability] * 0.10
    )

    total_score.round
  end

  # Helper methods for email analysis
  def identify_spam_triggers(text)
    spam_words = ['free', 'guarantee', 'limited time', 'act now', 'buy now', 'click here',
                  'congratulations', 'winner', 'cash', 'money back', 'risk free', 'save big']

    triggers = []
    spam_words.each do |word|
      triggers << word if text.downcase.include?(word)
    end

    # Check for excessive punctuation
    if text.count('!') > 2
      triggers << 'excessive exclamation marks'
    end

    if text.match(/[A-Z]{5,}/)
      triggers << 'excessive capitalization'
    end

    triggers
  end

  def has_clear_cta?(content)
    cta_patterns = [
      /\b(click here|learn more|get started|sign up|buy now|shop now|download|subscribe)\b/i,
      /<a\s+[^>]*href\s*=\s*["'][^"']*["'][^>]*>/i,
      /\[.*\]\(.*\)/  # Markdown links
    ]

    cta_patterns.any? { |pattern| content.match?(pattern) }
  end

  def has_proper_unsubscribe?(content)
    unsubscribe_patterns = [
      /unsubscribe/i,
      /opt.?out/i,
      /manage.*preferences/i,
      /update.*subscription/i
    ]

    unsubscribe_patterns.any? { |pattern| content.match?(pattern) }
  end

  def analyze_subject_line_score(subject_line)
    return 0 unless subject_line

    score = 50  # Base score

    # Length optimization
    score += 15 if subject_line.length.between?(30, 50)
    score -= 10 if subject_line.length > 60

    # Engagement factors
    score += 10 if subject_line.include?('?')  # Curiosity
    score += 10 if subject_line.match?(/\d+/)  # Numbers
    score += 5 if subject_line.match?(/\b(you|your)\b/i)  # Personal pronouns

    # Negative factors
    spam_triggers = identify_spam_triggers(subject_line)
    score -= spam_triggers.length * 5

    [score, 100].min
  end

  def analyze_content_score(content_body, brand)
    return 0 unless content_body

    score = 50  # Base score

    # Structure and readability
    score += 10 if content_body.split.length.between?(50, 200)  # Optimal length
    score += 10 if has_clear_cta?(content_body)
    score += 5 if content_body.split("\n").length > 3  # Good structure

    # Brand alignment
    brand_keywords = get_brand_keywords(brand)
    if brand_keywords.any? { |word| content_body.downcase.include?(word) }
      score += 15
    end

    # Negative factors
    spam_triggers = identify_spam_triggers(content_body)
    score -= spam_triggers.length * 3

    [score, 100].min
  end

  def check_design_score(content_data)
    # Simplified design scoring based on available data
    score = 70  # Base score assuming basic compliance

    # Check for image optimization hints
    if content_data.dig('data', 'images_optimized')
      score += 15
    end

    # Check for mobile responsiveness hints
    if content_data.dig('data', 'mobile_responsive')
      score += 15
    end

    score
  end

  def assess_personalization_score(content_data)
    score = 0

    subject_line = content_data.dig('data', 'subject') || ''
    content_body = content_data.dig('data', 'body') || ''

    # Check for personalization tokens
    if subject_line.include?('{{') || subject_line.include?('%')
      score += 30
    end

    if content_body.include?('{{') || content_body.include?('%')
      score += 40
    end

    # Check for personal pronouns
    if (subject_line + content_body).match?(/\b(you|your)\b/i)
      score += 20
    end

    # Dynamic content indicators
    if content_data.dig('data', 'dynamic_content')
      score += 10
    end

    score
  end

  # Additional helper methods would continue here...
  # (methods for brand-specific segments, automation customizations, etc.)

  def get_brand_specific_segments(brand)
    case brand
    when 'everclear'
      [
        "First-time reading seekers",
        "Regular spiritual guidance users",
        "Specific life area focus (love, career, life)",
        "Preferred advisor types",
        "Reading frequency patterns"
      ]
    when 'phrendly'
      [
        "Active chat participants",
        "Drink purchasers vs. earners",
        "Profile completion levels",
        "Interaction frequency patterns",
        "Preferred conversation topics"
      ]
    else
      ["General engagement levels", "Purchase behavior", "Content preferences"]
    end
  end

  def map_campaign_to_automation(campaign_type)
    case campaign_type.downcase
    when /welcome|onboard/ then :welcome_series
    when /cart|abandon/ then :abandoned_cart
    when /retention|winback/ then :re_engagement
    when /purchase|order/ then :post_purchase
    else :welcome_series
    end
  end

  def customize_workflow_for_brand(base_workflow, brand)
    customized = base_workflow.dup

    case brand
    when 'everclear'
      customized[:description] = "Spiritual guidance journey: #{customized[:description]}"
    when 'phrendly'
      customized[:description] = "Social connection experience: #{customized[:description]}"
    end

    customized
  end

  # ... rest of existing methods remain the same ...
end
