class PaymentWorker
  include Sidekiq::Worker

  def perform(payment_id)
  	@payment = Payment.find_by(id: payment_id)
  	@payment.set_booking_status
  end
end