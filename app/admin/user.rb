ActiveAdmin.register User do
	actions :index, :show, :delete

	
	# permit_params do
	#   permitted = [:permitted, :attributes]
	#   permitted << :other if params[:action] == 'create' && current_user.admin?
	#   permitted
	# end

  filter :email
  filter :roles
  filter :properties
  filter :bookings
  filter :payments
  filter :created_at


 	form do |f|
    f.inputs "User Details" do
    	f.input :name
    	f.input :mobile_no
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

	index do
		selectable_column
		id_column
		column "Profile Image" do |user|
			if user.photo.present?
	    	image_tag user.photo.url
    	else
    		image_tag user.profile_image
    	end
	  end
	  column :name
	  column :email
	  column :created_at
	  column :mobile_no
	  column :gender
	  column :verified
	  column :email_status
	  actions
	end
end

