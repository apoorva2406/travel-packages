class PropertyPriceController < ApplicationController
	def update
		@property_price = PropertyPrice.find_by_id(params[:id])
		
		respond_to do |format|
	    if params[:property_price][:seats].present? 
	      @property_price.update_attributes(seats: params[:property_price][:seats])
	    elsif params[:property_price][:price].present?
	    	@property_price.update_attributes(price: params[:property_price][:price])
    	elsif params[:property_price][:hourly_price].present?
	    	@property_price.update_attributes(hourly_price: params[:property_price][:hourly_price])
    	elsif params[:property_price][:monthly_price].present?
	    	@property_price.update_attributes(monthly_price: params[:property_price][:monthly_price])
	    end
		  format.json { respond_with_bip(@property_price) }
	  end
	end
end
