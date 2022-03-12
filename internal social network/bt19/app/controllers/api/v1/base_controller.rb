# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :sign_in
      skip_before_action :redirect_to_users
      skip_before_action :verify_authenticity_token

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

      def api_token?
        request.headers['Api-Token'].present?
      end

      def current_user
        @current_user ||= User.find_by(api_token_digest: request.headers['Api-Token'])
      end

      def verify_token
        return if api_token? && current_user

        render json: unauthorized_message('Unauthorized not valid')
      end
    end
  end
end
