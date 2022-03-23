# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :switch_locale

  def switch_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: exception.message
  end

  def store_location
    session[:previous_url] = request.fullpath
  end

  def set_api_token(current_user)
    if user_signed_in?
      payload = { data: current_user.generate_token }
      hmac_secret = 'rubyk01'
      token = JWT.encode payload, hmac_secret, 'HS256'
      cookies.permanent[:api_token] = token
    end
  end

  def after_sign_in_path_for(resource)
    set_api_token(current_user)
    if current_user.admin?
      stored_location_for(resource) || rails_admin_path
    else
      previous_path = session[:previous_url]
      session[:previous_url] = nil
      previous_path || root_path
    end
  end
end
