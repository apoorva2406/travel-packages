class Booking < ActiveRecord::Base
	extend FriendlyId
  friendly_id :book_type, use: :slugged
	belongs_to :user
	validates :name, :phone, :book_type, :start_date, :end_date, :user_id, :property_id, :total_amount,:seats, presence: true

	def params_list_patym
		paramList = Hash.new
		paramList["MID"] = ENV['MID']
		paramList["INDUSTRY_TYPE_ID"] = ENV['INDUSTRY_TYPE_ID']
		paramList["CHANNEL_ID"] = ENV['CHANNEL_ID']
		paramList["WEBSITE"] = ENV['WEBSITE']
		paramList["TXN_AMOUNT"] = "10"
		paramList["ORDER_ID"] = SecureRandom.urlsafe_base64(nil, false)
		paramList["CUST_ID"] = SecureRandom.urlsafe_base64(nil, false)  
		paramList
	end
end
