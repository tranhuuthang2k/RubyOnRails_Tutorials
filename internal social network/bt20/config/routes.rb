Rails.application.routes.draw do
  root to: "products#index"

  scope "/:locale" do
    mount ActionCable.server => '/cable'
    get '/login',to:'sessions#new'
    post '/login',to:'sessions#create'
    get '/logout', to: 'sessions#destroy'
    resources :users do 
      # collection do
      #   get :signin
      #   get :register
      # end
    end 
    # get '/login', to:'users#login'
    get '/register', to:'users#new'

    resources :microposts
    resources :account_activations, only: :edit
    resources :comments
    resources :products
    resources :order_items
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    resources :password_resets, only:[:new, :edit, :update, :create]
    get '/auth/google_oath2/callback', to: 'sessions#omniauth'
    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        resources :users, only: %i[index update ] do
          collection do
            get :friends
            get :follows
          end
        end
        post "/login", to: "sessions#create"
        post "/love", to: "microposts#love"
        post "/comment", to: "microposts#comment"
        resources :notifications, only:[:index]

      end
    end
    post '/users/api/v1/comment',to: "api/v1/users#comment"
  end  
  get '/auth/:provider/callback', to: 'sessions#omniauth'
end
