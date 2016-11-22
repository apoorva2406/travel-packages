class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.string :properties_type
      t.integer :no_of_seats
      t.string :contact_person
      t.string :address
      t.string :facilities
      t.string :access_day
      t.string :start_date
      t.string :end_date
      t.integer :user_id
      t.float :latitude
      t.float :longitude
      t.timestamps null: false
    end
  end
end
