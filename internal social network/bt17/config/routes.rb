Rails.application.routes.draw do
  root to: "products#index"

  scope "/:locale" do
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
   
    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        resources :users, only: %i[index] do
          collection do
            get :friends
          end
        end
        post "/login", to: "sessions#create"
        post "/love", to: "microposts#love"
        post "/comment", to: "microposts#comment"
      end
    end
  end  
end
