class CreateEventOrganizers < ActiveRecord::Migration[6.1]
  def change
    create_table :event_organizers do |t|
      t.string :name
      t.string :email, null: false
      t.string :password_digest

      t.timestamps
    end
    add_index :event_organizers, :email, unique: true
  end
end
