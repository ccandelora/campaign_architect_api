class BackgroundJob < ApplicationRecord
  belongs_to :campaign

  validates :job_id, presence: true, uniqueness: true
  validates :job_type, presence: true
  validates :status, presence: true

  enum :status, { pending: 'pending', processing: 'processing', complete: 'complete', failed: 'failed' }
  enum :job_type, { copy_grading: 'copy_grading', funnel_analysis: 'funnel_analysis' }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(job_type: type) }

  def mark_as_processing!
    update!(status: 'processing')
  end

  def mark_as_complete!(result_data)
    update!(status: 'complete', result: result_data)
  end

  def mark_as_failed!(error_message)
    update!(status: 'failed', result: { error: error_message })
  end

  def success?
    complete?
  end

  def error_message
    result&.dig('error')
  end
end
