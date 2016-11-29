class CreatePropertyPrices < ActiveRecord::Migration
  def change
    create_table :property_prices do |t|
      t.integer :seats
      t.float :price
      t.integer :property_id
      t.integer :property_type_id

      t.timestamps null: false
    end
  end
end
