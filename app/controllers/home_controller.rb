class HomeController < ApplicationController
	def index
		@properites = Property.varified_property.add_to_home_property
		@properites = Property.all if @properites.blank?
	end
end
