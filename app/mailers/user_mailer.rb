class UserMailer < ApplicationMailer
	default from: "info@ivsoffices.com"

	#Send login details
  def send_login_details(user)
    @user = user
    @password = @user.email.split("@").first + '@' + rand.to_s[2..5]
    @user.password = @password
    @user.save
    mail(to: @user.email, subject: "Your login details")
  end

  #Send mail to user for property_confirmation
  def property_confirmation(property)
    @property = property
    @user = property.try(:user)
    mail(to: @user.email, subject: "Your property has been confirmed")
  end

  #Email varification
  def email_vaification(user)
    @user = user
    mail(to: @user.email, subject: "Confirm your email")
  end

  #Booking user email
  def booking_client_email(booking)
  	@booking = booking
  	@user = booking.try(:user)
		@property = booking.try(:property)
		mail(to: @user.email, subject: "Your have successfully booked #{@property.try(:name)}")
  end

  #Booking property owner email
  def booking_owner_email(booking)
  	@booking = booking
  	@user = booking.try(:user)
  	@owner = booking.try(:property).try(:user)
		@property = booking.try(:property)
		mail(to: @owner.email, subject: "Your property booked by #{@user.try(:name)}")
  end

  #Booking confirmation user email
  def booking_confirmation_client_email(payment)
    @payment = payment
    @booking = payment.try(:booking)
    @property = @booking.try(:property)
    @user = payment.try(:user)
    @owner = @property.try(:user)
    mail(to: @user.email, subject: "Your booking is confirmed")
  end

  #Booking confirmation owner email
  def booking_confirmation_owner_email(payment)
    @payment = payment
    @booking = payment.try(:booking)
    @property = @booking.try(:property)
    @user = payment.try(:user)
    @owner = @property.try(:user)
    mail(to: @owner.email, subject: "Your property booking is confirmed by #{@user.try(:name)}")
  end
end
