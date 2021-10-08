Rails.application.routes.draw do
  get 'product_details/index'
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'signup' },
             controllers: { registrations: 'users/registrations',
                            omniauth_callbacks: 'users/omniauth_callbacks' }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
    get 'login', to: 'devise/sessions#new'
    get 'register', to: 'devise/registrations#new'
    get 'logout', to: 'devise/sessions#destroy'
    get 'users/carts', to: 'carts#index'
  end
  get 'product-details/:id', to: 'product_details#index'
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get "/category", to: "categories#index"
      post "/love", to: "loves#index"
      delete "/unlove", to: "loves#unlove"
    end
   
  end
end
