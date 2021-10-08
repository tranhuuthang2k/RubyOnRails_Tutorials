class ProductDetailsController < ApplicationController
  before_action :store_location
  def index
    id = params[:id].match(/\d+$/)[0].to_i
    recommend_items = Product.show_products Product::SHOW_HOME[:feature]
    product = Product.find_by(id: id)
    categories = Category.show_category
    

    @results = {
      product: product,
      recommend_items: recommend_items,
      categories: categories
    }
  end
end
