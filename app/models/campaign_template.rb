class CampaignTemplate < ApplicationRecord
  validates :name, presence: true
  validates :brand, presence: true, inclusion: { in: %w[everclear phrendly] }
  validates :goal, presence: true
  validates :structure, presence: true
  validates :description, presence: true

  scope :for_brand, ->(brand) { where(brand: brand) }
  scope :for_goal, ->(goal) { where(goal: goal) }
  scope :recommended, -> { where("metadata->>'recommended' = 'true'") }

  def self.goals
    [
      'Acquire New Users',
      'Engage Existing Users',
      'Reactivate Lapsed Users',
      'Promote a New Feature/Offer',
      'Onboard New Earners'
    ]
  end

  def self.audience_segments
    {
      'everclear' => [
        'New Signups',
        'High LTV Spenders',
        'Dormant Users',
        'First-Time Readers',
        'Repeat Customers'
      ],
      'phrendly' => [
        'New Users',
        'Active Chatters',
        'Dormant Earners',
        'High Spenders',
        'New Earners'
      ]
    }
  end

  def recommended?
    metadata&.dig('recommended') == true
  end

  def complexity_level
    metadata&.dig('complexity') || 'beginner'
  end

  def estimated_setup_time
    metadata&.dig('setup_time') || '15 minutes'
  end
end
