class AddSlugToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :slug, :string
  end
end
