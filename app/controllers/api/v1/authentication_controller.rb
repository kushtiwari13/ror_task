module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request, only: [:login_event_organizer, :login_customer]

      def login_event_organizer
        organizer = EventOrganizer.find_by(email: params[:email])
        if organizer && organizer.authenticate(params[:password])
          token = encode_token({ user_id: organizer.id, role: "organizer" })
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      def login_customer
        customer = Customer.find_by(email: params[:email])
        if customer && customer.authenticate(params[:password])
          token = encode_token({ user_id: customer.id, role: "customer" })
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
    end
  end
end
