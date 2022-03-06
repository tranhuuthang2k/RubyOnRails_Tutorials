# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]
    before_action :load_notification
    # GET /resource/sign_up

    # DELETE /resource

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[username mobile city_id])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update,
                                        keys: %i[username mobile email address gender password avatar city_id])
    end

    def after_update_path_for(_resource)
      users_carts_path
    end

    def update_resource(resource, params)
      resource.update(params)
    end

    def load_notification
      notifications = Notification.newest.limit(5)
      cities = City.all
      @results = {
        notifications: notifications,
        cities: cities
      }
    end
  end
end
