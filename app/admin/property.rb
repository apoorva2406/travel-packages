ActiveAdmin.register Property do
  form partial: "admin/properties/form"
  scope :varified_property
  scope :unvarified_property

	index do
	  id_column
	  column :name
	  column :phone_number
	  column :email
	  column :contact_person
    column "Verify", :varified
	  column "Property Type" do |property|
	    property.property_type
	  end
	  column "Facilities" do |property|
	  	property.facility
	  end
    column 'Owner' do |property|
      link_to property.user.email        
    end
	  column "Address" do |property|
	    truncate(property.try(:address),length: 20)
	  end

    actions do |property|
      if params[:scope].eql?("varified_property")
        link_to 'Unverify', unvarify_admin_property_path(property)
      else
        if property.varified
          link_to 'Verified', "#-"
        else
          link_to 'Verify', varify_admin_property_path(property)
        end
      end
    end
	end

  member_action :varify do
    @property = Property.find(params[:id])
    @property.varified = true
    @property.save
    redirect_to :back, notice: "Property varified successfully"
  end

  member_action :unvarify do
    @property = Property.find(params[:id])
    @property.varified = false
    @property.save
    redirect_to :back, notice: "Property unvarified successfully"
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
      row :owner do
        link_to property.user.email
      end
    end
  end

  member_action :step_2, method: :get do
    @property = Property.find(params[:id])
  end

  controller do
    def create
      @property = Property.new(
        name: params[:property][:name],
        phone_number: params[:property][:phone_number],
        email: params[:property][:email],
        contact_person: params[:property][:contact_person],
        description: params[:property][:description],
        address:  params[:property][:address],
        start_date: params[:property][:start_date],
        end_date: params[:property][:end_date]
      )
      @property.user_id = params[:user_id]
      respond_to do |format|
        if @property.save
          @property.add_type_access_day(params)
          @property.add_images(params[:property][:images], params[:new_image])
          format.html { redirect_to step_2_admin_property_path(@property), notice: 'Property was successfully created.' }
        else
          format.html { render :new } 
        end
      end
    end

    def update
      @property = Property.find(params[:id])
      #update property
      if params[:property].present?
        respond_to do |format|
          if @property.update(
                              name: params[:property][:name],
                              phone_number: params[:property][:phone_number],
                              email: params[:property][:email],
                              contact_person: params[:property][:contact_person],
                              description: params[:property][:description],
                              address:  params[:property][:address],
                              start_date: params[:property][:start_date],
                              end_date: params[:property][:end_date]
                            )
            @property.add_type_access_day(params)
            @property.add_images(params[:property][:images], params[:new_image])
            format.html { redirect_to step_2_admin_property_path(@property), notice: 'Property was successfully updated.' }
          else
            format.html { render :edit }
          end
        end
      else
        #update price
        if params[:price].present?
          params[:price].each_with_index do |(key,value),index|
            property_price = @property.property_prices.where(property_type_id: key).first
            propert_type = @property.property_types.where(name: 'Meeting/Conference Room').first
            if property_price.present?
              if propert_type.try(:id).eql?(key.to_i)
                create_property_meeting(property_price, params[:number_of_room], params[:room])
              else
                property_price.seats = params[:seats][key]
                property_price.price = value
                property_price.save
              end  
            else
              p_p = @property.property_prices.create(
                seats: params[:seats].present? ? params[:seats][key] : nil, 
                price: value,  
                property_type_id: key 
              )
              create_property_meeting(p_p, params[:number_of_room], params[:room]) if propert_type.try(:id).eql?(key.to_i)
            end  
          end
        end 
        redirect_to admin_property_path(@property),notice: 'Property seats and price successfully created'
      end
    end

    def create_property_meeting(p_p, number_of_room, rooms)
      PropertyPrice.where(parent_id: p_p.id).delete_all
      p_p.number_of_room = number_of_room
      p_p.save
      rooms.each do |key,value|
        p_p.childrens.create(seats: value)
      end 
    end
  end 
end



