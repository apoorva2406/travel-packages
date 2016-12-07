class DashboardController < ApplicationController
	before_action :authenticate_user!, except: [:property]
	def index;end

	def myprofile
		@resource = current_user
	end

	def property
		@property = Property.find(params[:id])
		@near_by_properties = Property.search "*", where: {location: {near: {lat: @property.latitude, lon: @property.longitude}, within: "3mi"}}
	end

	def my_property
		@properties = current_user.properties
		authorize! :read, @properties
	end

	def booking;end
	def vistis;end
	def mypayments;end
	def changepassword
		@resource = current_user
	end
end
