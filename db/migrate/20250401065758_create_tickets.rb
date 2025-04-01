class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :ticket_type
      t.decimal :price, precision: 8, scale: 2
      t.integer :availability
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
