class AddOtpCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :otp_code, :string
    add_column :users, :verified, :boolean, :default => false
  end
end
