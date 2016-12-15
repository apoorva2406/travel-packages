class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :property_id
      t.integer :booking_id
      t.string :mid
      t.string :order_id
      t.float :amount
      t.string :curency
      t.string :txn_id
      t.string :banktxn_id
      t.string :status
      t.string :txn_date
      t.string :gateway_name
      t.string :bank_name
      t.string :payment_mode
      t.string :checksum_key

      t.timestamps null: false
    end
  end
end
