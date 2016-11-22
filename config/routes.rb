Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :authentications, only: [:create]
  get '/auth/:provider/callback' => 'authentications#create'
  post '/auth/:provider/callback' => 'authentications#create'

  root 'home#index'
  resources :products, only: [:index]
  resources :properties
end
