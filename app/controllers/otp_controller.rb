class OtpController < ApplicationController
	#before_filter :get_user

	def verification

	end

	def varified
		@user = User.find_by(id: session[:user_id_otp])
		respond_to do |format|
			if @user.present? && @user.otp_code.eql?(params[:otp_code])
				session[:otp_user_id] = nil
				@user.verified  = true
				@user.save
				flash[:notice] = "Otp successfully varified"
				sign_in @user
				format.js { render js: "window.location='#{root_path}'" }
			else
				format.js
			end
    end
	end

	def resend_otp
		@user = User.find_by(id: session[:user_id_otp])
		@message = @user.send_otp
		respond_to do |format|
			format.js
		end
	end

	protected
	def get_user
		if session[:otp_user_id].present?
			@user = User.find_by(id: session[:user_id_otp])
		else
			flash[:alert] = "Access denied"
			redirect_to new_user_session_path
		end
	end

end
