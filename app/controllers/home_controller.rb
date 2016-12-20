class HomeController < ApplicationController
	def index
		@properites = Property.all
	end
end
