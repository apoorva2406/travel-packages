ActiveAdmin.register Property do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


	index do
	  id_column
	  column :name
	  column :phone_number
	  column :email
	  column :contact_person
	  column "Property Type" do |property|
	    property.property_type
	  end
	  column "Facilities" do |property|
	  	property.facility
	  end
	  column "Address" do |property|
	    truncate(property.try(:address),length: 20)
	  end
	  actions
	end

	show do
    attributes_table do
    	row :id
      row :name
      row :phone_number
      row :properties_type do
        property.property_type
      end
      row :facilities do
        property.facility
      end
      row :access_day do
        property.days_open
      end
      row :start_date do
        property.property_date(property.start_date)
      end
      row :end_date do
        property.property_date(property.end_date)
      end
      row :contact_person
      row :address
      row :user
    end
  end
end



