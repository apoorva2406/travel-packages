class ChangeValue < ActiveRecord::Migration
  def change
  	change_column :bookings, :status, :string, :default => 'not confirm'
  end
end
