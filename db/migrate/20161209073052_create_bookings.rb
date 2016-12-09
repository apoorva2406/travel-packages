class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :property_id
      t.string :name
      t.string :phone
      t.string :book_type
      t.string :seats
      t.integer :rooms
      t.date :start_date
      t.date :end_date
      t.string :status, :default => 'pending'
      t.float :total_amount

      t.timestamps null: false
    end
  end
end
