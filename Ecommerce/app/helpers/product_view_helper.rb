# frozen_string_literal: true

module ProductViewHelper
  def product_history_view
    product_views = ProductView.includes(:product).where(user_id: current_user&.id).order(updated_at: :desc)
    product_id = product_views.pluck('product_id').uniq
    products = Product.where(id: product_id).pluck('id')
    history_products = product_views.where.not(product_id: product_id - products).page(params[:page]).per(4)

    notifications = Notification.newest.limit(5)
    {
      notifications: notifications,
      history_products: history_products
    }
  end
end
