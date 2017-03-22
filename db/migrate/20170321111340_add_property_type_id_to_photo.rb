class AddPropertyTypeIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :property_type_id, :integer
  end
end
