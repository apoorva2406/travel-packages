class DashboardController < ApplicationController
	before_action :authenticate_user!
	def index;end

	def myprofile
		@resource = current_user
	end

	def my_property
		@properties = current_user.properties
	end

	def booking;end
	def vistis;end
	def mypayments;end
	def changepassword
		@resource = current_user
	end
end
