class PreflightChecker
  def initialize(campaign)
    @campaign = campaign
    @checks = []
    @recommendations = []
  end

  def analyze
    run_content_checks
    run_funnel_logic_checks
    run_strategic_checks
    run_data_checks

    passed_checks = @checks.count { |check| check[:status] == 'passed' }
    total_checks = @checks.length
    score = total_checks > 0 ? ((passed_checks.to_f / total_checks) * 100).round : 0

    {
      score: score,
      total_checks: total_checks,
      passed_checks: passed_checks,
      checks: @checks,
      recommendations: @recommendations
    }
  end

  private

  def run_content_checks
    check_email_subjects
    check_email_bodies
    check_ai_copy_grades
  end

  def run_funnel_logic_checks
    check_node_connections
    check_conditional_paths
    check_orphaned_nodes
  end

  def run_strategic_checks
    check_channel_diversity
    check_utm_parameters
    check_mobile_optimization
  end

  def run_data_checks
    check_target_audience
    check_performance_simulation
  end

  def check_email_subjects
    email_nodes = nodes_by_type('email')
    missing_subjects = email_nodes.select { |node| node.dig('data', 'subject').blank? }

    if missing_subjects.empty?
      add_check('content', 'All email subject lines are filled out', 'passed')
    else
      add_check('content', "#{missing_subjects.length} email(s) missing subject lines", 'failed')
      missing_subjects.each do |node|
        add_recommendation("Add subject line to '#{node.dig('data', 'name') || 'Unnamed Email'}'")
      end
    end
  end

  def check_email_bodies
    email_nodes = nodes_by_type('email')
    missing_bodies = email_nodes.select { |node| node.dig('data', 'body').blank? }

    if missing_bodies.empty?
      add_check('content', 'All email bodies are filled out', 'passed')
    else
      add_check('content', "#{missing_bodies.length} email(s) missing body content", 'warning')
      missing_bodies.each do |node|
        add_recommendation("Add body content to '#{node.dig('data', 'name') || 'Unnamed Email'}'")
      end
    end
  end

  def check_ai_copy_grades
    # This would check if AI grading has been run and scores are acceptable
    # For now, we'll simulate this check
    email_nodes = nodes_by_type('email')

    if email_nodes.any?
      add_check('content', 'AI Copy Grading recommended for all emails', 'warning')
      add_recommendation('Run "Grade My Copy" on all email nodes to ensure brand compliance')
    end
  end

  def check_node_connections
    nodes = @campaign.structure&.dig('nodes') || []
    edges = @campaign.structure&.dig('edges') || []

    return if nodes.empty?

    connected_nodes = Set.new
    edges.each do |edge|
      connected_nodes.add(edge['source'])
      connected_nodes.add(edge['target'])
    end

    orphaned = nodes.reject { |node| connected_nodes.include?(node['id']) }

    if orphaned.empty?
      add_check('logic', 'All nodes are properly connected', 'passed')
    else
      add_check('logic', "#{orphaned.length} orphaned node(s) found", 'failed')
      orphaned.each do |node|
        add_recommendation("Connect '#{node.dig('data', 'name') || node['id']}' to the campaign flow")
      end
    end
  end

  def check_conditional_paths
    conditional_nodes = nodes_by_type('conditional')

    conditional_nodes.each do |node|
      node_id = node['id']
      outgoing_edges = edges_from_node(node_id)

      if outgoing_edges.length < 2
        add_check('logic', "Conditional split '#{node.dig('data', 'name') || node_id}' needs both Yes and No paths", 'failed')
        add_recommendation("Add both 'Yes' and 'No' paths to conditional split '#{node.dig('data', 'name') || node_id}'")
      end
    end

    if conditional_nodes.any? && @checks.none? { |c| c[:category] == 'logic' && c[:status] == 'failed' && c[:message].include?('Conditional') }
      add_check('logic', 'All conditional splits have proper paths', 'passed')
    end
  end

  def check_orphaned_nodes
    # This is covered in check_node_connections, but we can add specific logic here
  end

  def check_channel_diversity
    node_types = (@campaign.structure&.dig('nodes') || []).map { |n| n['type'] }.uniq

    if node_types.include?('email') && (node_types.include?('push') || node_types.include?('ad'))
      add_check('strategy', 'Campaign includes multiple channels for better reach', 'passed')
    elsif node_types.include?('email')
      add_check('strategy', 'Consider adding push notifications or ads for multi-channel approach', 'warning')
      add_recommendation('Add push notification or ad nodes to increase campaign effectiveness')
    else
      add_check('strategy', 'Campaign needs at least one communication channel', 'failed')
    end
  end

  def check_utm_parameters
    # Check if UTM parameters are planned (this would be in metadata or notes)
    add_check('strategy', 'UTM parameter plan recommended for tracking', 'warning')
    add_recommendation('Plan UTM parameters for all links to ensure proper tracking in Google Analytics')
  end

  def check_mobile_optimization
    has_push = nodes_by_type('push').any?

    if has_push
      add_check('strategy', 'Campaign includes mobile push notifications', 'passed')
    else
      add_check('strategy', 'Consider adding push notifications for mobile users', 'warning')
      add_recommendation('Add push notification nodes to engage mobile users effectively')
    end
  end

  def check_target_audience
    if @campaign.goal.present?
      add_check('data', 'Campaign goal is defined', 'passed')
    else
      add_check('data', 'Campaign goal needs to be defined', 'failed')
      add_recommendation('Define a clear campaign goal to measure success')
    end
  end

  def check_performance_simulation
    # This would check if performance simulation has been run
    add_check('data', 'Performance simulation recommended', 'warning')
    add_recommendation('Run performance simulation to estimate campaign effectiveness')
  end

  def nodes_by_type(type)
    (@campaign.structure&.dig('nodes') || []).select { |node| node['type'] == type }
  end

  def edges_from_node(node_id)
    (@campaign.structure&.dig('edges') || []).select { |edge| edge['source'] == node_id }
  end

  def add_check(category, message, status)
    @checks << {
      category: category,
      message: message,
      status: status # 'passed', 'warning', 'failed'
    }
  end

  def add_recommendation(message)
    @recommendations << message
  end
end
