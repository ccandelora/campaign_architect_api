class FunnelAnalysisJob < ApplicationJob
  queue_as :default

  def perform(campaign_id, job_id)
    campaign = Campaign.find(campaign_id)
    background_job = BackgroundJob.find_by(job_id: job_id)

    return unless background_job

    background_job.mark_as_processing!

    begin
      openai_service = OpenaiService.new
      result = openai_service.analyze_funnel(
        brand: campaign.brand,
        campaign_structure: campaign.structure
      )

      background_job.mark_as_complete!(result)
    rescue => e
      background_job.mark_as_failed!(e.message)
    end
  end
end
