class AddWalkInToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :walk_in, :boolean, :default => false
  end
end
