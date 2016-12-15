class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :store_current_location, :unless => :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_404
    render :template => "errors/error_404", :status => 404
  end
  
	rescue_from CanCan::AccessDenied do |exception|
	  flash[:error] = "Access denied."
	  redirect_to root_url
	end

  private
  def store_current_location
    session[:previous_url] = request.url 
  end

end
