class AddGenderToUser < ActiveRecord::Migration
  def change
    add_column :users, :profession, :string
    add_column :users, :experience, :string
    add_column :users, :gender, :string
  end
end
