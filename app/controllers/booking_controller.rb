class BookingController < ApplicationController
	before_action :authenticate_user!,  only: [:book_now]
	before_action :get_property,  only: [:book_now, :get_type_price]

	def book_now
	end

	def get_type_price
		seats  = []
		property_type = PropertyType.find_by_name(params[:type])
		@property_price = @property.property_prices.where(property_type_id: property_type.id).first
		seats << @property_price.childrens.map{|c| c.seats} if @property_price.childrens.present?
		respond_to do |format|
	  format.json { render json: {property_price: @property_price, seats: seats.flatten} }  
	 end
	end

	protected
	def get_property
		@property = Property.find(params[:property_id])
	end

end
