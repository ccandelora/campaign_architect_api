class Api::V1::AuthController < ApplicationController
  # OAuth callback handler (works for any provider)
  def callback
    user = User.from_omniauth(auth_params)

    if user.persisted?
      token = generate_jwt_token(user)
      user_json = user_data(user).to_json
      frontend_url = "http://localhost:3000"

      # Redirect to frontend with auth data as URL parameters
      redirect_to "#{frontend_url}?token=#{token}&user=#{CGI.escape(user_json)}", allow_other_host: true
    else
      # On failure, redirect to frontend with error
      redirect_to "http://localhost:3000?error=authentication_failed", allow_other_host: true
    end
  end

  # OAuth failure handler
  def failure
    error_message = params[:message] || 'authentication_failed'
    redirect_to "http://localhost:3000?error=#{error_message}", allow_other_host: true
  end

  # Legacy Google-specific handler (kept for backward compatibility)
  def google
    callback
  end

  def me
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { error: 'Authorization token required' }, status: :unauthorized unless token

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.jwt_secret || ENV['JWT_SECRET'], true, { algorithm: 'HS256' })
      user_id = decoded_token.first['user_id']
      user = User.find(user_id)
      render json: { user: user_data(user) }, status: :ok
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  end

  private

  def auth_params
    request.env['omniauth.auth']
  end

  def generate_jwt_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.jwt_secret || ENV['JWT_SECRET'], 'HS256')
  end

  def user_data(user)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      provider: user.provider
    }
  end
end
