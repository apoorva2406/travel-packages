class DashboardController < ApplicationController
	before_action :authenticate_user!, except: [:property]
	def index;end

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
		@properties = current_user.properties
		authorize! :read, @properties
	end

	def booking
		@bookings = current_user.bookings.order('created_at desc')
	end
	def vistis;end

	def mypayments
		@payments = current_user.payments
	end

	def changepassword
		@resource = current_user
	end

	def email_verification
		current_user.update(email_status: true)
		respond_to do |format|
      format.js { render js: "$('#email_status').css('color', 'green').text('Email verified sucessfully')" }
    end
	end
end
