class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,only: [:create]

  # POST /resource/sign_up
  def create
    build_resource(registration_params)
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        resource.assign_user_role(params[:user][:role])
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
      end
      sign_in resource
      if request.xhr?
        respond_to do |format|
          format.json { render json: "Ok" }
        end
      else
        redirect_to myprofile_dashboard_index_path
      end  
    else
      warden.custom_failure!
      if request.xhr?
        respond_to do |format|
          format.json { render json: resource.errors.full_messages.join(' '), status: :unprocessable_entity }
        end
      else
        redirect_to :back, alert: "#{resource.errors.full_messages.join(' ')}" 
      end  
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if resource.update(account_update_params) 
        resource.assign_user_role(params[:role]) if params[:role]
        if params[:user][:password].present?
          sign_in(resource, :bypass => true)
          format.html { redirect_to changepassword_dashboard_index_path, notice: 'Password was successfully updated.' }
        else
          format.html { redirect_to :back, notice: 'Password was successfully updated.' }
        end
      else
        format.html { render 'dashboard/changepassword' }
      end
    end
  end

 protected
  def after_update_path(user)
    if user.check_user_access?
      :back
    else
      :back
    end
  end

  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :mobile_no)
  end

  def account_update_params
    if params[:user][:password].present? && params[:user][:password_confirmation].present?
      params.require(:user).permit(:password, :password_confirmation)
    else
      params.require(:user).permit(:name, :mobile_no)
    end
  end
end