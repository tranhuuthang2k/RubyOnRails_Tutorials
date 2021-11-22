class Api::V1::CartsController < Api::V1::BaseController
  skip_before_action :require_jwt
  before_action :load_user, only: %i[index checkout]

  def checkout
    temp_carts = []
    params[:data].select { |_, value| temp_carts << value }
    carts_order = []
    product_ids = temp_carts.map { |p| p[:id] }.compact
    total_order = 0
    products = Product.where(id: product_ids).index_by(&:id)
    check_voucher = Voucher.find_by(code: params[:voucher_code])
    check_shipping = Shipping.find_by(id: params[:method_shipping])
    temp_carts.each do |p|
      product = products[p[:id].to_i]
      if product.nil? || product.price != p[:price_product].to_f || product.title != p[:name_product] || p[:image_product] != url_for(product.image)
        carts_order = []
        break
      end
      carts_order << { id: p[:id],
                       name_product: p[:name_product],
                       price_product: p[:price_product],
                       size_product: p[:size_product],
                       quantity: p[:quantity],
                       image_product: p[:image_product],
                       total: p[:price_product].to_f * p[:quantity].to_i }
    end
    voucher_cost = check_voucher && check_voucher.expire.future? ? check_voucher.cost.to_f : 0
    if carts_order.size > 0 && check_shipping
      product_order = @user.order_items.new(user_id: @user.id, status: Product::STATUS[:pending],
                                            product_order: carts_order.to_json,
                                            total_order: carts_order.sum do |cart_order|
                                                           cart_order[:total].to_f
                                                         end - voucher_cost + check_shipping.price,
                                            voucher: voucher_cost,
                                            service: check_shipping.name,
                                            fee: check_shipping.price)
      if product_order.save
        OrderMailer.send_order(@user, product_order).deliver
        render json: success_message('Successfully', product_order: product_order)
      end
    else
      render json: error_message(t('shopping cart is invalid or does not exist'))
    end
  end

  private

  def load_user
    token = params[:token]
    hmac_secret = 'rubyk01'
    decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
    @user = User.find_by(api_token_digest: decoded_token.first['data'])
  end
end
