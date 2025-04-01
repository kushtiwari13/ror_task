class Ticket < ApplicationRecord
  belongs_to :event
  has_many :bookings

  validates :ticket_type, :price, :availability, presence: true
end
