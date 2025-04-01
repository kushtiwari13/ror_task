class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
