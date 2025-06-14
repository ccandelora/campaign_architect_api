class Api::V1::JobsController < Api::V1::BaseController
  def show
    job = BackgroundJob.find_by(job_id: params[:id])

    return render json: { error: 'Job not found' }, status: :not_found unless job

    # Ensure the job belongs to the current user's campaigns
    return render json: { error: 'Unauthorized' }, status: :forbidden unless job.campaign.user == current_user

    render json: job_data(job)
  end

  private

  def job_data(job)
    {
      job_id: job.job_id,
      status: job.status,
      job_type: job.job_type,
      result: job.result,
      created_at: job.created_at,
      updated_at: job.updated_at
    }
  end
end
