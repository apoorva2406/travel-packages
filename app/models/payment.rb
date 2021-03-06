class Payment < ActiveRecord::Base
	belongs_to :user
	belongs_to :booking, :foreign_key => "booking_id"
	belongs_to :property
	has_many :refunds, :dependent => :destroy
	after_create :set_booking_status

	scope :success, -> { where(status: "TXN_SUCCESS") }

	def set_booking_status
		self.booking.update(status: "confirmed")
		#self.booking_confirmation_message
		UserMailer.booking_confirmation_client_email(self).deliver
		UserMailer.booking_confirmation_owner_email(self).deliver
	end

	def booking_confirmation_message
    begin
      @client = Twilio::REST::Client.new ENV['account_sid'], ENV['auth_token']
      property = self.try(:property)
      booking = self.try(:booking)
      booking_user_no =  '+918959294300' #booking.try(:phone)
      owner_no = '+918959294300' #property.user.try(:mobile_no)

      @client.account.messages.create(
        :body => "You have successfully confirmed booking #{property.try(:name)}. Booking start_date #{booking.try(:start_date)} to #{booking.try(:end_date)}, total amount is #{booking.try(:total_amount)}",
        :to => "#{booking_user_no}",    
        :from => "++12173647554"
      ) 

      @client.account.messages.create(
        :body => "Your property #{property.try(:name)} successfully confirmed by #{booking.try(:name)}. Booking start_date #{booking.try(:start_date)} to #{booking.try(:end_date)}, total amount is #{booking.try(:total_amount)}",
        :to => "#{owner_no}",    
        :from => "++12173647554"
      )  
      message = "Otp send successfully"
    rescue Twilio::REST::RequestError => e
      message = "Something is wrong"
    end
  end

	def create_payment(params,booking_id)
		self.mid 			=  params[:MID]
		self.order_id =  params[:ORDERID]
		self.amount   =  params[:TXNAMOUNT]
		self.curency 	=  params[:CURRENCY]
		self.txn_id   =  params[:TXNID]
		self.banktxn_id = params[:BANKTXNID]
		self.status   =  params[:STATUS]
		self.txn_date =  params[:TXNDATE]
		self.gateway_name =  params[:GATEWAYNAME]
		self.bank_name = params[:BANKNAME]
		self.payment_mode = params[:PAYMENTMODE].present? ? params[:PAYMENTMODE] : "PPI"
		self.checksum_key = params[:CHECKSUMHASH]
		self.property_id = params[:property_id]
		self.booking_id = booking_id
		self.txn_day = params[:TXNDATE].to_date if params[:TXNDATE]
	end

	def create_payment_payumoney(params, booking_id)
		self.mid 			=  params[:key]
		self.order_id =  params[:txnid]
		self.amount   =  params[:amount].to_f
		self.txn_id   =  params[:payuMoneyId]
		self.banktxn_id = params[:bank_ref_num]
		self.status   =  params[:status]
		self.txn_date =  params[:addedon]
		self.gateway_name =  "payumoney"
		self.payment_mode = params[:mode]
		self.checksum_key = params[:hash]
		self.property_id = params[:property_id]
		self.booking_id = booking_id
		self.txn_day = params[:addedon].to_date
		self.mihpayid = params[:mihpayid]
		self.discount = params[:discount]
		self.email = params[:email]
		self.name_on_card = params[:name_on_card]
	end

end
