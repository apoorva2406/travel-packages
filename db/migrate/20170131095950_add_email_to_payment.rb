class AddEmailToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :mihpayid, :string
    add_column :payments, :email, :string
    add_column :payments, :name_on_card, :string
    add_column :payments, :discount, :float
  end
end
