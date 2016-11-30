Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations",:sessions=>"sessions"}
  resources :authentications, only: [:create]
  get '/auth/:provider/callback' => 'authentications#create'
  post '/auth/:provider/callback' => 'authentications#create'

  root 'home#index'
  resources :products, only: [:index]
  resources :properties do 
    member do 
      get 'step_2'
      post 'create_step_2'
    end
    collection do 
      post 'remove_image'
    end
  end

  #User Dashboard
  resources :dashboard, :path => '', only: [] do
    member do 
      get 'property', :path => 'dashboard/property'
    end

  	collection do 
  		get 'myprofile', :path => 'myprofile'
      get 'my_property', :path => 'myprofile/my_property'
      get 'booking', :path => 'myprofile/booking'
      get 'vistis', :path => 'myprofile/vistis'
      get 'mypayments', :path => 'myprofile/mypayments'
      get 'changepassword', :path => 'myprofile/changepassword'
  	end
  end
end
