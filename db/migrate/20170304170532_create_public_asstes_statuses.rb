class CreatePublicAsstesStatuses < ActiveRecord::Migration
  def change
    create_table :public_asstes_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
