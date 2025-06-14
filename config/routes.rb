Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # OAuth routes handled by OmniAuth middleware
  # /auth/:provider is automatically handled by OmniAuth
  get '/auth/:provider/callback', to: 'api/v1/auth#callback'
  get '/auth/failure', to: 'api/v1/auth#failure'

  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication
      resources :auth, only: [] do
        collection do
          get :me
        end
      end

      # Campaigns
      resources :campaigns, only: [:index, :show, :create, :update, :destroy] do
        member do
          post :grade_copy
          post :analyze
          post :preflight_check
          post :log_performance
          get :performance_comparison
          patch :update_status
          patch :update_utm_settings
          post :build_utm_url
          post :ai_rewrite
          get :export
          # Marketing Intelligence endpoints for specific campaigns
          get :ga4_events, to: 'marketing_intelligence#suggest_ga4_events'
          get :utm_recommendations, to: 'marketing_intelligence#generate_utm_recommendations'
        end
        collection do
          get :templates
          post :from_template
        end
      end

      # Campaign Templates
      resources :campaign_templates, only: [:index, :show, :create, :update, :destroy] do
        collection do
          post :create_from_campaign
        end
      end

      # Marketing Intelligence - Standalone endpoints
      namespace :marketing_intelligence do
        post :analyze_platform_content
        post :optimize_content
        post :enhance_node_copy
        post :platform_preview
        get :get_platform_best_practices
        get :get_utm_examples
        get :get_ga4_event_recommendations
        post :analyze_email_deliverability
        post :suggest_email_segmentation
        post :generate_email_automation
        get :get_email_metrics_benchmarks
        get :get_email_best_practices
        post :email_ab_testing_suggestions
        post :email_compliance_check
      end

      # AI Strategist Chat
      namespace :ai do
        post :chat
      end

      # Background jobs
      resources :jobs, only: [:show]

      # Swipe files (for future implementation)
      resources :swipe_files, only: [:index, :show, :create, :update, :destroy]
    end
  end

  # Redirect root to frontend
  root 'application#redirect_to_frontend'
end
