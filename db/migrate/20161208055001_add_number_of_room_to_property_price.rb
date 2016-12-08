class AddNumberOfRoomToPropertyPrice < ActiveRecord::Migration
  def change
    add_column :property_prices, :number_of_room, :integer
    add_column :property_prices, :parent_id, :integer
  end
end
