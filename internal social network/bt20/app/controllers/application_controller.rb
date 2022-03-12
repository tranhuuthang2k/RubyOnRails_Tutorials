# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include CommentsHelper

  before_action :current_order

  before_action :switch_locale
  before_action :sign_in, :redirect_to_users

  def switch_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
      # session.delete(:order_id)
    else
      Order.new
    end
  end
end
