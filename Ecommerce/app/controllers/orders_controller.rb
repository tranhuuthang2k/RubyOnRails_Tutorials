# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  def index
    id = current_user.id
    carts_order = []
    orders = OrderItem.where(user_id: id).page(params[:page]).per(2)
    notifications = Notification.newest.limit(5)
    orders.each do |order|
      carts_order << {
        product_order: JSON.parse(order.product_order),
        order: order
      }
    end
    @results = {
      orders: orders,
      carts_order: carts_order,
      notifications: notifications
    }
  end
end
