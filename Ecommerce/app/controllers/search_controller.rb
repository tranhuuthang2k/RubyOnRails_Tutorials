# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    products = (if params[:query]
                  Product.where('title LIKE ?',
                                "%#{params[:query]}%")
                else
                  Product.all
                end).page(params[:page]).per(10)
    key_word = KeywordSearch.find_by(key_word: params[:query].strip.downcase)
    if key_word
      key_word.update_attribute(:count, key_word.count + 1)
    else
      keyword_new = KeywordSearch.new(key_word: params[:query].strip.downcase, count: 1)
      keyword_new.save
    end

    brands = Brand.all
    categories = Category.show_category.limit(4)
    notifications = Notification.newest.limit(5)

    @results = {
      products: products,
      categories: categories,
      brands: brands,
      notifications: notifications

    }
  end
end
