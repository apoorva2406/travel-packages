class CreatePropertyTypeManages < ActiveRecord::Migration
  def change
    create_table :property_type_manages do |t|
      t.integer :property_id
      t.integer :property_type_id

      t.timestamps null: false
    end
  end
end
