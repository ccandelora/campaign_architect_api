class ApplicationController < ActionController::API
    def redirect_to_frontend
    # In development, redirect to the React frontend
    if Rails.env.development?
      redirect_to 'http://localhost:3000', allow_other_host: true
    else
      # In production, serve a simple API info response
      render json: {
        message: 'Campaign Architect API',
        version: '1.0',
        endpoints: '/api/v1'
      }
    end
  end
end
