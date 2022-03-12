# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :users do
    # collection do
    #   get :signin
    #   get :register
    # end
  end
  # get '/login', to:'users#login'
  get '/register', to: 'users#new'

  # resources :static_pages do
  #   collection do
  #     get :home
  #     get :help
  #   end
  # end
  # get '/home', to: 'static_pages#home'
  # get '/help', to: 'static_pages#help'

  # get 'static_pages/home'
  # get 'static_pages/help'
  resources :microposts
  resources :account_activations, only: :edit
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
