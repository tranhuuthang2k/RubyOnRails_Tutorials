# frozen_string_literal: true

class CartsController < ApplicationController
  # require 'openssl'
  # require 'base64'
  # require 'json'
  def index
    data = helpers.product_history_view
    shippings = current_user ? current_user.city.shippings : []
    # rawData = {
    #   :partnerCode => params[:partnerCode],
    #   :requestId =>  params[:requestId],
    #   :amount => params[:amount],
    #   :signature => params[:signature]
    # }
    # # load key

    # key =  OpenSSL::PKey::RSA.new (File.read 'lib/concerns/mykey.pem')
    # encrypted_string = key.public_encrypt(JSON.pretty_generate(rawData))
    # encoded_str = Base64.encode64(encrypted_string)
    @results = {
      notifications: data[:notifications],
      shippings: shippings,
      history_products: data[:history_products]
    }
  end
end
