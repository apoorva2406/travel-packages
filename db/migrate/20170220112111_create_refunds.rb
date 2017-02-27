class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.integer :payment_id
      t.integer :bank_txn_id
      t.float :refund_amount
      t.datetime :txn_date
      t.integer :resp_code
      t.string :resp_msg
      t.string :status
      t.string :refund_id
      t.string :gateway
      t.string :card_issuer

      t.timestamps null: false
    end
  end
end
