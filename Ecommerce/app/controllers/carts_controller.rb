class CartsController < ApplicationController
  def index
    notifications = Notification.newest.limit(5)
    @results = {
      notifications: notifications
    }
  end
end
