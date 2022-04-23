# frozen_string_literal: true

module Api
  module V1
    class CartsController < Api::V1::BaseController
      skip_before_action :require_jwt
      before_action :load_user, only: %i[index checkout payment_momo]

      def success
        secretKey = 'K951B6PE1waDMi640xX08PD3vg6EkVlz'
        rawSignature = 'http://localhost:3000/api/v1/checkout_success?partnerCode=MOMO&orderId=595f5241-2c47-47d9-af2f-a6b586a2aa29&requestId=2159428c-037d-4c92-8d9e-d4c77b369418&amount=60000&orderInfo=pay+with+MoMo&orderType=momo_wallet&transId=2644569745&resultCode=0&message=Giao+d%E1%BB%8Bch+th%C3%A0nh+c%C3%B4ng.&payType=qr&responseTime=1645076866338&extraData=&signature=92b4c1e15e093ea457955d7533347cc64ea28f8a0c0f9e11dcf89b9051177d9e'
        signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secretKey, rawSignature)
        render json: success_message('Successfully') if params[:resultCode] == '0'
        # render json: error_message('error_message')
      end

      def base_checkout(data, voucher_code, method_shipping)
        temp_carts = []
        data.select { |_, value| temp_carts << value }
        carts_order = []
        product_ids = temp_carts.pluck('id').compact
        total_order = 0
        products = Product.where(id: product_ids).index_by(&:id)
        check_voucher = Voucher.find_by(code: voucher_code)
        check_shipping = Shipping.find_by(id: method_shipping)

        temp_carts.map do |p|
          product = products[p[:id].to_i]
          return  @negative = true if p['quantity'].to_i.negative?

          if product.availability&.status == OrderItem::STOCK[:Outstock] || product.availability&.number_instock.to_i < p['quantity'].to_i
            return result = { carts_order: [] }
          end

          product_size = product.sizes&.pluck(:name)

          if product.nil? || product_size.include?(p[:size_product]) != true || product.price != p[:price_product].to_f || product.title != p[:name_product] || p[:image_product] != url_for(product.image)
            carts_order = []
            return
          end
          number_instock_product = product.availability.number_instock - p[:quantity].to_i
          if number_instock_product == OrderItem::STOCK[:Outstock]
            product.availability&.update_columns(number_instock: number_instock_product.to_i,
                                                 is_ordering: product.availability.is_ordering + p[:quantity].to_i,
                                                 status: OrderItem::STOCK[:Outstock])
          else
            product.availability.update_columns(number_instock: number_instock_product,
                                                is_ordering: product.availability.is_ordering + p[:quantity].to_i,
                                                status: OrderItem::STOCK[:Instock])
          end

          carts_order << { id: p[:id],
                           name_product: p[:name_product],
                           price_product: p[:price_product],
                           size_product: p[:size_product],
                           quantity: p[:quantity].to_i,
                           image_product: p[:image_product],
                           total: p[:price_product].to_f * p[:quantity].to_i }
        end
        voucher_cost = check_voucher&.expire&.future? ? check_voucher.cost.to_f : 0
        total_order = carts_order.sum do |cart_order|
          cart_order[:total].to_f
        end - voucher_cost + check_shipping.price
        results = { total_order: total_order, voucher_cost: voucher_cost, check_shipping: check_shipping,
                    carts_order: carts_order }
      end

      def checkout
        data = base_checkout(params[:data], params[:voucher_code], params[:method_shipping])
        if @negative
          render json: error_message('negative')
          return
        end
        if data[:carts_order].size.positive? && data[:check_shipping]
          product_order = @user.order_items.new(user_id: @user.id, status: Product::STATUS[:pending],
                                                product_order: data[:carts_order].to_json,
                                                total_order: data[:total_order],
                                                voucher: data[:voucher_cost],
                                                service: data[:check_shipping].name,
                                                fee: data[:check_shipping].price)
          if product_order.save
            SendEmailJob.set(wait: 1.minutes).perform_later(@user, product_order)
            render json: success_message('Successfully', product_order: product_order)
            # OrderMailer.send_order(@user, product_order).deliver
          end
        else
          render json: error_message('shopping cart is invalid or does not exist')
        end
      end

      def payment_momo
        data = params[:data]
        voucher_code = params[:voucher_code]
        method_shipping = params[:method_shipping]
        temp_carts = []
        data.select { |_, value| temp_carts << value }
        carts_order = []
        product_ids = temp_carts.pluck('id').compact
        total_order = 0
        products = Product.where(id: product_ids).index_by(&:id)
        check_voucher = Voucher.find_by(code: voucher_code)
        check_shipping = Shipping.find_by(id: method_shipping)

        temp_carts.map do |p|
          product = products[p[:id].to_i]
          product_size = product.sizes&.pluck(:name)

          if product.nil? || product_size.include?(p[:size_product]) != true || product.price != p[:price_product].to_f || product.title != p[:name_product] || p[:image_product] != url_for(product.image)
            carts_order = []
            return
          end
          carts_order << { id: p[:id],
                           name_product: p[:name_product],
                           price_product: p[:price_product],
                           size_product: p[:size_product],
                           quantity: p[:quantity],
                           image_product: p[:image_product],
                           total: p[:price_product].to_f * p[:quantity].to_i }
        end
        voucher_cost = check_voucher&.expire&.future? ? check_voucher.cost.to_f : 0
        total_order = carts_order.sum do |cart_order|
          cart_order[:total].to_f
        end - voucher_cost + check_shipping.price
        endpoint = 'https://test-payment.momo.vn/v2/gateway/api/create'
        partnerCode = 'MOMO'
        accessKey = 'F8BBA842ECF85'
        secretKey = 'K951B6PE1waDMi640xX08PD3vg6EkVlz'
        orderInfo = 'pay with MoMo'
        redirectUrl = 'http://shopmrkatsu.tk/en/users/carts'
        ipnUrl = users_carts_path
        amount = (total_order * 22.790 * 1000).to_i.to_s
        orderId = SecureRandom.uuid
        requestId = SecureRandom.uuid
        requestType = 'captureWallet'
        extraData = '' # pass empty value or Encode base64 JsonString

        # before sign HMAC SHA256 with format: accessKey=$accessKey&amount=$amount&extraData=$extraData&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$partnerCode&redirectUrl=$redirectUrl&requestId=$requestId&requestType=$requestType
        rawSignature = "accessKey=#{accessKey}&amount=#{amount}&extraData=#{extraData}&ipnUrl=#{ipnUrl}&orderId=#{orderId}&orderInfo=#{orderInfo}&partnerCode=#{partnerCode}&redirectUrl=#{redirectUrl}&requestId=#{requestId}&requestType=#{requestType}"
        # puts raw signature
        puts '--------------------RAW SIGNATURE----------------'
        puts rawSignature
        # signature
        signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secretKey, rawSignature)
        puts '--------------------SIGNATURE----------------'
        puts signature

        # json object send to MoMo endpoint
        jsonRequestToMomo = {
          partnerCode: partnerCode,
          partnerName: 'Test',
          storeId: 'MomoTestStore',
          requestId: requestId,
          amount: amount,
          orderId: orderId,
          orderInfo: orderInfo,
          redirectUrl: redirectUrl,
          ipnUrl: ipnUrl,
          lang: 'vi',
          extraData: extraData,
          requestType: requestType,
          signature: signature
        }
        puts '--------------------JSON REQUEST----------------'
        puts JSON.pretty_generate(jsonRequestToMomo)
        # Create the HTTP objects
        uri = URI.parse(endpoint)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new(uri.path)
        request.add_field('Content-Type', 'application/json')
        request.body = jsonRequestToMomo.to_json

        # Send the request and get the response
        puts 'SENDING....'
        response = http.request(request)
        result = JSON.parse(response.body)
        puts '--------------------RESPONSE----------------'
        puts JSON.pretty_generate(result)
        render json: success_message('Successfully', url: result['payUrl'])
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
