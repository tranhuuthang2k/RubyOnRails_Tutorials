# frozen_string_literal: true

class CartsController < ApplicationController
  def index
    data = helpers.product_history_view
    shippings = current_user ? current_user.city.shippings : []
    @results = {
      notifications: data[:notifications],
      shippings: shippings,
      history_products: data[:history_products]
    }
  end
end
