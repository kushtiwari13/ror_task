class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :event
  belongs_to :ticket

  validates :quantity, numericality: { greater_than: 0 }
end
