module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authorize_customer, only: [:create]

      def index
        if @current_user.is_a?(Customer)
          @bookings = @current_user.bookings
        else
          @bookings = Booking.all
        end
        render json: @bookings
      end

      def show
        @booking = Booking.find(params[:id])
        render json: @booking
      end

      def create
        @booking = @current_user.bookings.build(booking_params)
        if @booking.save
          BookingConfirmationJob.perform_later(@booking.id)
          render json: @booking, status: :created
        else
          render json: @booking.errors, status: :unprocessable_entity
        end
      end

      private

      def booking_params
        params.require(:booking).permit(:event_id, :ticket_id, :quantity)
      end

      def authorize_customer
        unless @current_user.is_a?(Customer)
          render json: { error: 'Forbidden' }, status: :forbidden
        end
      end
    end
  end
end
