class BookingWorker
  include Sidekiq::Worker
 	#include Sidetiq::Schedulable
 	#recurrence { minutely(1) }

  def perform(booking_id)
  	@booking = Booking.find_by(id: booking_id)
  	@booking.send_mail_to_owner
  	@booking.booking_message
  end
end

