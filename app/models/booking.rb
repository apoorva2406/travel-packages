class Booking < ActiveRecord::Base
	belongs_to :user

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
