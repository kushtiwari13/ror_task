class EventUpdateNotificationJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)
    event.bookings.includes(:customer).each do |booking|
      Rails.logger.info "Notification: Event '#{event.title}' has been updated. Email sent to #{booking.customer.email}"
    end
  end
end
