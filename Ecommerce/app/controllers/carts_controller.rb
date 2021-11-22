class CartsController < ApplicationController
  def index
    notifications = Notification.newest.limit(5)  

    shippings = current_user ? current_user.city.shippings : []
    @results = {
      notifications: notifications,
      shippings: shippings
    }
  end
end
