module PropertiesHelper
	def property_time
		({"12 AM"=>0, "1 AM"=>1, "2 AM"=>2, "3 AM"=>3, "4 AM"=>4, "5 AM"=>5, "6 AM"=>6, "7 AM"=>7, "8 AM"=>8, "9 AM"=>9, "10 AM"=>10, "11 AM"=>11, "12 PM"=>12, "1 PM"=>13, "2 PM"=>14, "3 PM"=>15, "4 PM"=>16, "5 PM"=>17, "6 PM"=>18, "7 PM"=>19, "8 PM"=>20, "9 PM"=>21, "10 PM"=>22, "11 PM"=>23}).to_a.map{|s| s}
	end

	def property_type
		type = PropertyType.where(id: JSON(@property.properties_type))
		if type.present?
			type.each_with_index.map{|t,i| "<span> #{t.name}</span>"}.join('').html_safe
		else
			"No Type"
		end
	end

	def property_facilities
		facilities = []
		type = Facility.where(id: JSON(@property.facilities))
		if type.present?
			type.each_with_index do |val,index|
				if val.name.eql?("Car Parking")
					facilities << "<div class='col-md-4 histo-img'><img src='/assets/car-parking.png'/><p class='local-name'>#{val.name}</p> </div>"
				elsif val.name.eql?("Cafeteria")
					facilities << "<div class='col-md-4 histo-img'><img src='/assets/tea.png'/><p class='local-name'>#{val.name}</p> </div>"
				elsif val.name.eql?("Tea/Coffee")
					facilities << "<div class='col-md-4 histo-img'><img src='/assets/tea.png'/><p class='local-name'>#{val.name}</p> </div>"
				elsif val.name.eql?("AC")
					facilities << "<div class='col-md-4 histo-img'><img src='/assets/power.png'/><p class='local-name'>#{val.name}</p> </div>"
				elsif val.name.eql?("Wi-Fi")
					facilities << "<div class='col-md-4 histo-img'><img src='/assets/wifi.png'/> <p class='local-name'>#{val.name}</p> </div>"
				elsif val.name.eql?("Locker Storage")
					facilities << "<div class='col-md-4 histo-img'><img src='/assets/wifi.png'/><p class='local-name'>#{val.name}</p> </div>"
				end
			end
			facilities.join('').html_safe
		else
			"No Facility"
		end
	end

	def property_access_day
		type = AccessDay.where(id: JSON(@property.access_day))
		if type.present?
			type.each_with_index.map{|t,i| "<div>#{t.name}</div>"}.join('').html_safe
		else
			"Not Day"
		end
	end

	def property_date(date)
		({"12 AM"=>0, "1 AM"=>1, "2 AM"=>2, "3 AM"=>3, "4 AM"=>4, "5 AM"=>5, "6 AM"=>6, "7 AM"=>7, "8 AM"=>8, "9 AM"=>9, "10 AM"=>10, "11 AM"=>11, "12 PM"=>12, "1 PM"=>13, "2 PM"=>14, "3 PM"=>15, "4 PM"=>16, "5 PM"=>17, "6 PM"=>18, "7 PM"=>19, "8 PM"=>20, "9 PM"=>21, "10 PM"=>22, "11 PM"=>23}).to_a.map{|k,v| k if v == date.to_i}.compact.join('')
	end

	def property_photo(property)
		if property.photos.present?
			url = property.photos.shuffle.first.image.url
		else
			url = "https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1469631515/de4ysaf5ipkchjehojm0.png"
		end
		url 
	end

	def property_index_type(property)
		if property.properties_type.present?
			p_t = PropertyType.where(id: JSON(property.properties_type)).shuffle.first.try(:name)
		else
			type = "Meeting/Conference Room"
		end
	end

	def property_type_price(property_type_id,value_tye={})
		property_price = @property.property_prices.where(property_type_id: property_type_id).first
		if value_tye.eql?("seats")
			property_price.try(:seats)
		elsif value_tye.eql?("rooms")
			property_price.try(:number_of_room)
		else
			property_price.try(:price)
		end
	end

	def property_seats_price(property)
		seats_prices = []
		property.property_types.take(1).each do |type|
			property_price = property.property_prices.where(property_type_id: type.id).first
      seats_prices << "<div class='price-night'><span>#{property_price.try(:seats)} people</span><span class='price-n'>#{property_price.try(:price)}</span></div>".html_safe
    end
    seats_prices.join('').html_safe
	end


	def property_meeting_children(type_id)
		inputs = []
		type_childerns = @property.property_prices.where(property_type_id: type_id).first
		if type_childerns && type_childerns.childrens.present?
			type_childerns.childrens.each_with_index do |child,index|
				inputs << "<tr><td>#{index+1}</td><td><input type='text' class='form-control' placeholder='Enter seats' required='required' name='room[#{child.id}]' value='#{child.try(:seats)}' onkeypress= 'return event.charCode >= 48 && event.charCode <= 57'></td></tr>".html_safe
			end
		end
		inputs.join('').html_safe
	end

	def property_meeting_children_admin(type_id)
		inputs = []
		type_childerns = @property.property_prices.where(property_type_id: type_id).first
		if type_childerns && type_childerns.childrens.present?
			type_childerns.childrens.each_with_index do |child,index|
				inputs << "<tr><td>#{index+1}</td><td><input type='text' class='form-control' placeholder='Enter seats' required='required' name='room[#{child.id}]' value='#{child.try(:seats)}' onkeypress= 'return event.charCode >= 48 && event.charCode <= 57' disabled></td></tr>".html_safe
			end
		end
		inputs.join('').html_safe
	end

end
