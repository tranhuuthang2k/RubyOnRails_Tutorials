# frozen_string_literal: true

class CategoriesController < ApplicationController
  def categories
    id = params[:id].match(/\d+$/)[0].to_i
    product_category_children = Product.where(categories_id: id).page(params[:page]).per(6)
    categories = Category.show_category.limit(4)

    products = if product_category_children.present?
                 product_category_children
               else
                 categories.pluck('id').include?(id) ? categories.find(id).products.page(params[:page]).per(12) : []
               end

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
