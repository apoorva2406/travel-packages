OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
   provider :facebook, ENV['facebook_app_id'], ENV['facebook_secret_key'], :strategy_class => OmniAuth::Strategies::Facebook,
   :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
end


Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, ENV['google_client_id'], ENV['google_secret_keys']
end
  
  

