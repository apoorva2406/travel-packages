class Property < ActiveRecord::Base
	has_many :photos, as: :imageable
	belongs_to :user
	validates :name, :phone_number, :email, :contact_person, :address, :user_id, presence: true
	geocoded_by :address
  after_validation :geocode, if: :address_changed?   

	def add_type_access_day(params)
		self.access_day = get_value(params[:property][:access_day])
		self.facilities = get_value(params[:property][:facilities])
		self.properties_type = get_value(params[:property][:properties_type])
		self.save
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


