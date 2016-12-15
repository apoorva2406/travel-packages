module BookingHelper
	def start_dates_array
		all_dates = []
		@bookings = Booking.where(property_id: @property.id)
		@bookings.all.each do |book|
			if book.start_date && book.end_date
				s_date= Date.parse(book.start_date.to_s)
				e_date = Date.parse(book.end_date.to_s)
				days_diff = e_date.mjd - s_date.mjd
				all_dates << s_date.strftime("%d-%m-%Y").to_s
				days_diff.times{|number| all_dates <<  (s_date + number+1).strftime("%d-%m-%Y").to_s} if days_diff > 0	
			end	
		end
		all_dates
	end
end
