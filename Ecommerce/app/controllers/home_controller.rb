class HomeController < ApplicationController
  before_action :build_jwt_token, only: %i[index]

  def index
    # products = Product.limit(4)
    features_items =  Product.show_products Product::SHOW_HOME[:recomand]
    recommend_items = Product.show_products Product::SHOW_HOME[:feature]
    categories = Category.show_category.limit(4)
    sliders = Slider.all
    brands = Brand.all
    notifications = Notification.newest.limit(5)
    availabilities = Availability.by_product_sold(0).order(product_sold: :desc).limit(5).shuffle

    @results = {
      # products: products,
      features_items: features_items.page(params[:page]).per(9),
      recommend_items: recommend_items,
      categories: categories,
      sliders: sliders,
      brands: brands,
      notifications: notifications,
      availabilities: availabilities
    }
  end

  private

  def build_jwt_token
    payload = { data: 'shopvn.com' }
    hmac_secret = 'rubyk01'
    token = JWT.encode payload, hmac_secret, 'HS256'
    cookies.permanent[:authozition] = token
  end
end
