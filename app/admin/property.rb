ActiveAdmin.register Property do
  actions :all, :except => [:new]
  form partial: "admin/properties/form", layout: "active_admin" 
  scope :varified_property
  scope :unvarified_property

	index do
	  id_column
	  column :name
	  column :phone_number
	  column :email
	  column :contact_person
    column :varified
	  column "Property Type" do |property|
	    property.property_type
	  end
	  column "Facilities" do |property|
	  	property.facility
	  end
	  column "Address" do |property|
	    truncate(property.try(:address),length: 20)
	  end
    actions do |property|
      link_to 'Varify', varify_admin_property_path(property)
    end
	end

  member_action :varify do
    @property = Property.find(params[:id])
    @property.varified = true
    @property.save
    redirect_to :back, notice: "Property varified successfully"
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

  controller do
    def update
      @property = Property.find(params[:id])
      params[:price].each_with_index do |(key,value),index|
        property_price = @property.property_prices.where(property_type_id: key).first
        propert_type = @property.property_types.where(name: 'Meeting/Conference Room').first
        if property_price.present?
          property_price.price = value
          property_price.save
        end
      end
      redirect_to :back ,notice: "Property updated successfully"
    end
  end 
end



