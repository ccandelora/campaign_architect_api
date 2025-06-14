class Campaign < ApplicationRecord
  belongs_to :user
  has_many :background_jobs, dependent: :destroy

  validates :name, presence: true
  validates :brand, presence: true, inclusion: { in: %w[everclear phrendly] }
  validates :goal, presence: true

  # Set default structure for new campaigns
  after_initialize :set_default_structure, if: :new_record?

  # Campaign status enum
  enum :status, {
    draft: 0,
    approved: 1,
    live: 2,
    completed: 3
  }

  # Scopes
  scope :for_brand, ->(brand) { where(brand: brand) }
  scope :for_goal, ->(goal) { where(goal: goal) }
  scope :active, -> { where(status: [:approved, :live]) }
  scope :ready_for_postmortem, -> { where(status: :completed) }

  def nodes
    structure&.dig('nodes') || []
  end

  def edges
    structure&.dig('edges') || []
  end

  def add_node(node_data)
    current_structure = structure || { 'nodes' => [], 'edges' => [] }
    current_structure['nodes'] << node_data
    update(structure: current_structure)
  end

  def add_edge(edge_data)
    current_structure = structure || { 'nodes' => [], 'edges' => [] }
    current_structure['edges'] << edge_data
    update(structure: current_structure)
  end

  def find_node(node_id)
    nodes.find { |node| node['id'] == node_id }
  end

  def update_node(node_id, new_data)
    current_structure = structure.dup
    node_index = current_structure['nodes'].find_index { |node| node['id'] == node_id }
    return false unless node_index

    current_structure['nodes'][node_index] = current_structure['nodes'][node_index].merge(new_data)
    update(structure: current_structure)
  end

  # Performance tracking
  def log_performance!(metrics)
    update!(
      actual_performance: metrics,
      status: :completed
    )
  end

  def predicted_vs_actual
    return nil unless predicted_performance.present? && actual_performance.present?

    {
      predicted: predicted_performance,
      actual: actual_performance,
      variance: calculate_variance
    }
  end

  # UTM and tracking methods
  def utm_parameters
    settings.dig('tracking') || {}
  end

  def set_utm_parameters(source:, medium:, campaign: nil)
    campaign_name = campaign || name.parameterize
    update!(
      settings: settings.merge(
        'tracking' => {
          'source' => source,
          'medium' => medium,
          'campaign' => campaign_name
        }
      )
    )
  end

  def build_utm_url(base_url, content_tag = nil)
    utm_params = utm_parameters
    return base_url if utm_params.empty?

    params = {
      'utm_source' => utm_params['source'],
      'utm_medium' => utm_params['medium'],
      'utm_campaign' => utm_params['campaign']
    }

    params['utm_content'] = content_tag if content_tag.present?

    separator = base_url.include?('?') ? '&' : '?'
    query_string = params.compact.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join('&')

    "#{base_url}#{separator}#{query_string}"
  end

  def ga4_events
    structure['nodes']&.select { |node| node['type'] == 'ga4_event' } || []
  end

  private

  def set_default_structure
    self.structure ||= { 'nodes' => [], 'edges' => [] }
  end

  def calculate_variance
    return {} unless predicted_performance.present? && actual_performance.present?

    variance = {}
    predicted_performance.each do |metric, predicted_value|
      actual_value = actual_performance[metric]
      if predicted_value.present? && actual_value.present?
        variance[metric] = {
          predicted: predicted_value,
          actual: actual_value,
          difference: actual_value - predicted_value,
          percentage_change: ((actual_value - predicted_value) / predicted_value.to_f * 100).round(2)
        }
      end
    end
    variance
  end
end
