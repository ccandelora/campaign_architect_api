class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from JWT::DecodeError, with: :invalid_token

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { error: 'Authorization token required' }, status: :unauthorized unless token

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.jwt_secret || ENV['JWT_SECRET'], true, { algorithm: 'HS256' })
      user_id = decoded_token.first['user_id']
      @current_user = User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def record_invalid(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def invalid_token
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
end
