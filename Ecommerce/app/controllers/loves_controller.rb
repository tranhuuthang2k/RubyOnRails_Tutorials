# frozen_string_literal: true

class LovesController < ApplicationController
  before_action :authenticate_user!
  def index
    id = current_user.id
    product_favorites = ProductFavorite.includes(:product).where(user_id: id).page(params[:page]).newest.per(3)
    notifications = Notification.newest.limit(5)

    @results = {
      notifications: notifications,
      product_favorites: product_favorites

    }
  end
end
