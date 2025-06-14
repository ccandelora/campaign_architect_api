class Api::V1::CampaignsController < Api::V1::BaseController
  before_action :set_campaign, only: [:show, :update, :destroy, :grade_copy, :analyze, :preflight_check, :log_performance, :performance_comparison, :update_status, :update_utm_settings, :build_utm_url, :ai_rewrite, :export]

  def index
    campaigns = current_user.campaigns.order(created_at: :desc)
    render json: { campaigns: campaigns.map(&method(:campaign_data)) }
  end

  def show
    render json: { campaign: campaign_data(@campaign) }
  end

  def create
    campaign = current_user.campaigns.build(campaign_params)

    if campaign.save
      render json: { campaign: campaign_data(campaign) }, status: :created
    else
      render json: { errors: campaign.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @campaign.update(campaign_params)
      render json: { message: 'Campaign saved successfully.' }
    else
      render json: { errors: @campaign.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @campaign.destroy
    render json: { message: 'Campaign deleted successfully.' }
  end

  def grade_copy
    node_id = params[:node_id]
    node = @campaign.find_node(node_id)

    return render json: { error: 'Node not found' }, status: :not_found unless node

    job_id = SecureRandom.uuid
    background_job = @campaign.background_jobs.create!(
      job_id: job_id,
      job_type: 'copy_grading',
      status: 'pending'
    )

    CopyGradingJob.perform_later(@campaign.id, node_id, job_id)

    render json: { job_id: job_id, status: 'pending' }
  end

  def analyze
    job_id = SecureRandom.uuid
    background_job = @campaign.background_jobs.create!(
      job_id: job_id,
      job_type: 'funnel_analysis',
      status: 'pending'
    )

    FunnelAnalysisJob.perform_later(@campaign.id, job_id)

    render json: { job_id: job_id, status: 'pending' }
  end

  # POST /api/v1/campaigns/:id/preflight_check
  def preflight_check
    checker = PreflightChecker.new(@campaign)
    result = checker.analyze

    render json: {
      readiness_score: result[:score],
      total_checks: result[:total_checks],
      passed_checks: result[:passed_checks],
      checks: result[:checks],
      recommendations: result[:recommendations]
    }
  end

  # GET /api/v1/campaigns/templates
  def templates
    templates = CampaignTemplate.all
    templates = templates.for_brand(params[:brand]) if params[:brand].present?
    templates = templates.for_goal(params[:goal]) if params[:goal].present?

    render json: {
      templates: templates.map do |template|
        {
          id: template.id,
          name: template.name,
          brand: template.brand,
          goal: template.goal,
          description: template.description,
          recommended: template.recommended?,
          complexity: template.complexity_level,
          setup_time: template.estimated_setup_time,
          metadata: template.metadata
        }
      end,
      goals: CampaignTemplate.goals,
      audience_segments: CampaignTemplate.audience_segments
    }
  end

  # POST /api/v1/campaigns/from_template
  def from_template
    template = CampaignTemplate.find(params[:template_id])

    campaign = current_user.campaigns.build(
      name: params[:name] || "#{template.name} - #{Date.current.strftime('%b %d')}",
      brand: template.brand,
      goal: params[:goal] || template.goal,
      structure: template.structure
    )

    if campaign.save
      render json: { campaign: campaign }, status: :created
    else
      render json: { errors: campaign.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/campaigns/:id/log_performance
  def log_performance
    metrics = params.require(:metrics).permit!.to_h

    @campaign.log_performance!(metrics)

    render json: {
      message: 'Performance logged successfully',
      campaign: campaign_data(@campaign).merge(
        status: @campaign.status,
        predicted_vs_actual: @campaign.predicted_vs_actual
      )
    }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /api/v1/campaigns/:id/performance_comparison
  def performance_comparison
    comparison = @campaign.predicted_vs_actual

    if comparison
      render json: {
        campaign: {
          id: @campaign.id,
          name: @campaign.name,
          status: @campaign.status
        },
        comparison: comparison
      }
    else
      render json: {
        error: 'No performance data available for comparison'
      }, status: :not_found
    end
  end

  # PATCH /api/v1/campaigns/:id/status
  def update_status
    new_status = params.require(:status)

    if @campaign.update(status: new_status)
      render json: {
        message: 'Status updated successfully',
        campaign: campaign_data(@campaign).merge(status: @campaign.status)
      }
    else
      render json: { errors: @campaign.errors }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/campaigns/:id/utm_settings
  def update_utm_settings
    utm_params = params.require(:utm).permit(:source, :medium, :campaign)

    @campaign.set_utm_parameters(
      source: utm_params[:source],
      medium: utm_params[:medium],
      campaign: utm_params[:campaign]
    )

    render json: {
      message: 'UTM settings updated successfully',
      utm_parameters: @campaign.utm_parameters
    }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /api/v1/campaigns/:id/build_utm_url
  def build_utm_url
    base_url = params.require(:base_url)
    content_tag = params[:content_tag]

    utm_url = @campaign.build_utm_url(base_url, content_tag)

    render json: {
      original_url: base_url,
      utm_url: utm_url,
      utm_parameters: @campaign.utm_parameters
    }
  end

  # POST /api/v1/campaigns/:id/ai_rewrite
  def ai_rewrite
    text = params.require(:text)
    intent = params.require(:intent) # 'improve', 'make_empathetic', 'make_playful', 'shorten', 'lengthen', 'suggest_headlines'
    node_type = params[:node_type] || 'email'

    job_id = SecureRandom.uuid
    background_job = @campaign.background_jobs.create!(
      job_id: job_id,
      job_type: 'ai_rewrite',
      status: 'pending'
    )

    AiRewriteJob.perform_later(@campaign.id, text, intent, node_type, job_id)

    render json: { job_id: job_id, status: 'pending' }
  end

  # GET /api/v1/campaigns/:id/export
  def export
    format = params[:format] || 'pdf'

    case format
    when 'pdf'
      job_id = SecureRandom.uuid
      background_job = @campaign.background_jobs.create!(
        job_id: job_id,
        job_type: 'pdf_export',
        status: 'pending'
      )

      CampaignExportJob.perform_later(@campaign.id, format, job_id)

      render json: {
        job_id: job_id,
        status: 'pending',
        message: 'PDF export started. You will receive a download link when ready.'
      }
    else
      render json: { error: 'Unsupported export format' }, status: :unprocessable_entity
    end
  end

  private

  def set_campaign
    @campaign = current_user.campaigns.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :brand, :goal, structure: {}, settings: {})
  end

  def campaign_data(campaign)
    {
      id: campaign.id,
      name: campaign.name,
      brand: campaign.brand,
      goal: campaign.goal,
      structure: campaign.structure,
      settings: campaign.settings,
      status: campaign.status,
      created_at: campaign.created_at,
      updated_at: campaign.updated_at
    }
  end
end
