class CategoriesController < ApplicationController
  def categories
    id = params[:id].match(/\d+$/)[0].to_i
    products = Product.where(categories_id: id).page(params[:page]).per(2)
    categories = Category.show_category.limit(4)
    brands = Brand.all
    notifications = Notification.newest.limit(5)

    @results = {
      products: products,
      categories: categories,
      brands: brands,
      notifications: notifications

    }
  end
end
