class CopyGradingJob < ApplicationJob
  queue_as :default

  def perform(campaign_id, node_id, job_id)
    campaign = Campaign.find(campaign_id)
    background_job = BackgroundJob.find_by(job_id: job_id)
    node = campaign.find_node(node_id)

    return unless background_job && node

    background_job.mark_as_processing!

    begin
      openai_service = OpenaiService.new
      result = openai_service.grade_copy(
        brand: campaign.brand,
        node_data: node,
        node_type: node['type']
      )

      background_job.mark_as_complete!(result)
    rescue => e
      background_job.mark_as_failed!(e.message)
    end
  end
end
