class ProductViewController < ApplicationController
  def index
    id = current_user.id
    history_products = ProductView.includes(:product).where(user_id: id).page(params[:page]).newest.per(3)
    notifications = Notification.newest.limit(5)

    @results = {
      notifications: notifications,
      history_products: history_products
    }
  end
end
