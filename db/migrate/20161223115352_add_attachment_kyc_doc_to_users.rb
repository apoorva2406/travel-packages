class AddAttachmentKycDocToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :kyc_doc
    end
  end

  def self.down
    remove_attachment :users, :kyc_doc
  end
end
