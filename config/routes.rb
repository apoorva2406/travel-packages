Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => {:registrations => "registrations",:sessions=>"sessions"}
  resources :authentications, only: [:create]
  get '/auth/:provider/callback' => 'authentications#create'
  post '/auth/:provider/callback' => 'authentications#create'

  #Paytm callback url
  root 'home#index'
  resources :properties do 
    #Booking routes
    resources :booking , only: [:create] do
      collection do 
        get 'book_now'
        get 'get_type_price'
      end

      member do 
        get 'pay_now'
        post 'patym_webhook'
      end
    end

    member do 
      get 'step_2'
      post 'create_step_2'
    end
    collection do 
      post 'remove_image'
      post 'serach_by_type'
    end
  end

  resources :booking , only: [] do
    member do 
      get 'view_invoice'
    end
  end
  

  resources :search, only: [] do 
    collection do 
      post 'serach_by_type'
    end
  end

  resources :property_price, only: [:update]

  #User Dashboard
  resources :dashboard, :path => '', only: [] do
    member do 
      get 'property', :path => 'dashboard/property'
    end

  	collection do 
      get 'my_earning', :path => 'myprofile/my_earning'
  		get 'myprofile', :path => 'myprofile'
      get 'my_property', :path => 'myprofile/my_property'
      get 'booking', :path => 'myprofile/booking'
      get 'vistis', :path => 'myprofile/vistis'
      get 'mypayments', :path => 'myprofile/mypayments'
      get 'changepassword', :path => 'myprofile/changepassword'
      get 'email_verification', :path => 'myprofile/email_verification'
  	end
  end

  resources :otp do
    collection do 
      get 'verification'
      post 'varified'
      get 'resend_otp'
    end 
  end

end
