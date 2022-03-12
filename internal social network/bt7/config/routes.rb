# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'static_pages#home'
  resources :static_pages do
    collection do
      get :home
      get :help
    end
  end
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'

  # get 'static_pages/home'
  # get 'static_pages/help'
  resources :microposts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
