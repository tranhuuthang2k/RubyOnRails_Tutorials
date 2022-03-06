# frozen_string_literal: true

module Api
  module V1
    class ProductsController < Api::V1::BaseController
      skip_before_action :require_jwt
      before_action :load_user, only: %i[products_of_month search]

      def products_of_month
        product_of_month = OrderItem.where(user_id: @user.id)
                                    .this_month(params[:year], params[:month])
                                    .this_status(Product::STATUS[:confirmed])
        carts_order = []
        fee_ship = product_of_month.pluck('fee').sum - product_of_month.pluck('voucher').sum
        product_of_month.each do |order|
          carts_order += JSON.parse(order.product_order)
        end
        render json: success_message('Successfully', { carts_order: carts_order, fee_ship: fee_ship })
      end

      def search
        products = Product.where('title LIKE ? OR price = ?', "%#{params[:search].upcase}%", params[:search].to_f)
        key_word = KeywordSearch.find_by(key_word: params[:search].strip.downcase)
        if key_word
          key_word.update_attribute(:count, key_word.count + 1)
        else
          keyword_new = KeywordSearch.new(key_word: params[:search].strip.downcase, count: 1)
          keyword_new.save
        end
        render json: success_message('Successfully',
                                     { products: ActiveModelSerializers::SerializableResource.new(products,
                                                                                                  each_serializer: ProductSerializer) })
      end

      def voucher
        check_voucher = Voucher.find_by(code: params[:voucher_code])
        if check_voucher&.expire&.future?
          render json: success_message('Successfully', { cost: check_voucher.cost })
        else
          render json: error_message(t('Voucher is invalid or expired'))
        end
      end

      def delete_order
        order_item = OrderItem.find_by(id: params[:order_id])
        unless order_item.nil?
          product_order = JSON.parse(order_item.product_order).reject { |h| h['id'] == params[:product_id] }
          if product_order.length.positive?
            order_item.update_attribute(:product_order, product_order.to_json)
          else
            order_item.delete
          end
          render json: success_message('Successfully', 'success')
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
  end
end
