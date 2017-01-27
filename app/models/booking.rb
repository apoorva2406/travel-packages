class Booking < ActiveRecord::Base
	extend FriendlyId
  friendly_id :book_type, use: :slugged
	belongs_to :user
	validates :name, :phone, :book_type, :start_date, :end_date, :user_id, :property_id, :total_amount,:seats, presence: true
	belongs_to :property
	has_one :payment, :foreign_key => "booking_id", :dependent => :destroy
	#after_create :send_mail_to_owner

	def send_mail_to_owner
		UserMailer.booking_client_email(self).deliver
		UserMailer.booking_owner_email(self).deliver
	end

	def booking_message
    begin
      @client = Twilio::REST::Client.new ENV['account_sid'], ENV['auth_token']
      property = self.try(:property)
      booking_user_no =  '+919910116603' #self.try(:phone)
      owner_no = '+919910116603' #property.user.try(:mobile_no)

      @client.account.messages.create(
        :body => "You have successfully booked #{property.try(:name)}. Booking start_date #{self.try(:start_date)} to #{self.try(:end_date)}, total amount is #{self.try(:total_amount)}",
        :to => "#{booking_user_no}",    
        :from => "++12173647554"
      ) 

      @client.account.messages.create(
        :body => "Your property #{property.try(:name)} booked by #{self.try(:name)}. Booking start_date #{self.try(:start_date)} to #{self.try(:end_date)}, total amount is #{self.try(:total_amount)}",
        :to => "#{owner_no}",    
        :from => "++12173647554"
      )  

      message = "Otp send successfully"
    rescue Twilio::REST::RequestError => e
      message = "Something is wrong"
    end
  end
 

	def params_list_patym
		amount = self.user.eql?(self.property.user) ? 0 : self.total_amount
		paramList = Hash.new
		paramList["MID"] = ENV['MID']
		paramList["INDUSTRY_TYPE_ID"] = ENV['INDUSTRY_TYPE_ID']
		paramList["CHANNEL_ID"] = ENV['CHANNEL_ID']
		paramList["WEBSITE"] = ENV['WEBSITE']
		paramList["TXN_AMOUNT"] = "2" #amount
		paramList["ORDER_ID"] = SecureRandom.urlsafe_base64(nil, false)
		paramList["CUST_ID"] = SecureRandom.urlsafe_base64(nil, false)  
		paramList
	end

	def self.unconfirmed_booking
		@bookings = Booking.where(status: 'not confirm').where("created_at <= ?", Time.now - 24.hours)
		@bookings.delete_all
	end
end
