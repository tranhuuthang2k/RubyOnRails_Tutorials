class CheckoutsController < ApplicationController
  def index
    notifications = Notification.newest.limit(5)

    shippings = current_user ? current_user.city.shippings : []
    @results = {
      notifications: notifications,
      shippings: shippings
    }
  end

  def create
    notifications = Notification.newest.limit(5)

    shippings = current_user ? current_user.city.shippings : []
    @results = {
      notifications: notifications,
      shippings: shippings
    }
    vnp_url =  vnpay
    redirect_to vnp_url
  end

  def fallback
    if checksum_valid!
      if params['vnp_ResponseCode'] == '00'
        # current_user.cart.clear
        flash[:success] = t('.payment_success')
        # redirect_to books_path
      else
        flash[:error] = t('.payment_failed')
        # redirect_to checkouts_path
      end
    else
      flash[:error] = t('.payment_failed')
      # redirect_to checkouts_path
    end
  end

  private

  def vnpay
    # Mã website bên VNPAY cung cấp ban đầu cho mình
    vnp_tmncode = "AR2OKUBC"
    # Chuỗi kí tự dùng cho việc mã hóa tham số do bên VNPAY cung cấp
    vnp_hash_secret = "XLZYVMKQPJXRFQSDTTMJYOGAMLRGRHSI"
    vnp_url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html"
    vnp_txnref = "23554"
    vnp_order_info = "Thanh toan mua hang"
    vnp_order_type = "200000"
    vnp_amount = OrderItem.last.total_order * 100
    vnp_local = "vn"
    vnp_ipadd = request.remote_ip
    vnp_BankCode "NCB"
    input_data = {
      "vnp_Amount" => vnp_amount,
      "vnp_Command" => "pay",
      "vnp_CreateDate" => "20170829103111",
      "vnp_CurrCode" => "VND",
      "vnp_IpAddr" => vnp_ipadd,
      "vnp_Locale" => vnp_local,
      "vnp_OrderInfo" => vnp_order_info,
      "vnp_OrderType" => vnp_order_type,
      "vnp_ReturnUrl" => "http://localhost:3000/users/carts",
      "vnp_TmnCode" => vnp_tmncode,
      "vnp_TxnRef" => vnp_txnref,
      "vnp_Version" => "2.0.1",
    }
    original_data = input_data.map do |key, value|
      "#{key}=#{value}"
    end.join("&")

    vnp_url = vnp_url + "?" + input_data.to_query
    vnp_security_hash = Digest::SHA256.hexdigest(vnp_hash_secret + original_data)
    vnp_url += '&vnp_SecureHashType=SHA256&vnp_SecureHash=' + vnp_security_hash
    vnp_url
  end

  def checksum_valid!
    vnp_secure_hash = "SHA256"
    data = response_params.to_h.map do |key, value|
      "#{key}=#{value}"
    end.join('&')

    secure_hash = Digest::SHA256.hexdigest('XLZYVMKQPJXRFQSDTTMJYOGAMLRGRHSI' + data)
    vnp_secure_hash == secure_hash
  end

  def response_params
    params.permit('vnp_Amount', 'vnp_BankCode', 'vnp_BankTranNo', 'vnp_CardType', 'vnp_OrderInfo', 'vnp_PayDate',
                  'vnp_ResponseCode', 'vnp_TmnCode', 'vnp_TransactionNo', 'vnp_TxnRef')
  end

  def vnp_ipn
    logger = Logger.new("#{Rails.root}/log/payment_#{Date.today}.log")
    response_data = []
    if checksum_valid!
      permit_params = response_params
      order_object = Order.find_by_id(permit_params['vnp_TxnRef'])
      if order_object
        if order_object.total_price_cents == (permit_params['vnp_Amount'].to_i / 100)
          if order_object.pending?
            if permit_params['vnp_ResponseCode'] == '00'
              order_object.set_paid
            else
              order_object.set_failed
            end
            # save vnp_TransactionNo
            order_object.transaction_id = permit_params['vnp_TransactionNo']
            order_object.save!

            code = '00'
            message = 'Confirm Success'
          else
            code = '02'
            message = 'Order already confirmed'
          end
        else
          code = '04'
          message = 'Invalid amount'
        end
      else
        code = '01'
        message = 'Order not found'
      end
    else
      code = '97'
      message = 'Invalid Checksum'
    end

    logger.info('VNPAY with params: ' + permit_params.to_s + ", code: #{code}, message: #{message}")

    render json: { "RspCode": code, "Message": message }
  rescue StandardError => e
    logger.error('VNPAY with params: ' + permit_params.to_s + ', ' + e.message)
    render json: { "RspCode": '99', "Message": 'Unknow error' }
  end
end
