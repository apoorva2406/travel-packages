class AuthenticationsController < ApplicationController
  skip_before_filter :authenticate_user!

  def redirect_url_after_omniauth(user = nil)
    user.roles.present? ? root_path : edit_user_registration_path
  end

	def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = 'Signed in successfully.'
      user =  authentication.user
      user.update_omniauth(omniauth)
    else
      # User is new to this application
      user = User.where(:email => omniauth["info"]["email"]).first
      unless user
        user = User.new
        user.build_authentication(:provider => omniauth['provider'], :uid => omniauth['uid'])
        user.apply_omniauth(omniauth)
        flash[:notice] = 'User created and signed in successfully.' if user.save(:validate=>false)   
      end
    end
    sign_in (user)
    redirect_to redirect_url_after_omniauth(user)
  end
end
