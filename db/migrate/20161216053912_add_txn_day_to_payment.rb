class AddTxnDayToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :txn_day, :date
  end
end
