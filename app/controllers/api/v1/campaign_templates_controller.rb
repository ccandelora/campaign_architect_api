class Api::V1::CampaignTemplatesController < Api::V1::BaseController
  before_action :set_template, only: [:show, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @templates = CampaignTemplate.all

    # Filter by brand if specified
    @templates = @templates.for_brand(params[:brand]) if params[:brand].present?

    # Filter by goal if specified
    @templates = @templates.for_goal(params[:goal]) if params[:goal].present?

    # Include recommended templates first
    @templates = @templates.order(
      Arel.sql("CASE WHEN metadata->>'recommended' = 'true' THEN 0 ELSE 1 END"),
      :name
    )

    render json: {
      templates: @templates.map do |template|
        {
          id: template.id,
          name: template.name,
          brand: template.brand,
          goal: template.goal,
          description: template.description,
          recommended: template.recommended?,
          complexity: template.complexity_level,
          setup_time: template.estimated_setup_time,
          metadata: template.metadata,
          created_at: template.created_at
        }
      end,
      goals: CampaignTemplate.goals,
      audience_segments: CampaignTemplate.audience_segments
    }
  end

  def show
    render json: {
      id: @template.id,
      name: @template.name,
      brand: @template.brand,
      goal: @template.goal,
      description: @template.description,
      structure: @template.structure,
      metadata: @template.metadata,
      created_at: @template.created_at
    }
  end

  def create
    @template = CampaignTemplate.new(template_params)

    if @template.save
      render json: {
        id: @template.id,
        name: @template.name,
        brand: @template.brand,
        goal: @template.goal,
        description: @template.description,
        message: 'Template created successfully'
      }, status: :created
    else
      render json: { errors: @template.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @template.update(template_params)
      render json: {
        id: @template.id,
        name: @template.name,
        brand: @template.brand,
        goal: @template.goal,
        description: @template.description,
        message: 'Template updated successfully'
      }
    else
      render json: { errors: @template.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
    render json: { message: 'Template deleted successfully' }
  end

  def create_from_campaign
    campaign = current_user.campaigns.find(params[:campaign_id])

    @template = CampaignTemplate.new(
      name: params[:name],
      brand: params[:brand] || campaign.brand,
      goal: params[:goal] || campaign.goal,
      description: params[:description],
      structure: campaign.structure,
      metadata: {
        channels: extract_channels_from_structure(campaign.structure),
        complexity: params[:complexity] || 'intermediate',
        setup_time: params[:setup_time] || '15 minutes',
        recommended: false,
        created_from_campaign: true,
        original_campaign_id: campaign.id
      }
    )

    if @template.save
      render json: {
        id: @template.id,
        name: @template.name,
        message: 'Template created from campaign successfully'
      }, status: :created
    else
      render json: { errors: @template.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_template
    @template = CampaignTemplate.find(params[:id])
  end

  def template_params
    params.require(:campaign_template).permit(
      :name, :brand, :goal, :description,
      structure: {},
      metadata: {}
    )
  end

  def extract_channels_from_structure(structure)
    return [] unless structure&.dig('nodes')

    channels = structure['nodes'].map { |node| node['type'] }.uniq
    channel_mapping = {
      'email' => 'email',
      'push' => 'push',
      'ad' => 'ads',
      'social' => 'social',
      'ga4_event' => 'analytics'
    }

    channels.map { |channel| channel_mapping[channel] }.compact.uniq
  end
end
