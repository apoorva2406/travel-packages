class AddRentStatusToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :rent_status, :string
  end
end
