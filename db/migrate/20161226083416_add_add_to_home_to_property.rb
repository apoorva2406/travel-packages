class AddAddToHomeToProperty < ActiveRecord::Migration
  def change
  	add_column :properties, :add_to_home, :boolean, :default => false
  end
end
