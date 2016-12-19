class Booking < ActiveRecord::Base
	extend FriendlyId
  friendly_id :book_type, use: :slugged
	belongs_to :user
	validates :name, :phone, :book_type, :start_date, :end_date, :user_id, :property_id, :total_amount,:seats, presence: true
	belongs_to :property
	has_one :payment, :foreign_key => "booking_id", :dependent => :destroy
	after_create :send_mail_to_owner

	def send_mail_to_owner
		UserMailer.booking_client_email(self).deliver
		UserMailer.booking_owner_email(self).deliver
	end

	def params_list_patym
		paramList = Hash.new
		paramList["MID"] = ENV['MID']
		paramList["INDUSTRY_TYPE_ID"] = ENV['INDUSTRY_TYPE_ID']
		paramList["CHANNEL_ID"] = ENV['CHANNEL_ID']
		paramList["WEBSITE"] = ENV['WEBSITE']
		paramList["TXN_AMOUNT"] = "2"
		paramList["ORDER_ID"] = SecureRandom.urlsafe_base64(nil, false)
		paramList["CUST_ID"] = SecureRandom.urlsafe_base64(nil, false)  
		paramList
	end

	def self.unconfirmed_booking
		@bookings = Booking.where(status: 'not confirm').where("created_at <= ?", Time.now - 24.hours)
		@bookings.delete_all
	end
end
