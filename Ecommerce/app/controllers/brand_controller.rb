# frozen_string_literal: true

class BrandController < ApplicationController
  def brands
    id = params[:id].match(/\d+$/)[0].to_i
    products = Product.where(brand_id: id).page(params[:page]).per(12)
    categories = Category.show_category.limit(4)
    brands = Brand.all
    notifications = Notification.newest.limit(5)

    @results = {
      id: id,
      products: products,
      categories: categories,
      brands: brands,
      notifications: notifications
    }
  end
end
