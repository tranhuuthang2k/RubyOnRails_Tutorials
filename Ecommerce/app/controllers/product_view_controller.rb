# frozen_string_literal: true

class ProductViewController < ApplicationController
  def index
    data = helpers.product_history_view

    @results = {
      notifications: data[:notifications],
      history_products: data[:history_products]
    }
  end
end
