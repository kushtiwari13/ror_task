class BookingConfirmationJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find(booking_id)
    Rails.logger.info "Email confirmation: Booking ##{booking.id} confirmed for customer #{booking.customer.email}"
  end
end
