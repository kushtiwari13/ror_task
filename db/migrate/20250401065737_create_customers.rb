class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email, null: false
      t.string :password_digest

      t.timestamps
    end
    add_index :customers, :email, unique: true
  end
end
