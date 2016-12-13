class AddVarifiedToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :varified, :boolean, :default => false
  end
end
