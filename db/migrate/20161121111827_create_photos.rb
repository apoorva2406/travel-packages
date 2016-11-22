class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :imageable_id
      t.string :imageable_type
      t.timestamps null: false
    end
    add_index :photos, [:imageable_id, :imageable_type]
  end
end
