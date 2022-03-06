# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :require_jwt

      protected

      def success_message(message, content = {})
        ResponseTemplate.success(message, content)
      end

      def error_message(message, content = {})
        ResponseTemplate.error(message, content)
      end

      def unauthorized_message(message, content = {})
        ResponseTemplate.unauthorized(message, content)
      end

      def require_jwt
        token = request.headers['Authorization']
        return render json: unauthorized_message('Unauthorized JWT empty') unless token

        render json: unauthorized_message('Unauthorized JWT not valid') unless valid_token(token)
      end

      private

      def valid_token(token)
        return false unless token

        token.gsub!('Bearer ', '')
        hmac_secret = 'rubyk01'
        begin
          decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
          decoded_token.first['data'] == 'shopvn.com'
        rescue JWT::DecodeError
          false
        end
      end
    end
  end
end
