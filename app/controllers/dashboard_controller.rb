class DashboardController < ApplicationController
	before_action :authenticate_user!, except: [:property, :email_confirm, :import_booking, :create_import_booking]
	def index;end

	def import_booking

	end

	def create_import_booking
		@message = Booking.import(params[:file], current_user.id)
		if @message.present?
			render 'import_booking'
		else
			flash[:notice] = "Booking imported successfully"
			redirect_to :back
		end
	end
	
	def myprofile
		@resource = current_user
	end

	def my_earning	
		@bookings = Booking.where(property_id: current_user.properties.map(&:id), status: "not confirm")
		@payments = Payment.where.not(user_id: current_user.id).where(property_id: current_user.properties.map(&:id)).order("property_id asc").group_by{|p| p.property_id}
	end

	def property
		@property = Property.find(params[:id])
		@near_by_properties = Property.search "*", where: {location: {near: {lat: @property.latitude, lon: @property.longitude}, within: "3mi"}}
	end

	def my_property
		@properties = current_user.properties.order(created_at: 'desc')
		authorize! :read, @properties
	end

	def booking
		@bookings = current_user.bookings.where(walk_in: false).order('created_at desc')
		@impoted_bookings = current_user.bookings.where(walk_in: true).order('created_at desc')
	end
	def vistis;end

	def mypayments
		@payments = current_user.payments
	end

	def changepassword
		@resource = current_user
	end

	def email_verification
		UserMailer.email_vaification(current_user).deliver
		#current_user.update(email_status: true)
		respond_to do |format|
      format.js { render js: "$('#email_status').css('color', 'green').text('Email has been sent to given for confirmation')" }
    end
	end

	def email_confirm
		@user = User.find_by_id(params[:id])
		if @user.present? && @user.email_status
			flash[:info] = "Email already verified"
		elsif @user.present?
			@user.update(email_status: true)
			flash[:notice] = "Email has been verified successfully"
		else
			flash[:alert] = "Something is wrong plese tre agian"
		end
		redirect_to root_path
	end
end
