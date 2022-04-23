# frozen_string_literal: true

module Api
  module V1
    class ProductsController < Api::V1::BaseController
      skip_before_action :require_jwt
      before_action :load_user, only: %i[products_of_month]

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
          render json: error_message('Voucher is invalid or expired')
        end
      end

      def delete_order
        order_item = OrderItem.find_by(id: params[:order_id])
        unless order_item.nil?
          order_items = JSON.parse(order_item.product_order)
          product_order = order_items.reject do |h|
            h['id'] == params[:product_id] && h['size_product'] == params[:size_product]
          end
          quantity =  order_items.select { |h| h['id'] == params[:product_id] }.pluck('quantity').first.to_i
          product = Product.find(params[:product_id])
          if order_item.status == Product::STATUS[:confirmed]
            render json: error_message('Your order has been confirmed and cannot be canceled')
            return
          end
          if product.availability.status = OrderItem::STOCK[:Outstock]
            product.availability.update_columns(number_instock: product.availability.number_instock + quantity.to_i,
                                                is_ordering: product.availability.is_ordering - quantity.to_i, status: OrderItem::STOCK[:Instock])

          elsif product.availability.status = OrderItem::STOCK[:Instock]
            product.availability.update_columns(number_instock: product.availability.number_instock + quantity,
                                                is_ordering: product.availability.is_ordering - p[:quantity].to_i)
          end

          if product_order.length.positive?
            order_item.update_attribute(:product_order, product_order.to_json)
          else
            order_item.delete
          end
          render json: success_message('Successfully', 'success')
        end
      end

      def more_product
        products = Product.show_products Product::SHOW_HOME[:recomand]
        features_items = products.page(params[:page]).per(6)
        page_next = params[:page].to_i + 1
        show_btn_load = products.page(page_next).per(6)
        render json: success_message('Successfully',
                                     { show_btn_load: show_btn_load.size.positive? ? true : false,
                                       products: ActiveModelSerializers::SerializableResource.new(features_items,
                                                                                                  each_serializer: ProductSerializer) })
      end

      def quick_review
        env_http_forwarded = request.env['HTTP_X_FORWARDED_FOR']
        client_ip = if env_http_forwarded
                      env_http_forwarded.split(',').first
                    else
                      request.remote_ip
                    end
        id = params[:productId].to_i
        product_view = ProductView.new(product_id: id, ip_address: client_ip, city: request.location.city, user_id: current_user ? current_user.id : '') # when user don't login or was logged before ago
        p_view = ProductView.find_by(ip_address: client_ip, product_id: id)
        if current_user && p_view&.ip_address == client_ip # && p_view.user_id.blank? # when user login
          p_view.update_attribute(:user_id, current_user.id)
        end
        product_view.save(validate: false) unless p_view
        p_view&.touch(:updated_at) if p_view&.user_id == current_user&.id # update updated_at viewing history
        product = Product.find(id)
        product_rates = ProductRate.where(product_id: id)
        sum_rate = product_rates.sum(&:rate)
        count_product = product_rates.size
        size = product.sizes.pluck('name')
        avg = count_product.zero? ? 5 : sum_rate / count_product
        render json: success_message('Successfully', {
                                       id: product.id,
                                       name: product.title,
                                       price: product.price,
                                       price_old: product.price_old.positive? ? product.price_old : 0,
                                       image_url: "/rails#{url_for(product.image).split('/rails')[1]}",
                                       status: product.availability&.number_instock.positive? ? 'Intock' : 'OutStock',
                                       number_instock: product.availability&.number_instock,
                                       availability: product.availability&.name,
                                       size: size,
                                       brand: product.brand&.name,
                                       avg: avg || '0',
                                       views: product.product_views&.count
                                     })
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
