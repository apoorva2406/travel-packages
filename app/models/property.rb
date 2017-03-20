class Property < ActiveRecord::Base
	searchkick locations: ["location"]
	has_many :property_type_manages  , dependent: :destroy
  has_many :property_types, through: :property_type_manages, dependent: :destroy
  has_many :property_prices , dependent: :destroy
	has_many :photos, as: :imageable, dependent: :destroy
	belongs_to :user
	has_many :bookings
	has_many :payments
	validates :name, :phone_number, :email, :contact_person, :address, presence: true #:user_id, :contact_person,
	geocoded_by :address
  after_validation :geocode, if: :address_changed?   
  #after_commit :reindex_property
  #after_save :edit_reindex_property
  scope :varified_property, -> { where(varified: true) }
  scope :unvarified_property, -> { where(varified: false) }
  scope :add_to_home_property, -> { where(add_to_home: true) }
  
  def send_login_details
  	user = self.try(:user)
  	if user && user.properties.count == 1
	  	user = self.try(:user)
	    #user.send_otp
	    UserMailer.send_login_details(user).deliver
	  end  
    UserMailer.property_confirmation(self).deliver
    Property.reindex
  end

  def create_user
  	@user = User.find_by(email: self.email)
  	if @user.present?
  		self.user_id = @user.id
  		self.save
  	else	
  		password = self.email.split("@").first + '@' + rand.to_s[2..5]
  		@user = User.create(:email => self.email, :password => password, :password_confirmation => password, mobile_no: self.phone_number, name: self.contact_person)
  		self.user_id = @user.id
  		self.save
  		@user.assign_user_role('Owner')
  	end
  end

  def property_type
  	property_types.map{|type|type.name}.join(',') rescue []
  end

  def facility
  	Facility.where(id: JSON(self.facilities)).map{|f| f.name}.join(',') rescue []
  end

  def days_open
		AccessDay.where(id: JSON(self.access_day)).map{|f| f.name}.join(',') rescue []
	end

	def property_date(date)
		({"12 AM"=>0, "1 AM"=>1, "2 AM"=>2, "3 AM"=>3, "4 AM"=>4, "5 AM"=>5, "6 AM"=>6, "7 AM"=>7, "8 AM"=>8, "9 AM"=>9, "10 AM"=>10, "11 AM"=>11, "12 PM"=>12, "1 PM"=>13, "2 PM"=>14, "3 PM"=>15, "4 PM"=>16, "5 PM"=>17, "6 PM"=>18, "7 PM"=>19, "8 PM"=>20, "9 PM"=>21, "10 PM"=>22, "11 PM"=>23}).to_a.map{|k,v| k if v == date.to_i}.compact.join('')
	end

  def reindex_property
    Property.reindex 
  end

  def edit_reindex_property
  	Property.reindex 
  end

  def search_data
  	facilities_ids =  facilities.present? ? JSON(facilities) : nil
	  attributes.merge(
	  	location: {lat: latitude, lon: longitude},
	    property_type_name: property_types.map(&:name).join(','),
	    facilities: Facility.where(id: facilities_ids).all.map(&:name),
	    # rent_status: rent_status.present? ? JSON(rent_status).map{|v| v} : ["Days"],
	    range: property_prices.map(&:price)
	  )
	end

	def add_type_access_day(params)
		self.access_day = get_value(params[:property][:access_day])
		self.facilities = get_value(params[:property][:facilities])
		self.properties_type = get_value(params[:property][:properties_type])
		# self.rent_status = ["Month"] #get_value(params[:property][:rent_status])
		self.save
		property_type_manages(params[:property][:properties_type]) if params[:property][:properties_type].present?
	end 

	def property_type_manages(property_type_ids)
		property_type_ids = get_value(property_type_ids)
		PropertyTypeManage.where(property_id: self.id).delete_all
		self.property_prices.where.not(property_type_id: property_type_ids).delete_all
		property_type_ids.each do |id|
			property_type = PropertyType.find_by_id(id)
			property_type.property_type_manages.find_or_create_by(property_id: self.id)
		end
	end

	def get_value(arr)
		arr.map{|d| d if d > "0"}.compact  if arr
	end                        

	def add_images(images,new_image)
		if images.present? && new_image.present?
			new_image_arr = new_image.gsub(/[^\d]/, '').split('')
			images.each_with_index do |image,index|
				self.photos.create(image: image) if new_image_arr.include?(index.to_s)
			end
		else
			if images.present?
				images.each_with_index do |image,index|
					self.photos.create(image: image)
				end
			end	
		end	
	end

end


