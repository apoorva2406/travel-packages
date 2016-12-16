class BookingWorker
  include Sidekiq::Worker
 	include Sidetiq::Schedulable

 	recurrence { minutely(1) }
 	#recurrence { daily }

  def perform
  	puts "Runinggggggggggggggg............................"
    #Booking.unconfirmed_booking
  end
end

