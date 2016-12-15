class Payment < ActiveRecord::Base
	belongs_to :user
	belongs_to :booking, :foreign_key => "booking_id"
	belongs_to :property
	after_create :set_booking_status

	def set_booking_status
		self.booking.update(status: "confirmed")
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
		self.payment_mode = params[:PAYMENTMODE]
		self.checksum_key = params[:CHECKSUMHASH]
		self.property_id = params[:property_id]
		self.booking_id = booking_id
	end
end
