class BookingController < ApplicationController
	before_action :authenticate_user!,  only: [:book_now, :create, :pay_now, :view_invoice]
	before_action :get_property,  only: [:create, :pay_now, :book_now, :get_type_price, :patym_webhook]
	before_action :get_booking,  only: [:patym_webhook, :pay_now, :view_invoice, :cancel_booking]
	skip_before_filter :verify_authenticity_token, only: [:patym_webhook, :freecharge_failer, :freecharge_success]
	include PaytmHelper
	include HTTParty

	HTTP_TIMEOUT = 10
	REFUND_ADDRESS = "oltp/HANDLER_INTERNAL/REFUND"
	BASE_URI_WALLET_PRODUCTION = "https://secure.paytm.in/"
  BASE_URI_WALLET_DEVELOPMENT = "https://pguat.paytm.com/"
	BASE_URI = "https://accounts.paytm.com/"

	def cancel_booking
		@payment = @booking.payments.success.first
		if @payment.present?
			data = {
	      "ORDERID" => @payment.order_id,
	      "REFUNDAMOUNT" => @payment.amount,
	      "TXNID" => @payment.txn_id,
	      "MID" => ENV['MID'],
	      "TXNTYPE" => "REFUND"
	    }
	    data.merge!("CHECKSUM" => checksum(data, ENV['PAYTM_MERCHANT_KEY']))
	    data.merge!("REFID" => @payment.txn_id)
	    options = {:JsonData => data.to_json}
	    response = JSON.parse(get(REFUND_ADDRESS, :wallet, options)) rescue nil
		  if response.present?
		  	@refund = @payment.refunds.new()
		    @refund.cancel_booking_refund_amount(response)
		    if @refund.save
			    if response["STATUS"] == "TXN_SUCCESS"
			      flash[:notice] = "Booking successfully cancled"
			    else
			    	flash[:alert] = "Booking can not be cancle due to #{response["RESPMSG"]}"
			    end
			  end  
		  else
		    raise "Refund/LoadMoney request response empty from Paytm"
		  end
	  else
	  	flash[:alert] = "Booking can not be cancle"
	  end  
	  redirect_to :back
	end

	def patym_webhook
		#payuMoney
		if params[:payuMoneyId].present?
			if params[:status].eql?('success')
				@payment = current_user.payments.new()
				@payment.create_payment_payumoney(params, @booking.id)
				if @payment.save
					#PaymentWorker.perform_async(@payment.id)
					@payment.set_booking_status
					flash[:notice] = "Your booking is successfully confirmed" 
				else
					flash[:alert] = "Transaction status is failure #{params[:error_Message]}" 
				end
			else
				flash[:alert] = "Transaction status is failure #{params[:error_Message]}"
			end
		#Paytm
		else
			@payment = current_user.payments.new()
			@payment.create_payment(params, @booking.id)
			if @payment.save
				# PaymentWorker.perform_async(@payment.id)
				if params[:STATUS].eql?('TXN_SUCCESS')
					@payment.set_booking_status
					flash[:notice] = "Your booking is successfully confirmed" 
				else
					flash[:alert] = "Transaction status is failure #{params[:RESPMSG]}"
				end	 
			else
				flash[:alert] = "Transaction status is failure #{params[:RESPMSG]}"
			end
		end	
		redirect_to pay_now_property_booking_path(@property,@booking)
	end 

	def pay_now
		#Pay u Money
		@paramListPayumoney = @booking.params_list_payumoney
		@paramListPayumoney["furl"] = patym_webhook_property_booking_url(@property,@booking)
		@paramListPayumoney["surl"] = patym_webhook_property_booking_url(@property,@booking)

		#Paytm
    @paramListPaytm = @booking.params_list_patym
    @paramListPaytm["CALLBACK_URL"] = patym_webhook_property_booking_url(@property,@booking)
		@paramListPaytm["CHECKSUMHASH"] = new_pg_checksum(@paramListPaytm, ENV['PAYTM_MERCHANT_KEY']).gsub("\n",'')
	end

	def book_now
	end

	def view_invoice
		@payment = @booking.payments.success.first
	end

	def create
		@booking = current_user.bookings.new(booking_params)
		@booking.seats = params[:booking][:seats]
    respond_to do |format|
      if @booking.save
      	#BookingWorker.perform_async(@booking.id)
      	@booking.send_mail_to_owner
        format.html { redirect_to pay_now_property_booking_path(@property, @booking), notice: 'Booking was successfully created.' }
      else
        format.html { render :book_now }
      end
    end
	end

	def get_type_price
		seats  = []
		remaining_seats = 0
		property_type = PropertyType.find_by_name(params[:type])
		@property_price = @property.property_prices.where(property_type_id: property_type.id).first
		booked_seats  = @property.bookings.where(book_type: params[:type]).where('DATE(?) BETWEEN start_date AND end_date', params[:start_date].to_date)
		#Booked seats
		if params[:type].eql?("Meeting/Conference Room")
			seats << @property_price.childrens.map{|c| c.seats} if @property_price.childrens.present?
			booked_seats = booked_seats.map{|b| JSON(b.seats)}.flatten.map(&:to_i)
			seats  = booked_seats.present? ? seats.flatten - booked_seats : seats
		else
			booked_seats = booked_seats.map{|b| JSON(b.seats)}.flatten.map(&:to_i).reduce(&:+)
			remaining_seats  = booked_seats.present? ? @property_price.try(:seats) - booked_seats : @property_price.try(:seats) 
		end
		respond_to do |format|
	  format.json { render json: {property_price: @property_price, seats: seats.flatten, remaining_seats: remaining_seats} }  
	 end
	end

	protected

	def get(url_path, type, options)
    address = base_url(type)+ url_path
    self.class.headers({"Content-Type" => "application/json"})
    response = self.class.get(address, :query => options, timeout: HTTP_TIMEOUT)
    return response
  end

  def base_url(option)
    case option
    when :auth
      return ENV['website_environment'].eql?("production") ? BASE_URI : "https://accounts-uat.paytm.com/"
    when :wallet
      return ENV['website_environment'].eql?("production") ? BASE_URI_WALLET_PRODUCTION : BASE_URI_WALLET_DEVELOPMENT
    end
  end

	def get_property
		@property = Property.find(params[:property_id])
	end

	def get_booking
		@booking = Booking.friendly.find(params[:id])	
	end

	def booking_params
		params[:booking][:rooms] = params[:booking][:seats].length > 1 ? params[:booking][:seats].length : nil
    params[:booking][:property_id] = @property.id
    params.require(:booking).permit(:user_id, :property_id, :name, :book_type, :phone, :rooms, :seats, :start_date, :end_date, :status, :total_amount)
  end
end
								