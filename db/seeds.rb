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
['Car Parking','Cafeteria','AC','Locker Storage','Wi-Fi','Tea/Coffee'].each do |name|
	Facility.find_or_create_by(name: name)
end

['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'].each do |name|
	AccessDay.find_or_create_by(name: name)
end

['Private Office/Team Room','Workdesk/Co-working','Meeting/Conference Room','Virtual Office','Training Room'
].each do |name|
	PropertyType.find_or_create_by(name: name)
end

puts "Creating Property ..."

(1..50).each do |number|
	property = Property.create({  
	 "name" => Faker::Name.name,
	 "phone_number" => '1234567890',
   "email"   =>Faker::Internet.email,
   "properties_type" => ["1","2","3"],
   "address"   =>"AB Rd, Near Malhar Mall, Vijay Nagar #{number}",
   "no_of_seats" => 12,
   "contact_person" => Faker::Commerce.product_name,
   "facilities" => ["1","2","3"],
   "access_day" => ["1","2","3"],
   "user_id"   => 1,
   "start_date" => "13",
   "end_date" => "17",
   "latitude"   =>22.7+(number/100),
   "longitude"   =>75.8+(number/100)
	}) 

	property.photos.create(image: open("https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1470221797/nfcsr2xou8sdoo4sw0o7.png"))
	property.photos.create(image: open("https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1470221798/zoafebnvxdoyoccg1sjh.png"))
	property.photos.create(image: open("https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1470221302/jdwgetgnurlsu8nsqauo.png"))
	property.photos.create(image: open("https://res.cloudinary.com/qdesqtest/image/upload/c_fill,w_700,h_400,q_60/w_40,g_north_west,x_10,y_5,l_log_bldax9/v1469631515/htjkax4vgaz47q0tyt02.png"))
end

puts "Property successfully created"