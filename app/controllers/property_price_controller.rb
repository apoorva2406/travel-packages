class PropertyPriceController < ApplicationController
	def update
		@property_price = PropertyPrice.find_by_id(params[:id])
		respond_to do |format|
			if params[:property_price][:seats].present? || params[:property_price][:price].present?
		    if  params[:property_price][:seats].present? ? @property_price.update_attributes(seats: params[:property_price][:seats]) : @property_price.update_attributes(price: params[:property_price][:price])
		      #format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
		      format.json { respond_with_bip(@property_price) }
		    else
		      #format.html { render :action => "edit" }
		      format.json { respond_with_bip(@property_price) }
		    end
		  end  
	  end
	end
end
