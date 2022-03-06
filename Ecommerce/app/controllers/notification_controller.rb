# frozen_string_literal: true

class NotificationController < ApplicationController
  def index
    id = params[:id].match(/\d+$/)[0].to_i
    notifications = Notification.newest.limit(5)
    notification_detail = Notification.find(id)
    categories = Category.show_category.limit(4)
    brands = Brand.all
    @results = {
      brands: brands,
      categories: categories,
      notification_detail: notification_detail,
      notifications: notifications
    }
  end
end
