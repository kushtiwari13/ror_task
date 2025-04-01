class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JWT.decode(header, Rails.application.secret_key_base)[0]
      @current_user = find_user(decoded)
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    rescue JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def find_user(decoded)
    if decoded["role"] == "organizer"
      EventOrganizer.find_by(id: decoded["user_id"])
    elsif decoded["role"] == "customer"
      Customer.find_by(id: decoded["user_id"])
    end
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end
