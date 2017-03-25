# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Create Roles
['Client','Owner','Admin'].each do |name|
	Role.find_or_create_by(name: name)
end

#Facilitied
['Car Parking','Cafeteria','AC','Locker Storage','Wi-Fi','Tea/Coffee', "Security", "CCTV", "Lifts"].each do |name|
	Facility.find_or_create_by(name: name)
end


['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'].each do |name|
	AccessDay.find_or_create_by(name: name)
end

['Team Room','Workdesk/Co-working','Meeting/Conference Room','Virtual Office','Training Room'
].each do |name|
	PropertyType.find_or_create_by(name: name)
end

cities = ["Navlakha, Indore, Madhya Pradesh, India", "Gwalior", "Bhopal", "`Ujjain", "Delhi", "Pune", "Mumbai", "Bangalore", "Chennai" ,"Bhawarkuan Police Station, Agra Bombay Road, Bhanwar Kuwa, Indore, Madhya Pradesh, India", "Vijay Nagar, Indore, Madhya Pradesh, India", "LIG Colony, Indore, Madhya Pradesh, India", "Palasia Square, Manorama Ganj, Indore, Madhya Pradesh, India", "Sapna Sangita Sneash Nagar Main Road, Ashok Nagar, Indore, Madhya Pradesh, India", "Madhumilan Square, Chhoti Gwaltoli, Indore, Madhya Pradesh, India", "C21 Mall, Agra Bombay Road, Vijay Nagar, Indore, Madhya Pradesh, India","Gita Bhawan Square, Manorama Ganj, Indore, Madhya Pradesh, India","Tower Chouraha, Sindhi Colony, Indore, Madhya Pradesh, India","Choithram Mandi, Indore, Madhya Pradesh, India","Rajendra Nagar, Indore, Madhya Pradesh, India","Holkar Stadium, Race Course Road, New Palasia, Indore, Madhya Pradesh, India"]


facilities_arrray = [["1"], ["2"], ["1","3"], ["3"], ["4"], ["4","5"], ["5"], ["1"], ["3","4"], ["2","3","4"], ["1","2","3"], ["6"]]

property_type_ids = [["1","2","3","4","5"],["1"], ["2"], ["1","3"], ["3"], ["4"], ["4","5"], ["5"], ["1"], ["3","4"], ["2","3","4"], ["1","2","3"]]

no_of_seats = [20,30,25,35,40,45,50,100,80,40,12,25,28,36,33,65,10,5,65,3,4,8,7]

prices = [1,2,3,4,5,8,10,15,20,25,30,35,40,45,50,55,60,65,70,100,90,150,110,120]



puts "Creating Property ..."

# (1..10).each do |number|
# 	property = Property.create({  
# 	 	 "name" => Faker::Name.name,
# 	 	 "phone_number" => '1234567890',
# 	   "email"   =>Faker::Internet.email,
# 	   "properties_type" => ["1","2","3"],
# 	   "address"   =>" #{cities.shuffle.first} ,India",
# 	   "contact_person" => Faker::Commerce.product_name,
# 	   "facilities" => facilities_arrray.shuffle.first,
# 	   "access_day" => ["1","2","3"],
# 	   "user_id"   => 1,
# 	   "start_date" => "13",
# 	   "end_date" => "17",
# 	   "varified" => true,
# 	   "description" => "Many travellers want to find out everything they can about a property before they enquire. Many will want as much information as possible about the holiday experience they will be buying into before they book a stay at your holiday home."
# 	}) 

  

# 	property_type_ids.shuffle.first.each do  |id|
# 		property_type = PropertyType.find_by_id(id)
#   	if property_type.present?
#   		if property_type.name.eql?("Workdesk/Co-working")
#   			p_p = property.property_prices.create(
# 		      seats: no_of_seats.shuffle.first, 
# 		      price: prices.shuffle.first,  
# 		      monthly_price: prices.shuffle.first,
# 		      basic_unit: ["Daily","Monthly"],
# 		      property_type_id: id
# 		    )

#   		elsif property_type.name.eql?("Virtual Office")
#   			p_p = property.property_prices.create(
# 		      seats: 1, 
# 		      monthly_price: prices.shuffle.first,
# 		      basic_unit: ["Monthly"],
# 		      property_type_id: id
# 		    )

#   		elsif property_type.name.eql?("Team Room")
#   			p_p = property.property_prices.create(
# 		      seats: no_of_seats.shuffle.first, 
# 		      price: prices.shuffle.first,  
# 		      monthly_price: prices.shuffle.first,
# 		      basic_unit: ["Daily","Monthly"],
# 		      property_type_id: id,
# 		      number_of_room: 3
# 		    )
#         p_p.childrens.create(seats: 5)
#         p_p.childrens.create(seats: 10)
#         p_p.childrens.create(seats: 15)

# 			elsif property_type.name.eql?("Meeting/Conference Room")
  			
#   			p_p = property.property_prices.create(
# 		      seats: no_of_seats.shuffle.first, 
# 		      hourly_price: prices.shuffle.first,  
# 		      monthly_price: prices.shuffle.first,
# 		      basic_unit: ["Hourly","Daily"],
# 		      property_type_id: id,
# 		      number_of_room: 3
# 		    )

#         p_p.childrens.create(seats: 5)
#         p_p.childrens.create(seats: 10)
#         p_p.childrens.create(seats: 15)
         
# 			elsif property_type.name.eql?("Training Room")
#   			p_p = property.property_prices.create(
# 		      seats: no_of_seats.shuffle.first, 
# 		      price: prices.shuffle.first,
# 		      hourly_price: prices.shuffle.first,  
# 		      monthly_price: prices.shuffle.first,
# 		      basic_unit: ["Hourly","Daily"],
# 		      property_type_id: id,
# 		      number_of_room:3
# 		    )

#         p_p.childrens.create(seats: 5)
#         p_p.childrens.create(seats: 10)
#         p_p.childrens.create(seats: 15)
#   		end
# 	    property_type.property_type_manages.find_or_create_by(property_id: property.id)
# 	  end  
#  	end

# 	property.photos.create(image: open("https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1470221797/nfcsr2xou8sdoo4sw0o7.png"))
# 	property.photos.create(image: open("https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1470221798/zoafebnvxdoyoccg1sjh.png"))
# 	property.photos.create(image: open("https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1470221302/jdwgetgnurlsu8nsqauo.png"))
# 	property.photos.create(image: open("https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1469631515/htjkax4vgaz47q0tyt02.png"))
	
# 	puts "#{number}"
# end

puts "Property successfully created"

#AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')