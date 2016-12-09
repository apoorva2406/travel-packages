class BookingController < ApplicationController
	before_action :authenticate_user!,  only: [:book_now, :create, :pay_now]
	before_action :get_property,  only: [:create, :pay_now, :book_now, :get_type_price]
	include PaytmHelper

	def pay_now
		@booking = Booking.find(params[:id])	
    @paramList = @booking.params_list_patym
		@checksum_hash = new_pg_checksum(@paramList, ENV['PAYTM_MERCHANT_KEY']).gsub("\n",'')
	end

	def book_now
	end

	def create
		@booking = current_user.bookings.new(booking_params)
		@booking.seats = params[:booking][:seats]
    respond_to do |format|
      if @booking.save
        format.html { redirect_to pay_now_property_booking_path(@property, @booking), notice: 'Booking was successfully created.' }
      else
        format.html { render :book_now }
      end
    end
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

	def booking_params
		params[:booking][:rooms] = params[:booking][:seats].length > 1 ? params[:booking][:seats].length : nil
    params.require(:booking).permit(:user_id, :property_id, :name, :book_type, :phone, :rooms, :seats, :start_date, :end_date, :status, :total_amount)
  end
end

 
																																				      
																																				      
																																				    
