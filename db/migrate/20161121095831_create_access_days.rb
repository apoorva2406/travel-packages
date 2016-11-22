class CreateAccessDays < ActiveRecord::Migration
  def change
    create_table :access_days do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
