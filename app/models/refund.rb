class Refund < ActiveRecord::Base
	after_create :update_booking_status
	belongs_to :payment

	def update_booking_status
		self.payment.booking.update(status: "cancel") if self.payment.booking.present?
	end

	def cancel_booking_refund_amount(params)
		self.bank_txn_id = params["BANKTXNID"]
		self.refund_amount = params["REFUNDAMOUNT"]
		self.txn_date = params["TXNDATE"]
		self.resp_code = params["RESPCODE"]
		self.resp_msg = params["RESPMSG"]
		self.status = params["STATUS"]
		self.refund_id = params["REFUNDID"]
		self.gateway = params["GATEWAY"]
		self.card_issuer = params["CARD_ISSUER"]
	end
end
