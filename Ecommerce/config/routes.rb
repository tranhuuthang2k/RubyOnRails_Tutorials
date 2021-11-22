
Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'home#index'
  get 'product_details/index'
  if Rails.env.development?
    scope format: true, constraints: { format: /jpg|png|gif|PNG/ } do
      get '/*anything', to: proc { [404, {}, ['']] }, constraints: lambda { |request| !request.path_parameters[:anything].start_with?('rails/') }
    end
  end
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'signup' },
             controllers: { registrations: 'users/registrations',
                            omniauth_callbacks: 'users/omniauth_callbacks' }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
    get 'login', to: 'devise/sessions#new'
    get 'register', to: 'devise/registrations#new'
    get 'logout', to: 'devise/sessions#destroy'
    get 'users/carts', to: 'carts#index'
    get 'users/checkout_vnpay', to: 'checkouts#index'
    get 'users/checkout_vnpay/pay', to: 'checkouts#create'


  end
  get 'product-details/:id', to: 'product_details#index'
  get 'category/:id', to: 'categories#categories'
  get 'contact', to: 'contact#index'
  post 'contact', to: 'contact#create'
  get 'brand/:id', to: 'brand#brands'
  get 'blog', to: 'blog#index'
  get 'blog/:id', to: 'blog#blog_detail'
  get 'users/orders', to: 'orders#index'
  get 'users/loves', to: 'loves#index'
  get 'users/history_product', to: 'product_view#index'
  get 'notification/:id', to: 'notification#index'
  get 'admin/system', to: 'notification#index'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get '/category', to: 'categories#index'
      post '/love', to: 'loves#index'
      post '/comment', to: 'loves#comment'
      post '/rate', to: 'loves#rate'
      post '/checkout', to: 'carts#checkout'
      post '/checkout_with_momo', to: 'carts#payment_momo'
      get '/checkout_success', to: 'carts#success'

      delete '/unlove', to: 'loves#unlove'
      post 'edit-comment', to: 'loves#edit_comment'
      delete '/delete-comment', to: 'loves#delete_comment'
      post '/product', to: 'products#products_of_month'
      post '/search', to: 'products#search'
      post '/voucher', to: 'products#voucher'
      post '/delete_order', to: 'products#delete_order'
    end
  end
end
