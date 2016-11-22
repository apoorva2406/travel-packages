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




 