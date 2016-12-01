class Property < ActiveRecord::Base
	searchkick
	has_many :property_type_manages  
  has_many :property_types, through: :property_type_manages

  has_many :property_prices 

	has_many :photos, as: :imageable
	belongs_to :user
	validates :name, :phone_number, :email, :contact_person, :address, :user_id, presence: true
	geocoded_by :address
  after_validation :geocode, if: :address_changed?   


  after_commit :reindex_property

  def reindex_property
    self.reindex 
  end

  def search_data
	  attributes.merge(
	    property_type_name: property_types.map(&:name)
	  )
	end

	def add_type_access_day(params)
		self.access_day = get_value(params[:property][:access_day])
		self.facilities = get_value(params[:property][:facilities])
		self.properties_type = get_value(params[:property][:properties_type])
		self.save
		property_type_manages(params[:property][:properties_type])
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


