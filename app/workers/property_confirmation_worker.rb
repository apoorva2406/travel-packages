class PropertyConfirmationWorker
  include Sidekiq::Worker

  def perform(property_id)
  	@property = Property.find_by(id: property_id)
  	@property.send_login_details
  end
end