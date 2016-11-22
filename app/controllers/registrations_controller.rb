class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,only: [:create,:update]

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
      redirect_to edit_user_registration_path
    else
      warden.custom_failure!
      respond_to do |format|
        format.json { render json: resource.errors.full_messages.join(' '), status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if resource.update(account_update_params)
        resource.assign_user_role(params[:role]) if params[:role]
        format.html { redirect_to after_update_path(resource), notice: 'Profile was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

 protected
  def after_update_path(user)
    if user.check_user_access?
      root_path
    else
      root_path
    end
  end

  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :mobile_no)
  end

  def account_update_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
       params.require(:user).permit(:name, :mobile_no)
    else
      params.require(:user).permit(:email, :password, :password_confirmation, :profile_image, :zipcode, :name, :miles)
    end
  end
end