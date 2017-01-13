class SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token, only: [:create]

  # POST /resource/sign_in
  def create
    resource = User.find_for_database_authentication(email: params[:user][:email])
    return invalid_login_attempt unless resource
    if resource.valid_password?(params[:user][:password])
      if resource.verified.eql?(false)
        respond_to do |format|
          session[:user_id_otp] = resource.id
          format.js
          format.html { redirect_to verification_otp_index_path}
        end 
      else
        sign_in("user", resource)
        flash[:notice] = "Login successfully"
        if request.xhr?
          respond_to do |format|
            format.js { render js: "window.location='#{root_path}'" }
          end
        else
          redirect_to session[:previous_url] || root_path
        end
      end    
    else  
      if request.xhr?
        invalid_login_attempt
      else
        redirect_to :back, alert: 'Error with your login or password' 
      end  
    end  
  end

 protected
  # Method for invalid login attempt
  def invalid_login_attempt
    respond_to do |format|
      if request.xhr?
        format.json { render json: "Error with your login or password", status: 401 }
      else
        format.html { redirect_to :back, alert: 'Error with your login or password'}
      end
    end
  end
end