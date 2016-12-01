namespace :property_prices do
  desc "TODO"
  task create: :environment do
		property_type_ids = ["1","2","3"]
		Property.take(50).each do |p|
	    PropertyTypeManage.where(property_id: p.id).delete_all
	    p.property_prices.delete_all
	    p.property_prices.where.not(property_type_id: property_type_ids).delete_all
	    property_type_ids.each do  |id|
	    	p.property_prices.create(
          seats: 12, 
          price: 20,  
          property_type_id: id 
        )
	      property_type = PropertyType.find_by_id(id)
	      property_type.property_type_manages.find_or_create_by(property_id: p.id)
	   end
		end
	end
end		