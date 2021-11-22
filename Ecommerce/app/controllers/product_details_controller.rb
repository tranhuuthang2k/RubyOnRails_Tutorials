class ProductDetailsController < ApplicationController
  before_action :store_location
  def index
    env_http_forwarded = request.env['HTTP_X_FORWARDED_FOR']
    client_ip = if env_http_forwarded
                  env_http_forwarded.split(',').first
                else
                  request.remote_ip
                end
    id = params[:id].match(/\d+$/)[0].to_i
    product_view = ProductView.new(product_id: id, ip_address: client_ip, user_id: current_user ? current_user.id : '')
    p_view = ProductView.find_by(ip_address: client_ip, product_id: id)
    if current_user && p_view&.ip_address == client_ip && !p_view.user_id
      p_view.update_attribute(:user_id, current_user.id)
    end
    product_view.save(validate: false) unless p_view
    recommend_items = Product.show_products Product::SHOW_HOME[:feature]
    product = Product.find(id)
    admin = User.find(product.user_id)
    categories = Category.show_category.limit(4)
    products = Product.where(categories_id: product.categories_id).limit(4)
    comments = Comment.includes(:user).where(product_id: id).page(params[:page]).per(2)
    product_rates = ProductRate.where(product_id: id)
    sum_rate = product_rates.sum(&:rate)
    count_product = product_rates.size
    avg = count_product.zero? ? 5 : sum_rate / count_product
    brands = Brand.all
    notifications = Notification.newest.limit(5)

    @results = {
      avg: avg,
      admin: admin,
      product: product,
      products: products,
      categories: categories,
      recommend_items: recommend_items,
      comments: comments,
      brands: brands,
      notifications: notifications

    }
  end
end
