ActiveAdmin.register User do

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

