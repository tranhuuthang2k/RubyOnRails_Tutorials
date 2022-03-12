# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users do
    collection do
      post :create_user
    end
    member do
      patch :update_user
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
