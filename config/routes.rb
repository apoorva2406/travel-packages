Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations",:sessions=>"sessions"}
  resources :authentications, only: [:create]
  get '/auth/:provider/callback' => 'authentications#create'
  post '/auth/:provider/callback' => 'authentications#create'

  root 'home#index'
  resources :products, only: [:index]
  resources :properties

  #User Dashboard
  resources :dashboard, :path => '', only: [] do
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
